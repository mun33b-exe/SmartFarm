import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String> uploadProductImage(File image) async {
    try {
      final extension = _inferExtension(image.path);
      final fileName =
          'products/${DateTime.now().millisecondsSinceEpoch}.$extension';
      final Reference ref = _storage.ref(fileName);

      final bytes = await image.readAsBytes();
      final metadata = SettableMetadata(contentType: _contentType(extension));

      await ref.putData(bytes, metadata);
      return ref.fullPath;
    } on FirebaseException catch (e, stackTrace) {
      debugPrint('Firebase Storage upload failed (${e.code}): ${e.message}');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Unexpected image upload error: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  String _inferExtension(String path) {
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == path.length - 1) {
      return 'jpg';
    }

    final ext = path.substring(dotIndex + 1).toLowerCase();
    if (ext.isEmpty) {
      return 'jpg';
    }
    return ext;
  }

  String _contentType(String extension) {
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'heic':
        return 'image/heic';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream';
    }
  }
}
