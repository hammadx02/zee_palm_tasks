class VideoModel {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String caption;
  final String authorId;
  final DateTime timestamp;
  final int likes;
  final List<String> likedBy;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.caption,
    required this.authorId,
    required this.timestamp,
    this.likes = 0,
    this.likedBy = const [],
  });

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'],
      videoUrl: map['videoUrl'],
      thumbnailUrl: map['thumbnailUrl'],
      caption: map['caption'],
      authorId: map['authorId'],
      timestamp: map['timestamp'].toDate(),
      likes: map['likes'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'caption': caption,
      'authorId': authorId,
      'timestamp': timestamp,
      'likes': likes,
      'likedBy': likedBy,
    };
  }
}
