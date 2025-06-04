import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zee_palm_tasks/models/video_model.dart';
import 'package:zee_palm_tasks/providers/video_provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.white,
            size: 32,
          ),
          onPressed: () async {
            setState(() => isLiked = !isLiked);
            final repository = ref.read(videoRepositoryProvider);
            await repository.likeVideo(
              videoId: widget.video.id,
              userId: widget.userId,
              isLiked: !isLiked,
            );
          },
        ),
        const SizedBox(height: 20),
        IconButton(
          icon: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () {
            setState(() => isSaved = !isSaved);
            // Implement save functionality
          },
        ),
        const SizedBox(height: 20),
        IconButton(
          icon:
              isDownloading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.download, color: Colors.white, size: 32),
          onPressed: () async {
            if (isDownloading) return;
            setState(() => isDownloading = true);
            final repository = ref.read(videoRepositoryProvider);
            final result = await repository.downloadVideo(
              widget.video.videoUrl,
            );
            setState(() => isDownloading = false);
            result.fold(
              (failure) => ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.toString()))),
              (url) => ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Video downloaded'))),
            );
          },
        ),
        const SizedBox(height: 20),
        const Icon(Icons.share, color: Colors.white, size: 32),
      ],
    );
  }
}
