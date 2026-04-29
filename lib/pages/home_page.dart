import 'package:flutter/material.dart';
import '../backends/auth_service.dart';
import 'package:unifind/widgets/navigation_bar.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class LostItem {
  final String id;
  final String name;
  final String model;
  final String category;
  final String status;
  final String? imagePath;

  LostItem({
    required this.id,
    required this.name,
    required this.model,
    required this.category,
    this.status = 'Lost',
    this.imagePath,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Electronics', 'Documents', 'Others'];
  final List<LostItem> _items = [];

  List<LostItem> get _filteredItems {
    if (_selectedCategory == 'All') return _items;
    return _items.where((i) => i.category == _selectedCategory).toList();
  }
  void _openAddItemSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddItemSheet(
        onAdd: (item) => setState(() => _items.add(item)),
      ),
    );
  }
 
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AuthService().signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFilter(),
          Expanded(child: _buildGrid()),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) {
            _openAddItemSheet();
          }// Handle navigation tap
        },
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

  Widget _buildGrid() {
    final displayed = _filteredItems;

    if(displayed.isEmpty) {
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
                child: item.imagePath != null
                  ? Image.file(
                      File(item.imagePath!),
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
                  onTap: () {

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
  final void Function(LostItem) onAdd;
  const AddItemSheet({super.key, required this.onAdd});

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  String _selectedCategory = 'Electronics';
  String? _imagePath;
  final _picker = ImagePicker();
  final _categories = ['Electronics', 'Documents', 'Others'];

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) setState(() => _imagePath = picked.path);
  }

  void _submit() {
    final name = _nameController.text.trim();
    final model = _modelController.text.trim();

    if (name.isEmpty || model.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
          backgroundColor: Color(0xFFE74C3C),
        ),
      );
      return;
    }

    widget.onAdd(LostItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      model: model,
      category: _selectedCategory,
      imagePath: _imagePath,
    ));

    Navigator.pop(context);
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

            const Text(
              'Report Lost Item',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),

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
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Report as Lost',
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