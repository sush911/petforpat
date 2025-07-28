import 'package:flutter/material.dart';
import 'package:petforpat/features/auth/domain/entities/user_entity.dart'; // Import UserEntity

import 'package:petforpat/features/auth/presentation/views/profile_view.dart';
import 'package:petforpat/features/favorite/presentation/views/favorite_screen.dart';
import 'package:petforpat/features/notification/presentation/views/notification.dart';
import 'dashboard_home.dart';

class DashboardView extends StatefulWidget {
  final UserEntity user;  // <-- Add this

  const DashboardView({super.key, required this.user});  // <-- Update constructor

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    debugPrint('🟢 [DashboardView] Received user ID: ${widget.user.id}');

    _screens = [
      DashboardHome(user: widget.user),  // <-- Pass user down here
      const FavoriteScreen(),
      const NotificationScreen(),
      ProfileView(user: widget.user),    // Pass user if needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.teal[400],
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
