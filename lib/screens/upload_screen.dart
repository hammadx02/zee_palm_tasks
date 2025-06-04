import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zee_palm_tasks/providers/auth_provider.dart';
import 'package:zee_palm_tasks/utils/snakbar.dart';
import 'package:zee_palm_tasks/widgets/video_player.dart';
import 'package:path_provider/path_provider.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  File? _videoFile;
  final TextEditingController _captionController = TextEditingController();
  bool _isUploading = false;
  double _uploadProgress = 0;

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60),
    );

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _generateThumbnail(String videoPath) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 200,
      quality: 75,
    );
    return thumbnailPath!;
  }

  Future<String> _uploadFile(File file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);

    uploadTask.snapshotEvents.listen((taskSnapshot) {
      setState(() {
        _uploadProgress =
            taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
      });
    });

    final taskSnapshot = await uploadTask.whenComplete(() {});
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null || _captionController.text.isEmpty) {
      showSnackBar(context, 'Please select a video and add a caption');
      return;
    }

    setState(() => _isUploading = true);
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception('User not logged in');

      // Generate thumbnail
      final thumbnailPath = await _generateThumbnail(_videoFile!.path);
      final thumbnailFile = File(thumbnailPath);

      // Upload files
      final videoUrl = await _uploadFile(
        _videoFile!,
        'videos/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.mp4',
      );
      final thumbnailUrl = await _uploadFile(
        thumbnailFile,
        'thumbnails/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // Save video data to Firestore
      await FirebaseFirestore.instance.collection('videos').add({
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'caption': _captionController.text,
        'authorId': user.uid,
        'timestamp': Timestamp.now(),
        'likes': 0,
        'likedBy': [],
      });

      if (mounted) {
        Navigator.pop(context);
        showSnackBar(context, 'Video uploaded successfully!');
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Failed to upload video: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isUploading ? null : () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _isUploading ? null : _pickVideo,
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    _videoFile == null
                        ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_library, size: 50),
                            SizedBox(height: 10),
                            Text('Select Video'),
                          ],
                        )
                        : Stack(
                          alignment: Alignment.center,
                          children: [
                            VideoPlayerWidget(
                              videoUrl: _videoFile!.path,
                              autoPlay: false,
                            ),
                            if (_isUploading)
                              CircularProgressIndicator(
                                value: _uploadProgress,
                                strokeWidth: 5,
                              ),
                          ],
                        ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                labelText: 'Caption',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadVideo,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child:
                    _isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Upload Video'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
