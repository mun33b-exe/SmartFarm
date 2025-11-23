import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/firestore_service.dart';
import 'add_product_screen.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final Map<String, Future<String?>> _imageUrlFutures = {};

  Future<String?> _getImageDownloadUrl(String path) {
    if (path.isEmpty) {
      return Future.value(null);
    }

    return _imageUrlFutures.putIfAbsent(path, () async {
      try {
        return await FirebaseStorage.instance.ref(path).getDownloadURL();
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Market Rates (Today)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          _buildMarketRatesList(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              'Buy & Sell',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(child: _buildProductsStream()),
        ],
      ),
    );
  }

  Widget _buildMarketRatesList() {
    final dummyRates = {
      'Wheat': '2,400 / 40kg',
      'Cotton': '8,500 / 40kg',
      'Rice': '3,000 / 40kg',
    };

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dummyRates.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dummyRates.keys.elementAt(index),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dummyRates.values.elementAt(index),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsStream() {
    return StreamBuilder<List<Product>>(
      stream: _firestoreService.getProductsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products listed yet.'));
        }

        final products = snapshot.data!;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: FutureBuilder<String?>(
                  future: _getImageDownloadUrl(product.imagePath),
                  builder: (context, imageSnapshot) {
                    Widget child;
                    if (imageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      child = const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    } else if (imageSnapshot.hasData &&
                        imageSnapshot.data != null) {
                      child = ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageSnapshot.data!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      child = const Icon(
                        Icons.image_not_supported,
                        size: 32,
                        color: Colors.grey,
                      );
                    }

                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: child,
                    );
                  },
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  product.sellerEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  'Rs. ${product.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
