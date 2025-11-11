import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String sellerEmail;
  final Timestamp timestamp;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.sellerEmail,
    required this.timestamp,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : (map['price'] as num?)?.toDouble() ?? 0.0,
      imagePath: map['imagePath'] as String? ?? '',
      sellerEmail: map['sellerEmail'] as String? ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? map['timestamp'] as Timestamp
          : Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'sellerEmail': sellerEmail,
      'timestamp': timestamp,
    };
  }
}
