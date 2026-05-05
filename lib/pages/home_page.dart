import 'package:flutter/material.dart';
import '../backends/item_service.dart';
import '../backends/auth_service.dart';
import '../backends/message_service.dart';
import 'package:unifind/pages/chat_page.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class LostItem {
  final String id;
  final String name;
  final String model;
  final String category;
  final String status;
  final String? imageBase64;
  final String ownerId;
  final String ownerName;

  LostItem({
    required this.id,
    required this.name,
    required this.model,
    required this.category,
    this.status = 'Lost',
    this.imageBase64,
    required this.ownerId,
    required this.ownerName,

  });

  factory LostItem.fromMap(Map<String, dynamic> map) {
    return LostItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      model: map['model'] ?? '',
      category: map['category'] ?? '',
      status: map['status'] ?? 'Lost',
      imageBase64: map['imageBase64'],
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? 'Unknown',
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Electronics', 'Documents', 'Others'];
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        title: const Text(
          'UniFind',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: ItemService().getItemsStream(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2ECC71)),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 52, color: Colors.white24),
                        const SizedBox(height: 12),
                        Text(
                          'No items yet. \nTap + to report a lost item.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }
                final allItems = snapshot.data!
                  .map((m) => LostItem.fromMap(m))
                  .toList();

                final displayed = _selectedCategory == 'All'
                  ? allItems
                  : allItems.where((i) => i.category == _selectedCategory).toList();

                return _buildGrid(displayed);
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      color: const Color(0xFF1C1C1C),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _categories.map((cat) {
          final isSelected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                  ? const Color(0xFF2ECC71)
                  : const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 13, 
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.white60,
                    ),
                  ),
                ),
              ),
            );
        }).toList(), 
      ),
    );
  }

  Widget _buildGrid(List<LostItem> displayed) {
    if(displayed.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 52, color: Colors.white24),
            const SizedBox(height: 12),
            Text(
              'No items in this category.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 90),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: .82,
      ),
      itemCount: displayed.length,
      itemBuilder: (context, index) => _buildItemCard(displayed[index]),
    );
  }

  Widget _buildItemCard(LostItem item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color:  Colors.white12, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: item.imageBase64 != null
                  ? Image.memory(
                      base64Decode(item.imageBase64!),
                      height: 115,
                      width: double.infinity,
                      fit: BoxFit.cover,
                  )
                  : Container(
                    height: 115,
                    width: double.infinity,
                    color: const Color(0xFF3A3A3A),
                    child: const Icon(
                      Icons.image_outlined,
                      size: 36,
                      color: Colors.white24,
                    ),
                  ),
              ),
              Positioned(
                top: 7,
                left: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.status == 'Lost'
                      ? const Color(0xFFE74C3C)
                      : const Color(0xFF2ECC71),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10, 
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 7, 9, 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.model,
                  style: const TextStyle(fontSize: 11, color: Colors.white54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final currentUid = AuthService().currentUser?.uid ?? '';
                    if (item.ownerId == currentUid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                        content: Text('This is your own item.',
                        style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        ),
                      );
                      return;
                    }

                    final conversationID = await MessageService().getOrCreateConversation(
                      otherUserId: item.ownerId, 
                      otherUserName: item.ownerName, 
                      itemId: item.id, 
                      itemName: item.name,
                    );

                    if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatPage(
                            conversationID: conversationID, 
                            otherUserName: item.ownerName,
                          ),
                        ),
                      );
                  },
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF2ECC71),
                      fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class AddItemSheet extends StatefulWidget {
  const AddItemSheet({super.key});

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  String _selectedCategory = 'Electronics';
  String _selectedStatus = 'Lost';
  String? _imagePath;
  final _picker = ImagePicker();
  final _categories = ['Electronics', 'Documents', 'Others'];
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    if (picked != null) setState(() => _imagePath = picked.path);
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final model = _modelController.text.trim();

    if (name.isEmpty || model.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.',
          style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.fixed,
          elevation: 0,
        ),
      );
      return;
    }
    setState(() => _isLoading = true); 

    await ItemService().addItem(
      name: name,
      model: model,
      category: _selectedCategory,
      status: _selectedStatus,
      imagePath: _imagePath,
    );
    
    if(mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          children: [
            // ── Drag handle ──
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              _selectedStatus == 'Lost' ? 'Report as Lost' : 'Report as Found',
              style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),

            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: ['Lost', 'Found'].map((status) {
                  final isSelected = _selectedStatus == status;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedStatus = status),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: isSelected
                            ? (status == 'Lost'
                                ? const Color(0xFFE74C3C)
                                : const Color(0xFF2ECC71))
                            : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status == 'Lost' ? 'Report as Lost' : 'Report as Found',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.white38,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // ── Image picker ──
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: _imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_imagePath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              size: 32, color: Colors.white38),
                          const SizedBox(height: 8),
                          const Text(
                            'Tap to add photo',
                            style: TextStyle(
                                color: Colors.white38, fontSize: 13),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Item name ──
            _label('Item Name'),
            const SizedBox(height: 6),
            _textField(_nameController, 'e.g. Iphone 15'),
            const SizedBox(height: 14),

            // ── Model ──
            _label('Model / Variant'),
            const SizedBox(height: 6),
            _textField(_modelController, 'e.g. Promax'),
            const SizedBox(height: 14),

            // ── Category ──
            _label('Category'),
            const SizedBox(height: 8),

             Row(
              children: _categories.map((cat) {
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2ECC71)
                            : const Color(0xFF3A3A3A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.white54,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Submit ──
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                  )
                : const Text(
                    'Submit',
                    style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
      );

  Widget _textField(TextEditingController controller, String hint) =>
      TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
          filled: true,
          fillColor: const Color(0xFF3A3A3A),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white12, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white12, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF2ECC71), width: 1.5),
          ),
        ),
      );

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    super.dispose();
  }
}