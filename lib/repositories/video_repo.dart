import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:dartz/dartz.dart';
import 'package:zee_palm_tasks/errors/failures.dart';
import 'package:zee_palm_tasks/models/video_model.dart';

class VideoRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  VideoRepository(this._firestore, this._storage);

  Future<Either<Failure, List<VideoModel>>> getVideos() async {
    try {
      final snapshot = await _firestore.collection('videos').get();
      final videos =
          snapshot.docs.map((doc) => VideoModel.fromMap(doc.data())).toList();
      return Right(videos);
    } catch (e) {
      return Left(Failure('Failed to fetch videos'));
    }
  }

  Future<Either<Failure, List<VideoModel>>> getUserVideos(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection('videos')
              .where('authorId', isEqualTo: userId)
              .get();
      final videos =
          snapshot.docs.map((doc) => VideoModel.fromMap(doc.data())).toList();
      return Right(videos);
    } catch (e) {
      return Left(Failure('Failed to fetch user videos'));
    }
  }

  Future<Either<Failure, void>> deleteVideo(
    String videoId,
    String userId,
  ) async {
    try {
      final doc = await _firestore.collection('videos').doc(videoId).get();
      if (!doc.exists || doc.data()?['authorId'] != userId) {
        return Left(Failure('Not authorized to delete this video'));
      }

      // Delete video from storage
      final videoUrl = doc.data()?['videoUrl'];
      if (videoUrl != null) {
        await _storage.refFromURL(videoUrl).delete();
      }

      // Delete thumbnail from storage
      final thumbnailUrl = doc.data()?['thumbnailUrl'];
      if (thumbnailUrl != null) {
        await _storage.refFromURL(thumbnailUrl).delete();
      }

      // Delete document
      await _firestore.collection('videos').doc(videoId).delete();

      return const Right(null);
    } catch (e) {
      return Left(Failure('Failed to delete video'));
    }
  }

  Future<Either<Failure, void>> likeVideo({
    required String videoId,
    required String userId,
    required bool isLiked,
  }) async {
    try {
      final docRef = _firestore.collection('videos').doc(videoId);
      if (isLiked) {
        await docRef.update({
          'likes': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([userId]),
        });
      } else {
        await docRef.update({
          'likes': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([userId]),
        });
      }
      return const Right(null);
    } catch (e) {
      return Left(Failure('Failed to update like status'));
    }
  }

  Future<Either<Failure, String>> downloadVideo(String videoUrl) async {
    try {
      final ref = _storage.refFromURL(videoUrl);
      final downloadUrl = await ref.getDownloadURL();
      return Right(downloadUrl);
    } catch (e) {
      return Left(Failure('Failed to download video'));
    }
  }
}
