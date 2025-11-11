import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference _productsRef = _db.collection('products');

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
}
