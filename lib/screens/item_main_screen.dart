
import 'package:flutter/material.dart';

import 'sub_screen/add_post_screen.dart';
import 'sub_screen/category_screen.dart';
import 'sub_screen/home_screen.dart';
import 'sub_screen/profile_screen.dart';
import 'sub_screen/setting_screen.dart';

class ItemMainScreen extends StatefulWidget {
  const ItemMainScreen({super.key});

  @override
  State<ItemMainScreen> createState() => _ItemMainScreenState();
}

class _ItemMainScreenState extends State<ItemMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        HomeScreen(),
        CategoryScreen(),
        AddPostScreen(),
        ProfileScreen(),
        SettingScreen(),
      ],
    );
  }

  int _currentIndex = 0;

  Widget _buildNavigationBar() {
    final theme = Theme.of(context); // Store the theme in a variable

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (selectedIndex) {
        setState(() {
          _currentIndex = selectedIndex;
        });
      },
      elevation: 2,
      backgroundColor: theme.colorScheme.tertiary,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 26,
      items: [
        const BottomNavigationBarItem(
          icon: Center(child: Icon(Icons.home)),
          label: "",
        ),
        const BottomNavigationBarItem(
          icon: Center(child: Icon(Icons.people)),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary, // Use the stored theme value
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          label: "",
        ),
        const BottomNavigationBarItem(
          icon: Center(child: Icon(Icons.person_rounded)),
          label: "",
        ),
        const BottomNavigationBarItem(
          icon: Center(child: Icon(Icons.settings)),
          label: "",
        ),
      ],
    );
  }
}
