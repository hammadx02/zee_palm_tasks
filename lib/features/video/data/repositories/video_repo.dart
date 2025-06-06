import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zee_palm_tasks/features/video/data/models/video_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class VideoRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  VideoRepository(this._firestore, this._storage);

  // Real-time stream of all videos
  Stream<List<VideoModel>> getVideosStream() {
    return _firestore
        .collection('videos')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError(
          (error) => throw Exception('Failed to fetch videos: $error'),
        )
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => VideoModel.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  // Real-time stream of user-specific videos
  Stream<List<VideoModel>> getUserVideosStream(String userId) {
    return _firestore
        .collection('videos')
        .where('authorId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError(
          (error) => throw Exception('Failed to fetch user videos: $error'),
        )
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => VideoModel.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  Future<Either<String, Unit>> toggleLike(String videoId, String userId) async {
    try {
      final videoRef = _firestore.collection('videos').doc(videoId);
      return _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(videoRef);
        if (!doc.exists) return Left('Video not found');

        final data = doc.data()!;
        final likedBy = List<String>.from(data['likedBy'] ?? []);
        final likes = data['likes'] as int? ?? 0;

        if (likedBy.contains(userId)) {
          likedBy.remove(userId);
          transaction.update(videoRef, {
            'likedBy': likedBy,
            'likes': likes - 1,
          });
        } else {
          likedBy.add(userId);
          transaction.update(videoRef, {
            'likedBy': likedBy,
            'likes': likes + 1,
          });
        }
        return Right(unit);
      });
    } catch (e) {
      return Left('Failed to toggle like: $e');
    }
  }

  Future<Either<String, Unit>> saveVideo(
    String videoId,
    String userId,
    bool isSaved,
  ) async {
    try {
      final videoRef = _firestore.collection('videos').doc(videoId);
      final video = await videoRef.get();
      if (!video.exists) return Left('Video not found');

      final savedBy = List<String>.from(video.data()!['savedBy'] ?? []);
      if (isSaved && !savedBy.contains(userId)) {
        savedBy.add(userId);
        await videoRef.update({'savedBy': savedBy});
      } else if (!isSaved && savedBy.contains(userId)) {
        savedBy.remove(userId);
        await videoRef.update({'savedBy': savedBy});
      }
      return Right(unit);
    } catch (e) {
      return Left('Failed to save video: $e');
    }
  }

  // Future<Either<String, Unit>> downloadVideo(String videoUrl) async {
  //   try {
  //     final response = await http.get(Uri.parse(videoUrl));
  //     if (response.statusCode != 200) {
  //       return Left('Failed to download video: HTTP ${response.statusCode}');
  //     }

  //     final directory = await getTemporaryDirectory();
  //     final fileName = videoUrl.split('/').last.split('?').first;
  //     final file = File('${directory.path}/$fileName');
  //     await file.writeAsBytes(response.bodyBytes);

  //     return Right(unit);
  //   } catch (e) {
  //     return Left('Failed to download video: $e');
  //   }
  // }

  Future<Either<String, Unit>> downloadVideo(String videoUrl) async {
    try {
      // Request storage permission
      if (await Permission.storage.request().isDenied) {
        return Left('Storage permission denied');
      }

      // Download the video
      final response = await http.get(Uri.parse(videoUrl));
      if (response.statusCode != 200) {
        return Left('Failed to download video: HTTP ${response.statusCode}');
      }

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final fileName = videoUrl.split('/').last.split('?').first;
      final file = File('${directory.path}/$fileName');

      // Write video to temporary file
      await file.writeAsBytes(response.bodyBytes);

      // Save video to gallery using gallery_saver_plus
      final result = await GallerySaver.saveVideo(
        file.path,
        albumName: 'Downloads',
      );
      if (result != true) {
        return Left('Failed to save video to gallery');
      }

      return Right(unit);
    } catch (e) {
      return Left('Failed to download video: $e');
    }
  }

  Future<Either<String, Unit>> deleteVideo(
    String videoId,
    String userId,
  ) async {
    try {
      final videoRef = _firestore.collection('videos').doc(videoId);
      final video = await videoRef.get();
      if (!video.exists || video.data()!['authorId'] != userId) {
        return Left('Unauthorized or video not found');
      }

      final data = video.data()!;
      final videoUrl = data['videoUrl'] as String?;
      final thumbnailUrl = data['thumbnailUrl'] as String?;

      if (videoUrl != null) {
        await _storage.refFromURL(videoUrl).delete();
      }
      if (thumbnailUrl != null) {
        await _storage.refFromURL(thumbnailUrl).delete();
      }

      await videoRef.delete();
      return Right(unit);
    } catch (e) {
      return Left('Failed to delete video: $e');
    }
  }
}
