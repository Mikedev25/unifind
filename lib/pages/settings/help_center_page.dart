import 'package:flutter/material.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Help Center',
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
          const SizedBox(height: 12),
          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildExpandableFAQ(
            index: 0,
            question: 'How do I report a lost item?',
            answer:
                '1. Open the app and tap the "+" button\n2. Select "Report Lost Item"\n3. Fill in the item details:\n   - Item name and description\n   - Category (phone, keys, wallet, etc.)\n   - Color and any distinguishing marks\n   - Location where it was lost\n   - Date and time\n4. Add a clear photo of the item\n5. Set your contact preference (email/phone)\n6. Review and submit your report\n\nYour lost item will be visible to other users who can help find it.',
          ),
          _buildExpandableFAQ(
            index: 1,
            question: 'How do I report a found item?',
            answer:
                '1. Tap the "+" button and select "Report Found Item"\n2. Provide information about the found item:\n   - Item name and description\n   - Color and condition\n   - Any identifying information\n   - Where you found it (be specific)\n   - Time and date found\n3. Take a photo of the item\n4. Choose how others can contact you\n5. Submit the report\n\nUsers searching for lost items will be matched with your findings.',
          ),
          _buildExpandableFAQ(
            index: 2,
            question: 'How do I search for my lost item?',
            answer:
                '1. Go to the Search tab\n2. Use filters to narrow your search:\n   - Item category\n   - Location radius\n   - Date range\n   - Color\n3. Browse through matching found items\n4. Tap on an item to see full details and photos\n5. Contact the person who found it using the "Contact" button\n6. Provide proof of ownership if needed',
          ),
          _buildExpandableFAQ(
            index: 3,
            question: 'How can I contact someone about an item?',
            answer:
                '• Tap on the item listing\n• Click the "Contact" button\n• Choose your preferred contact method (in-app message, email, or phone)\n• Compose your message with relevant details\n• Be respectful and honest in your communication\n• Never share personal information unless you trust the person\n\nThe person will receive your message and can respond within the app.',
          ),
          _buildExpandableFAQ(
            index: 4,
            question: 'Is my personal information safe?',
            answer:
                'Yes! We take privacy seriously:\n• Your personal details are not shown publicly\n• Contact information is only shared when you choose\n• You can communicate through the app without revealing your number/email\n• All communications are encrypted\n• Report any suspicious activity to our support team\n• Read our Privacy Policy for full details',
          ),
          _buildExpandableFAQ(
            index: 5,
            question: 'Can I edit or delete my report?',
            answer:
                '1. Go to your "My Reports" section\n2. Find the report you want to modify\n3. Tap the three-dot menu icon\n4. Select "Edit" to update information\n5. Select "Delete" to remove the report\n\nNote: Deleting a report is permanent. Consider marking it as "Found/Recovered" first.',
          ),
          _buildExpandableFAQ(
            index: 6,
            question: 'How do I use location services?',
            answer:
                '• Go to Settings > Privacy Settings\n• Enable "Show My Location"\n• This helps others identify items lost near you\n• You can disable it anytime\n• Location is shown as an approximate area, not your exact address\n• Location helps with relevant search results',
          ),
          _buildExpandableFAQ(
            index: 7,
            question: 'What should I do if I found an item?',
            answer:
                'Best practices:\n1. Report it on UniFind immediately\n2. Keep the item safe and clean\n3. Check for identification inside\n4. Respond quickly to inquiries\n5. Meet in safe public locations\n6. Ask for proof of ownership before handing it over\n7. Mark the item as "Returned" when resolved',
          ),
          _buildExpandableFAQ(
            index: 8,
            question: 'What categories of items can I report?',
            answer:
                '• Electronics (phones, laptops, tablets, etc.)\n• Keys and Keychains\n• Wallets and Purses\n• Jewelry\n• Documents (IDs, passports, etc.)\n• Clothing and Accessories\n• Bags and Luggage\n• Pets\n• Other (for items not listed above)',
          ),
          _buildExpandableFAQ(
            index: 9,
            question: 'How do I report a problem with the app?',
            answer:
                '1. Go to Settings\n2. Select "Help Center"\n3. Scroll to "Contact Support"\n4. Tap "Report a Problem"\n5. Describe the issue in detail\n6. Include:\n   - What you were doing\n   - What went wrong\n   - Your device type and OS version\n   - Screenshots if helpful\n\nOur support team will respond within 24-48 hours.',
          ),
          const SizedBox(height: 24),
          _buildContactSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildExpandableFAQ({
    required int index,
    required String question,
    required String answer,
  }) {
    final isExpanded = _expandedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? const Color(0xFF2ECC71) : Colors.white12,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        collapsedBackgroundColor: const Color(0xFF2C2C2C),
        backgroundColor: const Color(0xFF2C2C2C),
        collapsedIconColor: Colors.white54,
        iconColor: const Color(0xFF2ECC71),
        onExpansionChanged: (expanded) {
          setState(() {
            _expandedIndex = expanded ? index : null;
          });
        },
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Support',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.email,
                      color: Color(0xFF2ECC71),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email Support',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'support@unifind.com',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.chat,
                      color: Color(0xFF2ECC71),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'In-App Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Available 24/7 for urgent issues',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: Color(0xFF2ECC71),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Call Us',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '1-800-UNIFIND-1',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2ECC71).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2ECC71).withOpacity(0.3)),
          ),
          child: Text(
            'Response times: Email (24-48 hours), Chat (2-4 hours), Phone (during business hours)',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
