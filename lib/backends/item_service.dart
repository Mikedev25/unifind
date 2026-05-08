import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class ItemService {
  final _db = FirebaseFirestore.instance;

  Future<String?> imageToBase64(String localPath) async {
  try {
    final file = File(localPath);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  } catch (e) {
    debugPrint('Image conversion error: $e');
    return null;
  }
}
  Future<void> addItem({
    required String name,
    required String model,
    required String category,
    required String status,
    String? imagePath,
  }) async {
    String? imageBase64;

    if(imagePath != null) {
      imageBase64 = await imageToBase64(imagePath);
    } 

    await _db.collection('items').add({
      'name' : name,
      'model' : model,
      'category' : category,
      'status' : status,
      'imageBase64' : imageBase64,
      'createdAt': FieldValue.serverTimestamp(),
      'ownerId' : FirebaseAuth.instance.currentUser!.uid,
      'ownerName' : FirebaseAuth.instance.currentUser!.displayName ?? 'Unknown',
    });
  }
  
  Stream<List<Map<String, dynamic>>> getItemsStream() {
    return _db
      .collection('items')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => {'id' : doc.id, ...doc.data()})
        .toList());
  }

  /// Search items by keyword (searches in name and model fields)
  /// Returns a stream of items matching the search query
  Stream<List<Map<String, dynamic>>> searchItems({
    required String keyword,
    String? category,
    String? status,
  }) {
    // Get all items and filter in memory for better search UX
    return _db
      .collection('items')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        final items = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
        
        // Filter by keyword (case-insensitive search in name and model)
        final searchKeyword = keyword.toLowerCase();
        var filtered = items.where((item) {
          final name = (item['name'] ?? '').toString().toLowerCase();
          final model = (item['model'] ?? '').toString().toLowerCase();
          return name.contains(searchKeyword) || model.contains(searchKeyword);
        }).toList();

        // Filter by category if specified
        if (category != null && category != 'All') {
          filtered = filtered.where((item) => item['category'] == category).toList();
        }

        // Filter by status if specified
        if (status != null && status != 'All') {
          filtered = filtered.where((item) => item['status'] == status).toList();
        }

        return filtered;
      });
  }

  Future<void> clearAllItems() async {
    final snapshot = await _db.collection('items').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}