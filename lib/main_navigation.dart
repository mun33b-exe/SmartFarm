import 'package:flutter/material.dart';

import 'screens/community_screen.dart';
import 'screens/home_screen.dart';
import 'screens/market_screen.dart';
import 'screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({
    super.key,
    required this.changeTheme,
    required this.currentTheme,
    List<Widget>? screens,
  }) : _screensOverride = screens;

  final List<Widget>? _screensOverride;
  final Function(ThemeMode) changeTheme;
  final ThemeMode currentTheme;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = widget._screensOverride ?? _buildScreens();
  }

  @override
  void didUpdateWidget(covariant MainNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._screensOverride == null &&
        widget.currentTheme != oldWidget.currentTheme) {
      setState(() {
        _screens = _buildScreens();
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Market',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const MarketScreen(),
      const CommunityScreen(),
      ProfileScreen(
        changeTheme: widget.changeTheme,
        currentTheme: widget.currentTheme,
      ),
    ];
  }
}
