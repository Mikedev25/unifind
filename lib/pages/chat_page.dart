import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../backends/message_service.dart';
import '../backends/auth_service.dart';

class ChatPage extends StatefulWidget {
  final String conversationID;
  final String otherUserName;

  const ChatPage({
    super.key,
    required this.conversationID,
    required this.otherUserName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _messageService = MessageService();
  final _picker = ImagePicker();
  bool _isSending = false;
  String? _pendingImageBase64;

  @override
  void initState() {
    super.initState();
    _messageService.markAsRead(widget.conversationID);
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return;

    final bytes = await File(picked.path).readAsBytes();
    setState(() => _pendingImageBase64 = base64Encode(bytes));
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty && _pendingImageBase64 == null) return;

    setState(() => _isSending = true);
    _messageController.clear();
    final image = _pendingImageBase64;
    setState(() => _pendingImageBase64 = null);

    await _messageService.sendMessage(
      conversationId: widget.conversationID, 
      text: text,
      imageBase64: image,
    );

    setState(() => _isSending = false);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = AuthService().currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor:  const Color(0xFF1C1C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.light_mode, color: Colors.white, size: 20),
          onPressed: () {},
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF2ECC71),
                child: Text(
                  widget.otherUserName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight:  FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.otherUserName,
                style:  const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _messageService.getMessagesStream(widget.conversationID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF2ECC71)),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No messages yet. Start a conversation.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white38, fontSize: 14),
                      ),
                    );
                  }

                  final messages = snapshot.data!;
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg['senderId'] == currentUid;
                      return _buildMessageBubble(msg, isMe);
                    },
                  );
                },     
              ),
            ),

            // Pending image preview
            if (_pendingImageBase64 != null)
              Container(
                color: const Color(0xFF2C2C2C),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(_pendingImageBase64!),
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Image ready to send',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _pendingImageBase64 = null),
                      child: const Icon(Icons.close, color: Colors.white38, size: 20),
                      ),
                  ],
                ),
              ),

              // Input Bar
              Container(
                color: const Color(0xFF2C2C2C),
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 10,
                  bottom: MediaQuery.of(context).padding.bottom + 10,
                ),
                child: Row(
                  children: [
                    //Image Picker Button
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A3A3A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.image_outlined,
                          color: Colors.white54,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    //Text Input
                    Expanded(
                      child: TextField(
                        controller:  _messageController,
                        style:  const TextStyle(color: Colors.white, fontSize: 14),
                        maxLines: 4,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                          filled: true,
                          fillColor: const Color(0xFF3A3A3A),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    //Send button
                    GestureDetector(
                      onTap: _isSending ? null : _sendMessage,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2ECC71),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _isSending
                            ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              color: Colors.white, 
                              strokeWidth: 2
                              ),
                            )
                          : const Icon(Icons.send_rounded,
                              color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isMe) {
    final hasImage = msg['imageBase64'] != null && msg['imageBase64'] != '';
    final hasText = msg['text'] != null && msg['text'] != '';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF2ECC71) : const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(hasText ? 0 : (isMe ? 16 : 4)),
                  bottomRight: Radius.circular(hasText ? 0 : (isMe ? 4 : 16)),
                ),
                child: Image.memory(
                  base64Decode(msg['imageBase64']),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            if (hasText)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  msg['text'],
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}