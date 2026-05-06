import 'package:flutter/material.dart';
import 'package:smartshop/pages/cart_page.dart';
import 'package:smartshop/pages/main_screen.dart';
import 'package:smartshop/providers/cart_provider.dart';
import 'pages/product_Details.dart';
import 'pages/profile.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialise la DB
  // await DbService.instance.db;

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => MainScreen(),
        "/details": (context) => ProductDetails(),
        "/profile": (context) => Profile(),
        "/panier": (context) => CartPage(),
      },
      debugShowCheckedModeBanner: false,

      title: "Mon test",
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
