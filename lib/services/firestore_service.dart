import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post_model.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference _productsRef = _db.collection('products');
  late final CollectionReference _postsRef = _db.collection('posts');

  Future<void> addProduct(Product product) async {
    await _productsRef.add(product.toMap());
  }

  Stream<List<Product>> getProductsStream() {
    return _productsRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  Future<void> addPost(Post post) async {
    await _postsRef.add(post.toMap());
  }

  Stream<List<Post>> getPostsStream() {
    return _postsRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }
}
