// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:zee_palm_tasks/models/video_model.dart';
// import 'package:zee_palm_tasks/providers/video_provider.dart';

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
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         IconButton(
//           icon: Icon(
//             isLiked ? Icons.favorite : Icons.favorite_border,
//             color: isLiked ? Colors.red : Colors.white,
//             size: 32,
//           ),
//           onPressed: () async {
//             setState(() => isLiked = !isLiked);
//             final repository = ref.read(videoRepositoryProvider);
//             await repository.likeVideo(
//               videoId: widget.video.id,
//               userId: widget.userId,
//               isLiked: !isLiked,
//             );
//           },
//         ),
//         const SizedBox(height: 20),
//         IconButton(
//           icon: Icon(
//             isSaved ? Icons.bookmark : Icons.bookmark_border,
//             color: Colors.white,
//             size: 32,
//           ),
//           onPressed: () {
//             setState(() => isSaved = !isSaved);
//             // Implement save functionality
//           },
//         ),
//         const SizedBox(height: 20),
//         IconButton(
//           icon:
//               isDownloading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Icon(Icons.download, color: Colors.white, size: 32),
//           onPressed: () async {
//             if (isDownloading) return;
//             setState(() => isDownloading = true);
//             final repository = ref.read(videoRepositoryProvider);
//             final result = await repository.downloadVideo(
//               widget.video.videoUrl,
//             );
//             setState(() => isDownloading = false);
//             result.fold(
//               (failure) => ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(failure.toString()))),
//               (url) => ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(const SnackBar(content: Text('Video downloaded'))),
//             );
//           },
//         ),
//         const SizedBox(height: 20),
//         const Icon(Icons.share, color: Colors.white, size: 32),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zee_palm_tasks/models/video_model.dart';
import 'package:zee_palm_tasks/providers/video_provider.dart';
import 'package:zee_palm_tasks/utils/snakbar.dart';

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
    // Initialize isSaved based on Firestore data (assuming a 'savedBy' field)
    isSaved = widget.video.savedBy?.contains(widget.userId) ?? false;
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
                    : Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
            onPressed:
                isDownloading
                    ? null
                    : () async {
                      setState(() => isDownloading = true);
                      final repository = ref.read(videoRepositoryProvider);
                      final result = await repository.downloadVideo(
                        widget.video.videoUrl,
                      );
                      setState(() => isDownloading = false);
                      result.fold(
                        (failure) => showSnackBar(context, failure),
                        (_) => showSnackBar(context, 'Video downloaded'),
                      );
                    },
          ).animate().scale(
            duration: 200.ms,
            curve: Curves.easeOut,
            delay: 100.ms,
          ),
          const SizedBox(height: 12),
          IconButton(
            icon: const Icon(
              Icons.share_rounded,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              Share.share(
                'Check out this video on ZeePalm: ${widget.video.videoUrl}',
                subject: 'ZeePalm Video',
              );
            },
          ).animate().scale(
            duration: 200.ms,
            curve: Curves.easeOut,
            delay: 150.ms,
          ),
        ],
      ),
    );
  }
}
