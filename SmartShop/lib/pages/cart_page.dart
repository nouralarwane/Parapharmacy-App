import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:smartshop/ApiURL.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPage();
}

class _CartPage extends State<CartPage> {
  List<dynamic> panier = [];
  List<dynamic> user_products = [];

  // The URL
  final url = '${Apiurl.URL}${Apiurl.cart_Endpoint}';

  final storage = FlutterSecureStorage();

  // User cart
  Future<void> userCart() async {
    // Retrieve the token
    String? token = await storage.read(key: "access");
    if (token == null || token == "") {
      token = await storage.read(key: "refresh");
      print("Le token refresh: $token");
    } else {
      print("Le token access: $token");
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final results = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          panier = results;
        });

        final response = await http.get(
          Uri.parse('${Apiurl.URL}${Apiurl.products_Endpoint}'),
        );

        var result = jsonDecode(response.body);
        List<dynamic> finalResults = [];

        if (response.statusCode == 200) {
          for (var value in panier) {
            final resultat = result["results"]
                .where((product) => product["id"] == value["product"])
                .toList();
            // ignore: dead_code
            finalResults.add(resultat[0]);
          }

          setState(() {
            user_products = finalResults;
          });

          print("Les users products: $finalResults");
        }
      } else {
        print("Erreur de récuperation!!");
      }
    } catch (e) {
      print("Erreur: $e");
    }
  }

  // Calcul correct du total
  double get prixTotal {
    double price = 0;
    for (var i = 0; i < panier.length; i++) {
      price += panier[i]["quantity"] * double.parse(user_products[i]["price"]);
    }
    return price;
  }

  @override
  void initState() {
    userCart();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user_products.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome to your cart dear customer😉!!",
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: user_products.length,
                itemBuilder: (context, index) {
                  final product = user_products[index];
                  return Card(
                    elevation: 4,
                    child: Row(
                      children: [
                        Image.network(
                          product["image"],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),

                        SizedBox(width: 20, height: 20),
                        Column(
                          children: [
                            Text("${product["price"]} Dhs"),
                            // Text(
                            //   // product["description"],
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                        Divider(height: 100),
                      ],
                    ),
                  );
                },
              ),
            ),
            Text("Le prix total pour ces produits est: $prixTotal dhs"),
          ],
        ),
      ),
    );
  }
}
