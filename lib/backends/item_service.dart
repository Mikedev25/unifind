import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemService {
  final _db = FirebaseFirestore.instance;

  Future<String?> imageToBase64(String localPath) async {
  try {
    final file = File(localPath);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  } catch (e) {
    print('Image conversion error: $e');
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
}


