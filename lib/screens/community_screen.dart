import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/firestore_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _postController = TextEditingController();
  final String userEmail =
      FirebaseAuth.instance.currentUser?.email ?? 'anonymous';

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: Column(
          children: [
            Expanded(child: _buildPostsList()),
            _buildPostInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList() {
    return StreamBuilder<List<Post>>(
      stream: _firestoreService.getPostsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No posts yet. Be the first!'));
        }

        final posts = snapshot.data!;

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final bool isLiked = post.likes.contains(userEmail);
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(post.userEmail[0].toUpperCase()),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    title: Text(post.content, style: const TextStyle(fontSize: 16)),
                    subtitle: Text(
                      'By: ${post.userEmail} at ${post.timestamp.toDate().toLocal().toString().substring(0, 16)}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                            color: isLiked
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          onPressed: () {
                            _firestoreService.toggleLike(
                              post.postId,
                              userEmail,
                              post.likes,
                            );
                          },
                        ),
                        Text('${post.likes.length}'),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(
                            Icons.comment_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Comments coming soon!'),
                              ),
                            );
                          },
                        ),
                        const Text('0'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPostInputField() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            color: Colors.black12,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: 'Share an experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _submitPost,
          ),
        ],
      ),
    );
  }

  Future<void> _submitPost() async {
    final content = _postController.text.trim();
    if (content.isEmpty) return;

    final newPost = Post(
      postId: '',
      content: content,
      userEmail: userEmail,
      timestamp: Timestamp.now(),
      likes: const [],
    );

    await _firestoreService.addPost(newPost);
    _postController.clear();
    FocusScope.of(context).unfocus();
  }
}
