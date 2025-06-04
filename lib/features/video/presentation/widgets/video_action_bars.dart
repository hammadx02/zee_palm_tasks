// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:zee_palm_tasks/models/video_model.dart';
// // import 'package:zee_palm_tasks/providers/video_provider.dart';

// // class VideoActionsBar extends ConsumerStatefulWidget {
// //   final VideoModel video;
// //   final String userId;

// //   const VideoActionsBar({super.key, required this.video, required this.userId});

// //   @override
// //   ConsumerState<VideoActionsBar> createState() => _VideoActionsBarState();
// // }

// // class _VideoActionsBarState extends ConsumerState<VideoActionsBar> {
// //   bool isLiked = false;
// //   bool isSaved = false;
// //   bool isDownloading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     isLiked = widget.video.likedBy.contains(widget.userId);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         IconButton(
// //           icon: Icon(
// //             isLiked ? Icons.favorite : Icons.favorite_border,
// //             color: isLiked ? Colors.red : Colors.white,
// //             size: 32,
// //           ),
// //           onPressed: () async {
// //             setState(() => isLiked = !isLiked);
// //             final repository = ref.read(videoRepositoryProvider);
// //             await repository.likeVideo(
// //               videoId: widget.video.id,
// //               userId: widget.userId,
// //               isLiked: !isLiked,
// //             );
// //           },
// //         ),
// //         const SizedBox(height: 20),
// //         IconButton(
// //           icon: Icon(
// //             isSaved ? Icons.bookmark : Icons.bookmark_border,
// //             color: Colors.white,
// //             size: 32,
// //           ),
// //           onPressed: () {
// //             setState(() => isSaved = !isSaved);
// //             // Implement save functionality
// //           },
// //         ),
// //         const SizedBox(height: 20),
// //         IconButton(
// //           icon:
// //               isDownloading
// //                   ? const CircularProgressIndicator(color: Colors.white)
// //                   : const Icon(Icons.download, color: Colors.white, size: 32),
// //           onPressed: () async {
// //             if (isDownloading) return;
// //             setState(() => isDownloading = true);
// //             final repository = ref.read(videoRepositoryProvider);
// //             final result = await repository.downloadVideo(
// //               widget.video.videoUrl,
// //             );
// //             setState(() => isDownloading = false);
// //             result.fold(
// //               (failure) => ScaffoldMessenger.of(
// //                 context,
// //               ).showSnackBar(SnackBar(content: Text(failure.toString()))),
// //               (url) => ScaffoldMessenger.of(
// //                 context,
// //               ).showSnackBar(const SnackBar(content: Text('Video downloaded'))),
// //             );
// //           },
// //         ),
// //         const SizedBox(height: 20),
// //         const Icon(Icons.share, color: Colors.white, size: 32),
// //       ],
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:zee_palm_tasks/models/video_model.dart';
// import 'package:zee_palm_tasks/providers/video_provider.dart';
// import 'package:zee_palm_tasks/utils/snakbar.dart';

// class VideoActionsBar extends ConsumerStatefulWidget {
//   final VideoModel video;
//   final String userId;

//   const VideoActionsBar({super.key, required this.video, required this.userId});

//   @override
//   ConsumerState<VideoActionsBar> createState() => _VideoActionsBarState();
// }

// class _VideoActionsBarState extends ConsumerState<VideoActionsBar> {
//   bool isLiked = false;
//   bool isSaved = false;
//   bool isDownloading = false;

//   @override
//   void initState() {
//     super.initState();
//     isLiked = widget.video.likedBy.contains(widget.userId);
//     // Initialize isSaved based on Firestore data (assuming a 'savedBy' field)
//     isSaved = widget.video.savedBy?.contains(widget.userId) ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: Icon(
//               isLiked ? Icons.favorite : Icons.favorite_border,
//               color:
//                   isLiked ? Theme.of(context).colorScheme.error : Colors.white,
//               size: 28,
//             ),
//             onPressed: () async {
//               final newLikeState = !isLiked;
//               setState(() => isLiked = newLikeState);
//               final repository = ref.read(videoRepositoryProvider);
//               final result = await repository.toggleLike(
//                 widget.video.id,
//                 widget.userId,
//               );
//               result.fold((failure) {
//                 setState(() => isLiked = !newLikeState); // Revert on failure
//                 showSnackBar(context, failure);
//               }, (_) => showSnackBar(context, isLiked ? 'Liked' : 'Unliked'));
//             },
//           ).animate().scale(duration: 200.ms, curve: Curves.easeOut),
//           const SizedBox(height: 12),
//           IconButton(
//             icon: Icon(
//               isSaved ? Icons.bookmark : Icons.bookmark_border,
//               color:
//                   isSaved
//                       ? Theme.of(context).colorScheme.secondary
//                       : Colors.white,
//               size: 28,
//             ),
//             onPressed: () async {
//               final newSaveState = !isSaved;
//               setState(() => isSaved = newSaveState);
//               final repository = ref.read(videoRepositoryProvider);
//               final result = await repository.saveVideo(
//                 widget.video.id,
//                 widget.userId,
//                 newSaveState,
//               );
//               result.fold((failure) {
//                 setState(() => isSaved = !newSaveState); // Revert on failure
//                 showSnackBar(context, failure);
//               }, (_) => showSnackBar(context, isSaved ? 'Saved' : 'Unsaved'));
//             },
//           ).animate().scale(
//             duration: 200.ms,
//             curve: Curves.easeOut,
//             delay: 50.ms,
//           ),
//           const SizedBox(height: 12),
//           IconButton(
//             icon:
//                 isDownloading
//                     ? const CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2,
//                     )
//                     : Icon(
//                       Icons.download_rounded,
//                       color: Colors.white,
//                       size: 28,
//                     ),
//             onPressed: () async {
//               final result = await downloadVideo(
//                 'https://example.com/sample.mp4',
//               );
//               result.fold(
//                 (error) => print(error), // Handle error
//                 (_) => print('Video saved to gallery successfully'),
//               );
//             },
//             // isDownloading
//             //     ? null
//             //     : () async {
//             //       setState(() => isDownloading = true);
//             //       final repository = ref.read(videoRepositoryProvider);
//             //       final result = await repository.downloadVideo(
//             //         widget.video.videoUrl,
//             //       );
//             //       setState(() => isDownloading = false);
//             //       result.fold(
//             //         (failure) => showSnackBar(context, failure),
//             //         (_) => showSnackBar(context, 'Video downloaded'),
//             //       );
//             //     },
//           ).animate().scale(
//             duration: 200.ms,
//             curve: Curves.easeOut,
//             delay: 100.ms,
//           ),
//           const SizedBox(height: 12),
//           IconButton(
//             icon: const Icon(
//               Icons.share_rounded,
//               color: Colors.white,
//               size: 28,
//             ),
//             onPressed: () {
//               Share.share(
//                 'Check out this video on ZeePalm: ${widget.video.videoUrl}',
//                 subject: 'ZeePalm Video',
//               );
//             },
//           ).animate().scale(
//             duration: 200.ms,
//             curve: Curves.easeOut,
//             delay: 150.ms,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zee_palm_tasks/features/video/data/models/video_model.dart';
import 'package:zee_palm_tasks/features/video/presentation/video_provider.dart';
import 'package:zee_palm_tasks/core/utils/snakbar.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

import 'package:permission_handler/permission_handler.dart';

class VideoActionsBar extends ConsumerStatefulWidget {
  final VideoModel video;
  final String userId;

  const VideoActionsBar({super.key, required this.video, required this.userId});

  @override
  ConsumerState<VideoActionsBar> createState() => _VideoActionsBarState();
}

class _VideoActionsBarState extends ConsumerState<VideoActionsBar> {
  bool isLiked = false;
  bool isSaved = false;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.video.likedBy.contains(widget.userId);
    isSaved = widget.video.savedBy?.contains(widget.userId) ?? false;
  }

  // Download video function
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color:
                  isLiked ? Theme.of(context).colorScheme.error : Colors.white,
              size: 28,
            ),
            onPressed: () async {
              final newLikeState = !isLiked;
              setState(() => isLiked = newLikeState);
              final repository = ref.read(videoRepositoryProvider);
              final result = await repository.toggleLike(
                widget.video.id,
                widget.userId,
              );
              result.fold((failure) {
                setState(() => isLiked = !newLikeState); // Revert on failure
                showSnackBar(context, failure);
              }, (_) => showSnackBar(context, isLiked ? 'Liked' : 'Unliked'));
            },
          ).animate().scale(duration: 200.ms, curve: Curves.easeOut),
          const SizedBox(height: 12),
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color:
                  isSaved
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.white,
              size: 28,
            ),
            onPressed: () async {
              final newSaveState = !isSaved;
              setState(() => isSaved = newSaveState);
              final repository = ref.read(videoRepositoryProvider);
              final result = await repository.saveVideo(
                widget.video.id,
                widget.userId,
                newSaveState,
              );
              result.fold((failure) {
                setState(() => isSaved = !newSaveState); // Revert on failure
                showSnackBar(context, failure);
              }, (_) => showSnackBar(context, isSaved ? 'Saved' : 'Unsaved'));
            },
          ).animate().scale(
            duration: 200.ms,
            curve: Curves.easeOut,
            delay: 50.ms,
          ),
          const SizedBox(height: 12),
          IconButton(
            icon:
                isDownloading
                    ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                    : const Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
            onPressed:
                isDownloading
                    ? null
                    : () async {
                      setState(() => isDownloading = true);
                      final result = await downloadVideo(widget.video.videoUrl);
                      setState(() => isDownloading = false);
                      result.fold(
                        (error) => showSnackBar(context, error),
                        (_) => showSnackBar(
                          context,
                          'Video saved to gallery successfully',
                        ),
                      );
                    },
          ).animate().scale(
            duration: 200.ms,
            curve: Curves.easeOut,
            delay: 100.ms,
          ),
          const SizedBox(height: 12),
          // IconButton(
          //   icon: const Icon(
          //     Icons.share_rounded,
          //     color: Colors.white,
          //     size: 28,
          //   ),
          //   onPressed: () {
          //     Share.share(
          //       'Check out this video on ZeePalm: ${widget.video.videoUrl}',
          //       subject: 'ZeePalm Video',
          //     );
          //   },
          // ).animate().scale(
          //   duration: 200.ms,
          //   curve: Curves.easeOut,
          //   delay: 150.ms,
          // ),
        ],
      ),
    );
  }
}
