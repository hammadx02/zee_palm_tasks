// // class VideoModel {
// //   final String id;
// //   final String videoUrl;
// //   final String thumbnailUrl;
// //   final String caption;
// //   final String authorId;
// //   final DateTime timestamp;
// //   final int likes;
// //   final List<String> likedBy;

// //   VideoModel({
// //     required this.id,
// //     required this.videoUrl,
// //     required this.thumbnailUrl,
// //     required this.caption,
// //     required this.authorId,
// //     required this.timestamp,
// //     this.likes = 0,
// //     this.likedBy = const [],
// //   });

// //   factory VideoModel.fromMap(Map<String, dynamic> map, String id) {
// //     return VideoModel(
// //       id: map['id'],
// //       videoUrl: map['videoUrl'],
// //       thumbnailUrl: map['thumbnailUrl'],
// //       caption: map['caption'],
// //       authorId: map['authorId'],
// //       timestamp: map['timestamp'].toDate(),
// //       likes: map['likes'] ?? 0,
// //       likedBy: List<String>.from(map['likedBy'] ?? []),
// //     );
// //   }

// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'videoUrl': videoUrl,
// //       'thumbnailUrl': thumbnailUrl,
// //       'caption': caption,
// //       'authorId': authorId,
// //       'timestamp': timestamp,
// //       'likes': likes,
// //       'likedBy': likedBy,
// //     };
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';

// class VideoModel {
//   final String id;
//   final String videoUrl;
//   final String thumbnailUrl;
//   final String caption;
//   final String authorId;
//   final DateTime timestamp;
//   final int likes;
//   final List<String> likedBy;

//   VideoModel({
//     required this.id,
//     required this.videoUrl,
//     required this.thumbnailUrl,
//     required this.caption,
//     required this.authorId,
//     required this.timestamp,
//     required this.likes,
//     required this.likedBy,
//   });

//   factory VideoModel.fromMap(Map<String, dynamic> map, String id) {
//     return VideoModel(
//       id: id,
//       videoUrl: map['videoUrl'] as String? ?? '',
//       thumbnailUrl: map['thumbnailUrl'] as String? ?? '',
//       caption: map['caption'] as String? ?? '',
//       authorId: map['authorId'] as String? ?? '',
//       timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       likes: map['likes'] as int? ?? 0,
//       likedBy: List<String>.from(map['likedBy'] ?? []),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'videoUrl': videoUrl,
//       'thumbnailUrl': thumbnailUrl,
//       'caption': caption,
//       'authorId': authorId,
//       'timestamp': Timestamp.fromDate(timestamp),
//       'likes': likes,
//       'likedBy': likedBy,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String caption;
  final String authorId;
  final DateTime timestamp;
  final int likes;
  final List<String> likedBy;
  final List<String> savedBy;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.caption,
    required this.authorId,
    required this.timestamp,
    required this.likes,
    required this.likedBy,
    required this.savedBy,
  });

  factory VideoModel.fromMap(Map<String, dynamic> map, String id) {
    return VideoModel(
      id: id,
      videoUrl: map['videoUrl'] as String? ?? '',
      thumbnailUrl: map['thumbnailUrl'] as String? ?? '',
      caption: map['caption'] as String? ?? '',
      authorId: map['authorId'] as String? ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: map['likes'] as int? ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      savedBy: List<String>.from(map['savedBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'caption': caption,
      'authorId': authorId,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'likedBy': likedBy,
      'savedBy': savedBy,
    };
  }
}
