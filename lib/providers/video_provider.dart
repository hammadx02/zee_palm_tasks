import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:zee_palm_tasks/models/video_model.dart';
import 'package:zee_palm_tasks/repositories/video_repo.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final storageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return VideoRepository(
    ref.read(firestoreProvider),
    ref.read(storageProvider),
  );
});

final videosProvider = FutureProvider<List<VideoModel>>((ref) async {
  final repository = ref.read(videoRepositoryProvider);
  final result = await repository.getVideos();
  return result.fold((l) => throw l, (r) => r);
});
