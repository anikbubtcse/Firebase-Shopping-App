import 'package:firebase_shopping_app/provider/cart_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
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
  final List<Widget> _pages = [
    Home(),
    Favorite(),
    Cart(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
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
            label: 'Cart',
            icon: badges.Badge(
              badgeContent: Text(provider.totalCartItem().toString()),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.amber,
                elevation: 4,
                padding: EdgeInsets.all(5),
                shape: badges.BadgeShape.circle,
              ),
              child: Icon((Icons.remove_shopping_cart)),
            ),
          ),
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
