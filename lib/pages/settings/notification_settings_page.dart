import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

enum NotificationPreference { mute, normal, push }

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  NotificationPreference _selectedPreference = NotificationPreference.normal;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Notification Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Notification Settings'),
          const SizedBox(height: 16),
          _buildNotificationOption(
            title: 'Mute All Notifications',
            description: 'You won\'t receive any notifications',
            value: NotificationPreference.mute,
            icon: Icons.notifications_off,
          ),
          const SizedBox(height: 12),
          _buildNotificationOption(
            title: 'Normal Notifications',
            description: 'Receive standard notifications',
            value: NotificationPreference.normal,
            icon: Icons.notifications,
          ),
          const SizedBox(height: 12),
          _buildNotificationOption(
            title: 'Push Notifications',
            description: 'Receive all notifications with alerts',
            value: NotificationPreference.push,
            icon: Icons.notifications_active,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildNotificationOption({
    required String title,
    required String description,
    required NotificationPreference value,
    required IconData icon,
  }) {
    final isSelected = _selectedPreference == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPreference = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2ECC71)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2ECC71).withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF2ECC71)
                    : Colors.white54,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2ECC71)
                      : Colors.white30,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Color(0xFF2ECC71),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
