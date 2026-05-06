import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:smartshop/ApiURL.dart';
import 'product.dart';

class ProductDetails extends StatefulWidget {
  @override
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => Details_State();
}

class Details_State extends State<ProductDetails> {
  @override
  void initState() {
    super.initState();
    userCart();
  }

  Product? produit;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // On récupère l'argument envoyé par la Home
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Product) {
      setState(() {
        produit = args;
      });
    }
  }

  List<dynamic> panier = []; // User cart
  List<dynamic> user_products = []; // User products
  List user_cart = []; //

  final storage =
      FlutterSecureStorage(); // to retrieve the variable in the phone storage

  // The URL
  final url = '${Apiurl.URL}${Apiurl.cart_Endpoint}';
  final remove_url = '${Apiurl.URL}${Apiurl.cart_remove_Endpoint}';
  final reduce_url = '${Apiurl.URL}${Apiurl.cart_reduce_Endpoint}';
  final add_url = '${Apiurl.URL}${Apiurl.cart_Endpoint}';

  // The user cart function
  Future<void> userCart() async {
    // Retrieve the token
    String? token = await storage.read(key: "access");
    if (token == null || token == "") {
      token = await storage.read(key: "refresh");
      print("Le token refresh");
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
          user_cart = panier
              .where((cart) => cart["product"] == produit!.id)
              .toList();
        });

        print("Le user cart du produit est: $user_cart");

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
        }
      } else {
        print("Erreur de récuperation!!");
      }
    } catch (e) {
      print("Erreur: $e");
    }
  }

  int? quantity; // the product quantity

  TextEditingController quantity_to_add_or_delete =
      TextEditingController(); // Quantity to add or delete

  String user_decision = ""; // The value to know if the user add or delete

  // The reduce function
  Future<void> reduce_cart_item() async {
    // Retrieve the token
    String? token = await storage.read(key: "access");
    if (token == null || token == "") {
      token = await storage.read(key: "refresh");
    }

    try {
      final response = await http.post(
        Uri.parse('$reduce_url${produit!.id}/'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "quantity": quantity_to_add_or_delete.text.isEmpty
              ? 0
              : quantity_to_add_or_delete.text,
        }),
      );

      if (response.statusCode == 200) {
        print("Reducing successfull!!");
        userCart();
        final results = jsonDecode(response.body);
        print("Les resultats: $results");
      } else {
        print("Erreur de suppression: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur au niveau du serveur: $e");
    }
  }

  // The delete function
  Future<void> delete_cart_item() async {
    // Retrieve the token
    String? token = await storage.read(key: "access");
    if (token == null || token == "") {
      token = await storage.read(key: "refresh");
    }

    try {
      final response = await http.post(
        Uri.parse('$remove_url${produit!.id}/'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("Deleting successfull!!");
        userCart();
        final results = jsonDecode(response.body);
        print("Les resultats: $results");
      } else {
        print("Erreur de suppression: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur au niveau du serveur: $e");
    }
  }

  // The add function
  Future<void> add_product() async {
    // Retrieve the token
    String? token = await storage.read(key: "access");
    if (token == null || token == "") {
      token = await storage.read(key: "refresh");
    }

    try {
      final response = await http.post(
        Uri.parse(add_url),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "cart": panier[0]["cart"],
          "product": produit!.id,
          "quantity": quantity_to_add_or_delete.text.isEmpty
              ? 0
              : quantity_to_add_or_delete.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Adding product successfull!!");
        userCart();
        final results = jsonDecode(response.body);
        print("Les resultats: $results");
      } else {
        print("Erreur d'ajout : ${jsonDecode(response.body)}");
        // print(
        //   "Les valeurs envoyées: ${user_cart[0]["cart"]}, ${produit!.id}, ${quantity_to_add_or_delete.text}",
        // );
      }
    } catch (e) {
      print("Erreur au niveau du serveur: $e");
    }
    quantity_to_add_or_delete.clear();
  }

  // The user decision function
  void Submission() async {
    if (user_decision == "delete") {
      reduce_cart_item();
      userCart();
    } else if (user_decision == "add") {
      add_product();
      userCart();
    }
  }

  // Confirmation dialog button of deleting
  Future<void> confirmation_delete(BuildContext context) async {
    // print("User decision: $user_decision");
    bool? decisionResult = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: user_decision == "supprimer"
              ? Text("Confirmation de suppression!!")
              : Text("Confirmation de reduction!!"),
          content: user_decision == "supprimer"
              ? Text(
                  "Voulez vous vraiment supprimer le produit de votre panier ?",
                )
              : Text("Voulez vous vraiment reduire la quantité ?"),
          actions: [
            // Annuler la suppression
            TextButton(
              onPressed: () => {Navigator.of(context).pop(false)},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
              ),
              child: Text("Annuler", style: TextStyle(color: Colors.white)),
            ),

            // Confirmer la suppression
            TextButton(
              onPressed: () => {Navigator.of(context).pop(true)},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: Text("Confirmer", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (decisionResult == true && user_decision == "reduce") {
      reduce_cart_item();

      setState(() {
        userCart();
      });
    } else {
      delete_cart_item();

      setState(() {
        userCart();
      });
    }
  }

  // Confirmation of adding the product
  Future<void> confirmation_add_product(BuildContext context) async {
    print("Quantity to add is: ${quantity_to_add_or_delete.text.length}");
    bool? decisionResult = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation d'ajout du produit"),
          content: Text(
            "Voulez vous vraiment ajouter le produit dans votre panier ?",
          ),
          actions: [
            // Annuler l'ajout
            TextButton(
              onPressed: () => {Navigator.of(context).pop(false)},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
              ),
              child: Text("Annuler", style: TextStyle(color: Colors.white)),
            ),

            // Confirmer l'ajout
            TextButton(
              onPressed: () => {Navigator.of(context).pop(true)},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: Text("Ajouter", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (decisionResult == true) {
      add_product();

      setState(() {
        userCart();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool productInCart = false; //product in cart or not
    final product = ModalRoute.of(context)?.settings.arguments as Product;

    // Check if the product is in the cart
    for (var value in panier) {
      if (value["product"] == product.id) {
        setState(() {
          quantity = value["quantity"];
        });
        break;
      }
    }
    if (user_products.any((p) => p["id"] == product.id)) {
      productInCart = true;
    }

    // ignore: dead_code, unnecessary_null_comparison
    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Erreur')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.nom, style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        // In case we get an overflow at the bottom
        child: Column(
          children: [
            // Image Line
            Row(
              children: [
                Expanded(
                  // padding: EdgeInsets.all(1),
                  child: SizedBox(
                    height: 450,
                    child: product.image != ""
                        ? Image.network(product.image, fit: BoxFit.contain)
                        : Icon(Icons.error),
                  ),
                ),
              ],
            ),

            // Line for the name and the price
            Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text(
                          "${product.nom} * ${quantity ?? 0}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),

                      Text(" "),

                      Text(
                        "${product.price} Dhs",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Details
            Text(
              product.description,
              style: TextStyle(overflow: TextOverflow.ellipsis),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            SizedBox(height: 20),

            // Stars
            Row(
              children: List.generate(5, (index) {
                return index == 4
                    ? Icon(
                        Icons.star,
                        fill: 0,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : index == 3
                    ? Icon(Icons.star_half, fill: 1, color: Colors.amber)
                    : Icon(Icons.star, fill: 1, color: Colors.amber);
              }),
            ),

            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  icon: !productInCart
                      ? Icon(Icons.shopping_cart)
                      : Icon(Icons.delete),
                  onPressed: () => {
                    // Check if the product is already in the cart
                    if (productInCart)
                      {
                        setState(() {
                          user_decision = "supprimer";
                        }),
                        confirmation_delete(context),
                      }
                    else
                      {
                        setState(() {
                          user_decision = "ajouter";
                        }),
                        confirmation_add_product(context),
                      },
                  },
                  label: !productInCart
                      ? Text(
                          "Ajouter au panier",
                          style: TextStyle(color: Colors.blue),
                        )
                      // ignore: dead_code
                      : Text(
                          "Retirer du panier",
                          style: TextStyle(color: Colors.red),
                        ),
                ),

                // The quantity field
                SizedBox(
                  height: 60,
                  width: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Quantity",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIconColor: Colors.black,
                    ),
                    onChanged: (value) => {
                      quantity_to_add_or_delete.text = value,
                    }, // Saving the first_name

                    controller: quantity_to_add_or_delete,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Cart button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // To increase the quantity
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      user_decision = "increase";
                    });
                    confirmation_add_product(context);
                  },
                  icon: Icon(Icons.add),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                    iconColor: WidgetStateProperty.all(Colors.white),
                  ),
                  label: Text("Add", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 20),
                // To decrease the quantity
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      user_decision = "reduce";
                    });
                    confirmation_delete(context);
                  },
                  icon: Icon(Icons.delete),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                    iconColor: WidgetStateProperty.all(Colors.white),
                  ),
                  label: Text("Reduce", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
