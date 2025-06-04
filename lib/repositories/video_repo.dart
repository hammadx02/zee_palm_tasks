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
