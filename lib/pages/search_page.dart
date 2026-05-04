import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedType = 'All Items'; 
  bool _showFilters = false;

  final List<String> categories = ['All', 'Electronics', 'Documents', 'Others'];

  final List<String> itemTypes = ['All Items', 'Lost Items', 'Found Items'];

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
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {});
              },
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
                    child: Wrap(
                      spacing: 8,
                      children: itemTypes.map((type) {
                        final isSelected = _selectedType == type;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedType = type;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF2ECC71)
                                  : const Color(0xFF2C2C2C),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF2ECC71)
                                    : Colors.white12,
                              ),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Filter
                  _buildFilterSection(
                    title: 'Category',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF2ECC71)
                                  : const Color(0xFF2C2C2C),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF2ECC71)
                                    : Colors.white12,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Search results will appear here',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Search Results Placeholder
          Expanded(
            child: Center(
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
            ),
          ),
        ],
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
