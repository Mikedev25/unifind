import 'package:flutter/material.dart';

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

  final List<String> categories = ['All', 'Electronics', 'Documents', 'Others'];

  final List<String> itemTypes = ['All', 'Lost', 'Found'];

  int get _activeFilterCount {
    int count = 0;
    if (_selectedType != 'All') count++;
    if (_selectedCategory != 'All') count++;
    return count;
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
