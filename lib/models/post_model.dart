import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String content;
  final String userEmail;
  final Timestamp timestamp;
  final List<String> likes;

  const Post({
    required this.postId,
    required this.content,
    required this.userEmail,
    required this.timestamp,
    required this.likes,
  });

  factory Post.fromMap(Map<String, dynamic> map, String postId) {
    return Post(
      postId: postId,
      content: map['content'] as String? ?? '',
      userEmail: map['userEmail'] as String? ?? 'anonymous',
      timestamp: map['timestamp'] is Timestamp
          ? map['timestamp'] as Timestamp
          : Timestamp.now(),
      likes: List<String>.from(map['likes'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'userEmail': userEmail,
      'timestamp': timestamp,
      'likes': likes,
    };
  }
}
