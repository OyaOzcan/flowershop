import 'package:caseapp/view/all_products.dart';
import 'package:flutter/material.dart';
import 'package:caseapp/view/cart_page.dart';
import 'package:caseapp/view/favorites_page.dart';
import 'package:caseapp/view/home_page.dart';
import 'package:caseapp/view/profile_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    ProductsPage(),
    FavoritesPage(),
    CartPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffF4C2C2),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 20), 
            label: 'Home',
            backgroundColor: Color(0xffF4C2C2),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, size: 20), 
            label: 'Products',
            backgroundColor: Color(0xffF4C2C2),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 20), 
            label: 'Favorites',
            backgroundColor: Color(0xffF4C2C2),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 20), 
            label: 'Cart',
            backgroundColor: Color(0xffF4C2C2),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 20), 
            label: 'Profile',
            backgroundColor: Color(0xffF4C2C2),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(205, 110, 19, 13),
        onTap: _onItemTapped,
        iconSize: 20, 
      ),
    );
  }
}
