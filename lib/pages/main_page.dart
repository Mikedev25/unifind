import 'package:flutter/material.dart';
import 'package:unifind/widgets/navigation_bar.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'settings/settings_page.dart';
import 'inbox_page.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  void _openAddItemSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddItemSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pages are mapped to navigation bar indices
    final List<Widget> pages = [
      const HomePage(),
      const InboxPage(),
      const SizedBox(),
      const SearchPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            _openAddItemSheet(context);
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}