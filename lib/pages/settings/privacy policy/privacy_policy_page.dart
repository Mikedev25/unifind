import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Privacy Policy',
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
          _buildSection(
            title: '1. Introduction',
            content:
                'UniFind ("we," "us," "our," or "Company") operates the UniFind application (the "App"). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our App.\n\nPlease read this Privacy Policy carefully. If you do not agree with our policies and practices, please do not use our App. By accessing or using UniFind, you acknowledge that you have read, understood, and agree to be bound by all the provisions of this Privacy Policy.',
          ),
          _buildSection(
            title: '2. Information We Collect',
            content:
                'We may collect information about you in a variety of ways. The information we may collect on the App includes:\n\n• Personal identification information (name, email address, phone number) when you create an account\n• Location data with your permission to help you find lost items near you\n• Photos and descriptions of items you report as lost or found\n• Communication data when you contact other users about lost or found items\n• Device information (device type, operating system, unique device identifiers)\n• Usage analytics and app interaction data\n• Payment information if you make any purchases through the App',
          ),
          _buildSection(
            title: '3. Use of Your Information',
            content:
                'Having accurate information about you permits us to provide you with a smooth, efficient, and customized experience. Specifically, we may use information collected about you via the App to:\n\n• Create and manage your user account\n• Process transactions and send transaction confirmations\n• Match lost items with found items based on descriptions and location\n• Send you notifications about items matching your search criteria\n• Respond to your inquiries and provide customer support\n• Email you regarding updates, security alerts, and support messages\n• Improve our App features and user experience\n• Monitor and analyze usage patterns and trends\n• Detect and prevent fraudulent activities\n• Comply with legal obligations',
          ),
          _buildSection(
            title: '4. Disclosure of Your Information',
            content:
                'We may share information we have collected about you in certain situations:\n\n• With other users: When you post a lost or found item, your name and location information may be visible to other users\n• Service providers: We may share your information with third-party service providers who assist us in operating our App\n• Legal requirements: We may disclose your information when required by law or when we believe in good faith that disclosure is necessary to protect our rights or your safety\n• Business transfers: If UniFind is involved in a merger or acquisition, your information may be transferred as part of that transaction',
          ),
          _buildSection(
            title: '5. Security of Your Information',
            content:
                'We use administrative, technical, and physical security measures to protect your personal information. However, no method of transmission over the Internet is 100% secure. We cannot guarantee absolute security of your information. You are responsible for keeping your password confidential.',
          ),
          _buildSection(
            title: '6. Contact Us',
            content:
                'If you have questions or comments about this Privacy Policy, please contact us at:\n\nEmail: privacy@unifind.com\nAddress: UniFind Support\n\nWe will respond to your inquiry within 30 days.',
          ),
          _buildSection(
            title: '7. Changes to This Privacy Policy',
            content:
                'We may update this Privacy Policy from time to time. We will notify you of any changes by updating the "Last Updated" date of this Privacy Policy and will provide you with notice through the App. Your continued use of the App following the posting of a revised Privacy Policy means that you accept and agree to the changes.',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Last Updated: May 4, 2026',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
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
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
