import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zee_palm_tasks/features/video/data/models/video_model.dart';
import 'package:zee_palm_tasks/features/video/data/repositories/video_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

// Real-time videos provider
final videosProvider = StreamProvider<List<VideoModel>>((ref) {
  final repository = ref.read(videoRepositoryProvider);
  return repository.getVideosStream();
});

// Real-time user videos provider
final userVideosProvider = StreamProvider.family<List<VideoModel>, String>((
  ref,
  userId,
) {
  final repository = ref.read(videoRepositoryProvider);
  return repository.getUserVideosStream(userId);
});
