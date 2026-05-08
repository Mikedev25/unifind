import 'package:flutter/material.dart';
import '../backends/message_service.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}


class _InboxPageState extends State<InboxPage> {
  final MessageService _messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        title: const Text(
          'Inbox',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.light_mode, color: Colors.white),
            onPressed: () {}
              
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _getConversationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2ECC71)),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.message_outlined, size: 52, color: Colors.white24),
                  const SizedBox(height: 12),
                  const Text(
                    'No message yet. \nStart a conversation from an item.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ],
              ),
            );
          }
          final conversations = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: conversations.length,
            separatorBuilder: (_, __) => const Divider(
              color: Colors.white10,
              height: 1,
              indent: 76,
            ),
            itemBuilder: (context, index) => _buildConversationTile(conversations[index]),
          );
        },
      ),
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> convo) {
    final bool hasUnread = (convo['unreadCount'] ?? 0) > 0;

    return InkWell(
      onTap: () {
        //Todo: navigate to chatpage (person-to-person convo)
        //Navigator.push(context, MaterialPageRoute(
        //  builder: (_) => ChatPage(conversationId: convo['id']),
        //));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius:  26,
                  backgroundColor: const Color(0xFF3A3A3A),
                  backgroundImage: convo['avatarUrl'] != null
                    ? NetworkImage(convo['avatarUrl'])
                    : null,
                  child:  convo['avatarUrl'] == null
                    ? Text(
                      (convo['userName'] ?? '?') [0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    )
                  : null,
                ),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2ECC71),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    convo['userName'] ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    convo['lastMessage'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: hasUnread ? Colors.white70 : Colors.white38,
                      fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Timestamp + unread badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTimestamp(convo['lastMessageTime']),
                  style: TextStyle(
                    fontSize: 11,
                    color: hasUnread
                      ? const Color(0xFF2ECC71)
                      : Colors.white30,
                  ),
                ),
                if (hasUnread && (convo['unreadCount'] ?? 0) >0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${convo['unredCount']}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    DateTime dt;
    // handles firestore timestamp or datetime
    if (timestamp is DateTime) {
      dt = timestamp;
    } else {
      try {
        dt = timestamp.toDate();
      } catch (_) {
        return '';
      }
    }
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Stream<List<Map<String, dynamic>>> _getConversationsStream() {
    return _messageService.getConversationsStream();
  }
}