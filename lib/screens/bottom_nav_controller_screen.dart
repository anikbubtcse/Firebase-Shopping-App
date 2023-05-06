import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/appcolors.dart';
import '../screens/bottom_nav_pages/cart.dart';
import '../screens/bottom_nav_pages/favorite.dart';
import '../screens/bottom_nav_pages/home.dart';
import '../screens/bottom_nav_pages/profile.dart';
import 'package:flutter/material.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({Key? key}) : super(key: key);

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [Home(), Favorite(), Cart(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E Commerce'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30.w), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 30.w), label: 'Favorite'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart, size: 30.w), label: 'Cart'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30.w),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        elevation: 5,
        selectedItemColor: AppColors.deep_orange,
        unselectedItemColor: Colors.grey,
        onTap: (newValue) {
          setState(() {
            _selectedIndex = newValue;
          });
        },
      ),
    );
  }
}
