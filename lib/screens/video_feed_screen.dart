import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zee_palm_tasks/providers/auth_provider.dart';
import 'package:zee_palm_tasks/providers/video_provider.dart';
import 'package:zee_palm_tasks/screens/upload_screen.dart';
import 'package:zee_palm_tasks/utils/snakbar.dart';
import 'package:zee_palm_tasks/widgets/video_action_bars.dart';
import 'package:zee_palm_tasks/widgets/video_player.dart';

class VideoFeedScreen extends ConsumerWidget {
  const VideoFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(videosProvider);
    final user = ref.watch(authStateProvider).value;

    void _navigateToUpload() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UploadScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: videosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data:
            (videos) => PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return Stack(
                  children: [
                    VideoPlayerWidget(videoUrl: video.videoUrl),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.caption,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${video.likes} likes',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (user != null)
                      Positioned(
                        right: 10,
                        bottom: 100,
                        child: VideoActionsBar(video: video, userId: user.uid),
                      ),
                    // Add to the Stack children in VideoFeedScreen:
                    if (user != null && video.authorId == user.uid)
                      Positioned(
                        top: 40,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Delete Video'),
                                    content: const Text(
                                      'Are you sure you want to delete this video?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirmed == true) {
                              final repository = ref.read(
                                videoRepositoryProvider,
                              );
                              final result = await repository.deleteVideo(
                                video.id,
                                user.uid,
                              );

                              result.fold(
                                (failure) =>
                                    showSnackBar(context, failure.toString()),
                                (_) => showSnackBar(context, 'Video deleted'),
                              );
                            }
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToUpload;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
