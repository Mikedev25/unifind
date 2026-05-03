import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // Fetch all conversations for current user
  Stream<List<Map<String, dynamic>>> getConversationsStream() {
    return _db
        .collection('conversations')
        .where('participants', arrayContains: _uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  Stream<List<Map<String, dynamic>>> getMessagesStream(String converstationID) {
    return _db
      .collection('conversations')
      .doc(converstationID)
      .collection('messages')
      .orderBy('createdAt', descending: false)
      .snapshots()
      .map((snap) => snap.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
      }).toList());
  }

  // Creates or retrieves an existing conversation between two users
  Future<String> getOrCreateConversation({
    required String otherUserId,
    required String otherUserName,
    required String itemId,
    required String itemName,
  }) async {
    // Check if conversation already exists for this item
    final existing = await _db
        .collection('conversations')
        .where('participants', arrayContains: _uid)
        .where('itemId', isEqualTo: itemId)
        .get();

    for (final doc in existing.docs) {
      final participants = List<String>.from(doc['participants']);
      if (participants.contains(otherUserId)) {
        return doc.id; // Return existing conversation
      }
    }

    // Create new conversation
    final ref = _db.collection('conversations').doc();
    await ref.set({
      'participants': [_uid, otherUserId],
      'userName': otherUserName,
      'avatarUrl': null,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': 0,
      'itemId': itemId,
      'itemName': itemName,
    });
    return ref.id;
  }
  // Send a message
  Future<void> sendMessage({
    required String conversationId,
    required String text,
    String? imageBase64,
  }) async {
    final ref = _db.collection('conversations').doc(conversationId);
    final msgRef = ref.collection('messages').doc();

    await msgRef.set({
      'senderId': _uid,
      'text': text,
      'imageBase64': imageBase64,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await ref.update({
      'lastMessage': imageBase64 != null ? 'Image' : text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': FieldValue.increment(1),
    });
  }

  Future<void> markAsRead(String conversationID) async {
    await _db.collection('conversation').doc(conversationID).update({
      'unreadCount': 0,
    });
  }
}