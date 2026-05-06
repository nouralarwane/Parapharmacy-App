import 'package:flutter/material.dart';
import 'package:smartshop/pages/cart_page.dart';
import 'package:smartshop/pages/home_page.dart';
import 'package:smartshop/pages/profile.dart';

class MainScreen extends StatefulWidget {
  @override
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  final List<Widget> pages = [Home(), CartPage(), Profile()];

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Produits",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
      body: pages[index],
    );
  }
}
