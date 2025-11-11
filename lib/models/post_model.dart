import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String content;
  final String userEmail;
  final Timestamp timestamp;

  const Post({
    required this.content,
    required this.userEmail,
    required this.timestamp,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      content: map['content'] as String? ?? '',
      userEmail: map['userEmail'] as String? ?? 'anonymous',
      timestamp: map['timestamp'] is Timestamp
          ? map['timestamp'] as Timestamp
          : Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'content': content, 'userEmail': userEmail, 'timestamp': timestamp};
  }
}
