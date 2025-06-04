// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:zee_palm_tasks/models/video_model.dart';
// // import 'package:zee_palm_tasks/repositories/video_repo.dart';

// // final firestoreProvider = Provider<FirebaseFirestore>((ref) {
// //   return FirebaseFirestore.instance;
// // });

// // final storageProvider = Provider<FirebaseStorage>((ref) {
// //   return FirebaseStorage.instance;
// // });

// // final userVideosProvider = FutureProvider.family<List<VideoModel>, String>((
// //   ref,
// //   userId,
// // ) async {
// //   final repository = ref.read(videoRepositoryProvider);
// //   final result = await repository.getUserVideos(userId);
// //   return result.fold((l) => throw l, (r) => r);
// // });

// // final videoRepositoryProvider = Provider<VideoRepository>((ref) {
// //   return VideoRepository(
// //     ref.read(firestoreProvider),
// //     ref.read(storageProvider),
// //   );
// // });

// // final videosProvider = FutureProvider<List<VideoModel>>((ref) async {
// //   final repository = ref.read(videoRepositoryProvider);
// //   final result = await repository.getVideos();
// //   return result.fold((l) => throw l, (r) => r);
// // });

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:zee_palm_tasks/models/video_model.dart';
// import 'package:zee_palm_tasks/repositories/video_repo.dart';

// final firestoreProvider = Provider<FirebaseFirestore>((ref) {
//   return FirebaseFirestore.instance;
// });

// final storageProvider = Provider<FirebaseStorage>((ref) {
//   return FirebaseStorage.instance;
// });

// final videoRepositoryProvider = Provider<VideoRepository>((ref) {
//   return VideoRepository(
//     ref.read(firestoreProvider),
//     ref.read(storageProvider),
//   );
// });

// // final videosProvider = AsyncNotifierProvider<VideosNotifier, List<VideoModel>>(
// //   VideosNotifier.new,
// // );
// final videosProvider = StreamProvider<List<VideoModel>>((ref) {
//   final repository = ref.read(videoRepositoryProvider);
//   return repository.getVideos();
// });

// class VideosNotifier extends AsyncNotifier<List<VideoModel>> {
//   @override
//   Future<List<VideoModel>> build() async {
//     final repository = ref.read(videoRepositoryProvider);
//     final result = await repository.getVideos();
//     return result.fold(
//       (failure) => throw Exception(failure),
//       (videos) => videos,
//     );
//   }

//   Future<void> refresh() async {
//     state = const AsyncValue.loading();
//     state = await AsyncValue.guard(() async {
//       final repository = ref.read(videoRepositoryProvider);
//       final result = await repository.getVideos();
//       return result.fold(
//         (failure) => throw Exception(failure),
//         (videos) => videos,
//       );
//     });
//   }
// }

// final userVideosProvider = FutureProvider.family<List<VideoModel>, String>((
//   ref,
//   userId,
// ) async {
//   final repository = ref.read(videoRepositoryProvider);
//   final result = await repository.getUserVideos(userId);
//   return result.fold((failure) => throw Exception(failure), (videos) => videos);
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zee_palm_tasks/models/video_model.dart';
import 'package:zee_palm_tasks/repositories/video_repo.dart';
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
