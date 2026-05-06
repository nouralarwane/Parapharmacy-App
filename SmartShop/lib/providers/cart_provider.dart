import 'package:flutter/material.dart';
import 'package:smartshop/pages/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> panier = [];

  List get Panier => panier;

  // Adding a product to the cart
  void addProduct(Product product) {
    panier.add(product);

    notifyListeners();
  }

  // Removing a product from the cart
  void removeProduct(Product product) {
    panier.remove(product);

    notifyListeners();
  }
}
