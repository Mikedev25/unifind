import 'package:flutter/material.dart';
import 'dart:convert';
import '../backends/item_service.dart';
import '../backends/auth_service.dart';
import '../backends/message_service.dart';
import 'package:unifind/pages/chat_page.dart';

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

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedType = 'All'; 
  bool _showFilters = false;
  bool _hasSearched = false;

  final List<String> categories = ['All', 'Electronics', 'Documents', 'Others'];

  final List<String> itemTypes = ['All', 'Lost', 'Found'];

  int get _activeFilterCount {
    int count = 0;
    if (_selectedType != 'All') count++;
    if (_selectedCategory != 'All') count++;
    return count;
  }

  @override
  void dispose() {
    _searchController.dispose();
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
          'Search Items',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar with Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search for items...',
                      hintStyle: TextStyle(color: Colors.white30),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF2ECC71)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white54),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFF2C2C2C),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Search Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hasSearched = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.search, color: Colors.black, size: 24),
                  ),
                ),
              ],
            ),
          ),

          // Filter Toggle Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _showFilters ? const Color(0xFF2ECC71) : Colors.white12,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tune, color: Color(0xFF2ECC71), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_activeFilterCount > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                            '($_activeFilterCount)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    const Spacer(),
                    Icon(
                      _showFilters ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filters Section
          if (_showFilters)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Item Type Filter
                  _buildFilterSection(
                    title: 'Item Type',
                    child: _SegmentedControl(
                        options: itemTypes,
                        selected: _selectedType,
                        onChanged: (val) => setState(() => _selectedType = val),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Category Filter
                  _buildFilterSection(
                    title: 'Category',
                    child: _SegmentedControl(
                      options: categories,
                      selected: _selectedCategory,
                      onChanged: (val) => setState(() => _selectedCategory = val),
                      )
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),

          // Search Results
          Expanded(
            child: !_hasSearched || _searchController.text.isEmpty
                ? _buildEmptyState()
                : StreamBuilder<List<Map<String, dynamic>>>(
                    stream: ItemService().searchItems(
                      keyword: _searchController.text,
                      category: _selectedCategory == 'All' ? null : _selectedCategory,
                      status: _selectedType == 'All' ? null : _selectedType,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xFF2ECC71)),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildNoResults();
                      }

                      final items = snapshot.data!
                          .map((m) => LostItem.fromMap(m))
                          .toList();

                      return _buildResults(items);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.white30,
          ),
          const SizedBox(height: 16),
          Text(
            'Start searching for items',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use the search bar and filters above',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white30,
          ),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or filters',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(List<LostItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${items.length} result${items.length != 1 ? 's' : ''} found',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 90),
            itemCount: items.length,
            itemBuilder: (context, index) => _buildItemCard(items[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(LostItem item) {
    return GestureDetector(
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12, width: 0.5),
        ),
        child: Row(
          children: [
            // Item Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: item.imageBase64 != null
                  ? Image.memory(
                      base64Decode(item.imageBase64!),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                    height: 100,
                    width: 100,
                    color: const Color(0xFF3A3A3A),
                    child: const Icon(
                      Icons.image_outlined,
                      size: 32,
                      color: Colors.white24,
                    ),
                  ),
            ),
            // Item Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.status == 'Lost'
                                ? const Color(0xFFE74C3C)
                                : const Color(0xFF2ECC71),
                            borderRadius: BorderRadius.circular(8),
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
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.model,
                      style: const TextStyle(fontSize: 12, color: Colors.white54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.label, size: 12, color: Colors.white54),
                        const SizedBox(width: 4),
                        Text(
                          item.category,
                          style: const TextStyle(fontSize: 11, color: Colors.white54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  const _SegmentedControl({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: options.map((options) {
          final isSelected = selected == options;
          return Expanded(
            child: GestureDetector(
              onTap:() => onChanged(options),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2ECC71) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  options,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList()
      ),
    );
  }
}
