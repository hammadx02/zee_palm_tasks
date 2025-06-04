import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zee_palm_tasks/providers/auth_provider.dart';

class VideoFeedScreen extends ConsumerWidget {
  const VideoFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: const Center(child: Text('Video Feed Will Appear Here')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to upload screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
