// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_storage/firebase_storage.dart';

// // import 'package:dartz/dartz.dart';
// // import 'package:zee_palm_tasks/errors/failures.dart';
// // import 'package:zee_palm_tasks/models/video_model.dart';

// // class VideoRepository {
// //   final FirebaseFirestore _firestore;
// //   final FirebaseStorage _storage;

// //   VideoRepository(this._firestore, this._storage);

// //   Future<Either<Failure, List<VideoModel>>> getVideos() async {
// //     try {
// //       final snapshot = await _firestore.collection('videos').get();
// //       final videos =
// //           snapshot.docs.map((doc) => VideoModel.fromMap(doc.data())).toList();
// //       return Right(videos);
// //     } catch (e) {
// //       return Left(Failure('Failed to fetch videos'));
// //     }
// //   }

// //   Future<Either<Failure, List<VideoModel>>> getUserVideos(String userId) async {
// //     try {
// //       final snapshot =
// //           await _firestore
// //               .collection('videos')
// //               .where('authorId', isEqualTo: userId)
// //               .get();
// //       final videos =
// //           snapshot.docs.map((doc) => VideoModel.fromMap(doc.data())).toList();
// //       return Right(videos);
// //     } catch (e) {
// //       return Left(Failure('Failed to fetch user videos'));
// //     }
// //   }

// //   Future<Either<Failure, void>> deleteVideo(
// //     String videoId,
// //     String userId,
// //   ) async {
// //     try {
// //       final doc = await _firestore.collection('videos').doc(videoId).get();
// //       if (!doc.exists || doc.data()?['authorId'] != userId) {
// //         return Left(Failure('Not authorized to delete this video'));
// //       }

// //       // Delete video from storage
// //       final videoUrl = doc.data()?['videoUrl'];
// //       if (videoUrl != null) {
// //         await _storage.refFromURL(videoUrl).delete();
// //       }

// //       // Delete thumbnail from storage
// //       final thumbnailUrl = doc.data()?['thumbnailUrl'];
// //       if (thumbnailUrl != null) {
// //         await _storage.refFromURL(thumbnailUrl).delete();
// //       }

// //       // Delete document
// //       await _firestore.collection('videos').doc(videoId).delete();

// //       return const Right(null);
// //     } catch (e) {
// //       return Left(Failure('Failed to delete video'));
// //     }
// //   }

// //   Future<Either<Failure, void>> likeVideo({
// //     required String videoId,
// //     required String userId,
// //     required bool isLiked,
// //   }) async {
// //     try {
// //       final docRef = _firestore.collection('videos').doc(videoId);
// //       if (isLiked) {
// //         await docRef.update({
// //           'likes': FieldValue.increment(-1),
// //           'likedBy': FieldValue.arrayRemove([userId]),
// //         });
// //       } else {
// //         await docRef.update({
// //           'likes': FieldValue.increment(1),
// //           'likedBy': FieldValue.arrayUnion([userId]),
// //         });
// //       }
// //       return const Right(null);
// //     } catch (e) {
// //       return Left(Failure('Failed to update like status'));
// //     }
// //   }

// //   Future<Either<Failure, String>> downloadVideo(String videoUrl) async {
// //     try {
// //       final ref = _storage.refFromURL(videoUrl);
// //       final downloadUrl = await ref.getDownloadURL();
// //       return Right(downloadUrl);
// //     } catch (e) {
// //       return Left(Failure('Failed to download video'));
// //     }
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:zee_palm_tasks/models/video_model.dart';

// class VideoRepository {
//   final FirebaseFirestore _firestore;
//   final FirebaseStorage _storage;

//   VideoRepository(this._firestore, this._storage);

//   Future<Either<String, List<VideoModel>>> getVideos() async {
//     try {
//       final snapshot =
//           await _firestore
//               .collection('videos')
//               .orderBy('timestamp', descending: true)
//               .get();
//       final videos =
//           snapshot.docs
//               .map((doc) => VideoModel.fromMap(doc.data(), doc.id))
//               .toList();
//       return Right(videos);
//     } catch (e) {
//       return Left('Failed to fetch videos: $e');
//     }
//   }

//   Future<Either<String, List<VideoModel>>> getUserVideos(String userId) async {
//     try {
//       final snapshot =
//           await _firestore
//               .collection('videos')
//               .where('authorId', isEqualTo: userId)
//               .orderBy('timestamp', descending: true)
//               .get();
//       final videos =
//           snapshot.docs
//               .map((doc) => VideoModel.fromMap(doc.data(), doc.id))
//               .toList();
//       return Right(videos);
//     } catch (e) {
//       return Left('Failed to fetch user videos: $e');
//     }
//   }

//   Future<Either<String, Unit>> toggleLike(String videoId, String userId) async {
//     try {
//       final videoRef = _firestore.collection('videos').doc(videoId);
//       final video = await videoRef.get();
//       final data = video.data();
//       if (data == null) return Left('Video not found');

//       final likedBy = List<String>.from(data['likedBy'] ?? []);
//       final likes = data['likes'] as int? ?? 0;

//       if (likedBy.contains(userId)) {
//         likedBy.remove(userId);
//         await videoRef.update({'likedBy': likedBy, 'likes': likes - 1});
//       } else {
//         likedBy.add(userId);
//         await videoRef.update({'likedBy': likedBy, 'likes': likes + 1});
//       }
//       return Right(unit);
//     } catch (e) {
//       return Left('Failed to toggle like: $e');
//     }
//   }

//   Future<Either<String, Unit>> deleteVideo(
//     String videoId,
//     String userId,
//   ) async {
//     try {
//       final videoRef = _firestore.collection('videos').doc(videoId);
//       final video = await videoRef.get();
//       final data = video.data();
//       if (data == null || data['authorId'] != userId) {
//         return Left('Unauthorized or video not found');
//       }

//       // Delete video and thumbnail from storage
//       final videoUrl = data['videoUrl'] as String?;
//       final thumbnailUrl = data['thumbnailUrl'] as String?;
//       if (videoUrl != null) {
//         await _storage.refFromURL(videoUrl).delete();
//       }
//       if (thumbnailUrl != null) {
//         await _storage.refFromURL(thumbnailUrl).delete();
//       }

//       // Delete Firestore document
//       await videoRef.delete();
//       return Right(unit);
//     } catch (e) {
//       return Left('Failed to delete video: $e');
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zee_palm_tasks/models/video_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class VideoRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  VideoRepository(this._firestore, this._storage);

  Future<Either<String, List<VideoModel>>> getVideos() async {
    try {
      final snapshot =
          await _firestore
              .collection('videos')
              .orderBy('timestamp', descending: true)
              .get();
      final videos =
          snapshot.docs
              .map((doc) => VideoModel.fromMap(doc.data(), doc.id))
              .toList();
      return Right(videos);
    } catch (e) {
      return Left('Failed to fetch videos: $e');
    }
  }

  Future<Either<String, List<VideoModel>>> getUserVideos(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection('videos')
              .where('authorId', isEqualTo: userId)
              .orderBy('timestamp', descending: true)
              .get();
      final videos =
          snapshot.docs
              .map((doc) => VideoModel.fromMap(doc.data(), doc.id))
              .toList();
      return Right(videos);
    } catch (e) {
      return Left('Failed to fetch user videos: $e');
    }
  }

  Future<Either<String, Unit>> toggleLike(String videoId, String userId) async {
    try {
      final videoRef = _firestore.collection('videos').doc(videoId);
      final video = await videoRef.get();
      final data = video.data();
      if (data == null) return Left('Video not found');

      final likedBy = List<String>.from(data['likedBy'] ?? []);
      final likes = data['likes'] as int? ?? 0;

      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
        await videoRef.update({'likedBy': likedBy, 'likes': likes - 1});
      } else {
        likedBy.add(userId);
        await videoRef.update({'likedBy': likedBy, 'likes': likes + 1});
      }
      return Right(unit);
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
      final data = video.data();
      if (data == null) return Left('Video not found');

      final savedBy = List<String>.from(data['savedBy'] ?? []);
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

  Future<Either<String, Unit>> downloadVideo(String videoUrl) async {
    try {
      final response = await http.get(Uri.parse(videoUrl));
      if (response.statusCode != 200) {
        return Left('Failed to download video: HTTP ${response.statusCode}');
      }

      final directory = await getTemporaryDirectory();
      final fileName = videoUrl.split('/').last.split('?').first;
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);

      // Optionally, save to gallery/downloads using a plugin like image_picker_saver
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
      final data = video.data();
      if (data == null || data['authorId'] != userId) {
        return Left('Unauthorized or video not found');
      }

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
