import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zee_palm_tasks/features/auth/presentation/auth_provider.dart';
import 'package:zee_palm_tasks/features/video/presentation/video_provider.dart';
import 'package:zee_palm_tasks/features/video/presentation/screens/upload_screen.dart';
import 'package:zee_palm_tasks/core/utils/snakbar.dart';
import 'package:zee_palm_tasks/features/video/presentation/widgets/video_action_bars.dart';
import 'package:zee_palm_tasks/features/video/presentation/widgets/video_player.dart';

class VideoFeedScreen extends ConsumerWidget {
  const VideoFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(videosProvider);
    final user = ref.watch(authStateProvider).value;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    void _navigateToUpload() {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const UploadScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOutCubic)),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: _buildModernAppBar(context, ref, colorScheme),
      body: videosAsync.when(
        loading: () => _buildLoadingState(colorScheme),
        error:
            (error, stack) =>
                _buildErrorState(context, ref, error, colorScheme),
        data:
            (videos) =>
                videos.isEmpty
                    ? _buildEmptyState(context, colorScheme)
                    : _buildVideoFeed(context, videos, user, colorScheme),
      ),
      floatingActionButton: _buildModernFAB(
        context,
        _navigateToUpload,
        colorScheme,
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface.withOpacity(0.95),
              colorScheme.surface.withOpacity(0.8),
              Colors.transparent,
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: colorScheme.onPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Video Hub',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ).animate().slideY(
        begin: -1,
        duration: 400.ms,
        curve: Curves.easeOutBack,
      ),
      // actions: [
      //   Container(
      //     margin: const EdgeInsets.only(right: 16),
      //     decoration: BoxDecoration(
      //       color: colorScheme.errorContainer.withOpacity(0.1),
      //       borderRadius: BorderRadius.circular(12),
      //       border: Border.all(
      //         color: colorScheme.error.withOpacity(0.2),
      //         width: 1,
      //       ),
      //     ),
      //     child: IconButton(
      //       icon: Icon(
      //         Icons.logout_rounded,
      //         color: colorScheme.error,
      //         size: 22,
      //       ),
      //       onPressed: () => ref.read(authRepositoryProvider).signOut(),
      //       tooltip: 'Sign Out',
      //     ),
      //   ),
      // ],
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Loading videos...',
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(
            begin: const Offset(0.8, 0.8),
            duration: 300.ms,
            curve: Curves.easeOut,
          ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    Object error,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.error.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: colorScheme.error,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  error.toString().replaceFirst('Exception: ', ''),
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 32),
                // _buildModernButton(
                //   context: context,
                //   onPressed: () => ref.read(videosProvider).refresh(),
                //   text: 'Try Again',
                //   isPrimary: true,
                //   colorScheme: colorScheme,
                // ),
              ],
            ),
          )
          .animate()
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.3, duration: 400.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primaryContainer.withOpacity(0.1),
                  colorScheme.secondaryContainer.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withOpacity(0.1),
                        colorScheme.secondary.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.video_library_rounded,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'No videos yet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Be the first to share your story!\nTap the + button to get started.',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
          .animate()
          .fadeIn(duration: 500.ms)
          .scale(
            begin: const Offset(0.9, 0.9),
            duration: 400.ms,
            curve: Curves.easeOut,
          )
          .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOut),
    );
  }

  Widget _buildVideoFeed(
    BuildContext context,
    List videos,
    user,
    ColorScheme colorScheme,
  ) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Stack(
          children: [
            // Video Player with subtle overlay
            Stack(
              children: [
                VideoPlayerWidget(videoUrl: video.videoUrl),
                // Subtle gradient overlay for better text readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.0, 0.4, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Modern video info overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 80,
              child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            // backdropFilter: null, // Would use BackdropFilter in real app
                          ),
                          child: Text(
                            '${video.likes} likes',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          video.caption,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(duration: 400.ms),
            ),

            // Modern action buttons
            if (user != null)
              Positioned(
                right: 12,
                bottom: 120,
                child: VideoActionsBar(video: video, userId: user.uid)
                    .animate()
                    .slideX(
                      begin: 0.3,
                      end: 0,
                      duration: 300.ms,
                      curve: Curves.easeOut,
                    )
                    .fadeIn(duration: 300.ms, delay: 200.ms),
              ),

            // Modern delete button for video owner
            // if (user != null && video.authorId == user.uid)
            //   Positioned(
            //     top: 60,
            //     right: 16,
            //     child: Container(
            //           decoration: BoxDecoration(
            //             color: colorScheme.errorContainer.withOpacity(0.9),
            //             borderRadius: BorderRadius.circular(12),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black.withOpacity(0.2),
            //                 blurRadius: 8,
            //                 offset: const Offset(0, 2),
            //               ),
            //             ],
            //           ),
            //           child: IconButton(
            //             icon: Icon(
            //               Icons.delete_outline_rounded,
            //               color: colorScheme.error,
            //               size: 24,
            //             ),
            //             onPressed:
            //                 () => _showDeleteDialog(
            //                   context,
            //                   key as WidgetRef,
            //                   video,
            //                   user,
            //                 ),
            //           ),
            //         )
            //         .animate()
            //         .scale(
            //           begin: const Offset(0.8, 0.8),
            //           duration: 200.ms,
            //           curve: Curves.easeOut,
            //         )
            //         .fadeIn(duration: 300.ms, delay: 300.ms),
            //   ),
          ],
        );
      },
    );
  }

  Widget _buildModernFAB(
    BuildContext context,
    VoidCallback onPressed,
    ColorScheme colorScheme,
  ) {
    return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: onPressed,
            backgroundColor: Colors.transparent,
            foregroundColor: colorScheme.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            icon: const Icon(Icons.add_rounded, size: 24),
            label: const Text(
              'Create',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        )
        .animate()
        .scale(
          begin: const Offset(0.8, 0.8),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 300.ms, delay: 500.ms);
  }

  Widget _buildModernButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
    required bool isPrimary,
    required ColorScheme colorScheme,
  }) {
    return Container(
      decoration:
          isPrimary
              ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              )
              : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.transparent : colorScheme.surface,
          foregroundColor:
              isPrimary ? colorScheme.onPrimary : colorScheme.onSurface,
          elevation: isPrimary ? 0 : 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side:
                isPrimary
                    ? BorderSide.none
                    : BorderSide(color: colorScheme.outline.withOpacity(0.2)),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // Future<void> _showDeleteDialog(
  //   BuildContext context,
  //   WidgetRef ref,
  //   dynamic video,
  //   dynamic user,
  // ) async {
  //   final colorScheme = Theme.of(context).colorScheme;

  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //               backgroundColor: colorScheme.surface,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               title: Row(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(8),
  //                     decoration: BoxDecoration(
  //                       color: colorScheme.errorContainer.withOpacity(0.2),
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     child: Icon(
  //                       Icons.delete_outline_rounded,
  //                       color: colorScheme.error,
  //                       size: 20,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Text(
  //                     'Delete Video',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w700,
  //                       color: colorScheme.onSurface,
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               content: Text(
  //                 'This action cannot be undone. Are you sure you want to delete this video?',
  //                 style: TextStyle(
  //                   color: colorScheme.onSurface.withOpacity(0.8),
  //                   fontSize: 14,
  //                   height: 1.5,
  //                 ),
  //               ),
  //               actions: [
  //                 _buildModernButton(
  //                   context: context,
  //                   onPressed: () => Navigator.pop(context, false),
  //                   text: 'Cancel',
  //                   isPrimary: false,
  //                   colorScheme: colorScheme,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     color: colorScheme.error,
  //                     borderRadius: BorderRadius.circular(16),
  //                   ),
  //                   child: ElevatedButton(
  //                     onPressed: () => Navigator.pop(context, true),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.transparent,
  //                       foregroundColor: colorScheme.onError,
  //                       elevation: 0,
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 24,
  //                         vertical: 12,
  //                       ),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(16),
  //                       ),
  //                     ),
  //                     child: const Text(
  //                       'Delete',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w700,
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             )
  //             .animate()
  //             .scale(
  //               begin: const Offset(0.8, 0.8),
  //               duration: 200.ms,
  //               curve: Curves.easeOut,
  //             )
  //             .fadeIn(duration: 200.ms),
  //   );

  //   if (confirmed == true) {
  //     final repository = ref.read(videoRepositoryProvider);
  //     final result = await repository.deleteVideo(video.id, user.uid);
  //     result.fold(
  //       (failure) => showSnackBar(context, failure),
  //       (_) => showSnackBar(context, 'Video deleted successfully'),
  //     );
  //     ref.read(videosProvider.notifier).refresh();
  //   }
  // }
}
