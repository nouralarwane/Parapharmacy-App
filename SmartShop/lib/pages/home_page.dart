import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartshop/ApiURL.dart';
import 'package:smartshop/pages/cart_page.dart';
import 'package:smartshop/pages/favorites_page.dart';
import 'package:smartshop/pages/registration.dart';
import 'package:smartshop/pages/profile.dart';
import 'package:smartshop/pages/search_page.dart';
import 'package:smartshop/pages/settings_page.dart';
import 'package:smartshop/widgets/categories.dart';
import 'package:smartshop/widgets/product_show.dart';
import 'package:smartshop/widgets/section_title.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// void main() {
//   runApp(Home());
// }

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({super.key});
  static List<Product> addedProduct = [];

  @override
  State<Home> createState() => Home_State();
}

class Home_State extends State<Home> {
  List<Product> products = [
    Product(
      id: 1,
      image: "assets/products/phone.png",
      nom: "Smartphone Android Pro",
      price: 2199,
      stock: 20,
      description:
          "Ecran AMOLED 6.7, 128 Go, 8 Go RAM, Caméra 108 MP, Batterie 5000 mAh",
      type: "Smartphone Android Pro",
    ),
    Product(
      id: 2,
      image: "assets/products/laptop.png",
      nom: "Ordinateur Portable",
      price: 8999,
      stock: 20,

      description:
          "Ecran AMOLED 6.7, 128 Go, 8 Go RAM, Caméra 108 MP, Batterie 5000 mAh",
      type: "Smartphone Android Pro",
    ),
    Product(
      id: 3,
      image: "assets/products/watch.png",
      nom: "Smart watch",
      price: 999,
      stock: 20,
      description:
          "Ecran AMOLED 6.7, 128 Go, 8 Go RAM, Caméra 108 MP, Batterie 5000 mAh",
      type: "Smartphone Android Pro",
    ),
  ];

  List<Product> api_Products = []; // products from the API

  final storage = FlutterSecureStorage(); // To get the logged user

  Map<String, dynamic>? user; // The actual user
  final user_url = '${Apiurl.URL}${Apiurl.cart_Endpoint}';
  final access_token_url = '${Apiurl.URL}${Apiurl.access_token_Endpoint}';
  final refresh_token_url = '${Apiurl.URL}${Apiurl.refresh_token_Endpoint}';

  // Fecthing the products from the API
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${Apiurl.URL}${Apiurl.products_Endpoint}'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        final List<dynamic> results = jsonData['results'];
        // print("Les produits sont: ${results}");

        setState(() {
          api_Products = results
              .map((product) => Product.fromJson(product))
              .toList();
        });
      } else {
        print(Exception("Erreur serveur: ${response.statusCode}"));
      }
    } catch (e) {
      print("Erreur de connexion pour les produits: $e");
    }
  }

  // Get the user infos
  Future<void> fetchUserProfile() async {
    final username = await storage.read(key: "username");

    try {
      final response = await http.get(
        Uri.parse('${Apiurl.URL}${Apiurl.profile_Endpoint}'),
      );
      final results = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Seek for the actual user
        for (var User in results["results"]) {
          if (User["username"].trim() == username!.trim()) {
            setState(() {
              user = User; // 2. On met à jour l'UI ici !
            });

            // Store the connected user
            storage.write(key: "user", value: jsonEncode(user));
            break;
          }
        }
      }
    } catch (e) {
      print("Erreur de serveur côté home pour le profil: $e");
    }
  }

  // Check the token validity
  Future<void> check_token_validity() async {
    fetchUserProfile();
    final access_token = await storage.read(key: "access");
    final refresh_token = await storage.read(key: "refresh");

    print("access: $access_token");
    try {
      final response = await http.get(
        Uri.parse(user_url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $access_token",
        },
      );

      // Access token is good
      if (response.statusCode == 200) {
        print("The access token est bon, il n'est pas expiré");
      }
      // Access token is not usable
      else {
        final response = await http.post(
          Uri.parse(refresh_token_url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"refresh": refresh_token}),
        );

        if (response.statusCode == 200) {
          final results = jsonDecode(response.body);
          storage.write(
            key: "access",
            value: results["access"],
          ); // Storing the access token
          storage.write(
            key: "refresh",
            value: results["refresh"],
          ); // Storing the refresh token
        } else {
          print("Le code status dans check token: ${response.statusCode}");
        }
      }
    } catch (e) {
      print("Erreur au niveau du serveur dans check token: $e");
    }
  }

  @override
  void initState() {
    fetchProducts();
    check_token_validity();

    fetchUserProfile();

    super.initState();
  }

  String message = "";
  List<Product> filteredList = [];

  void user_message(String value) {
    setState(() {
      message = value;
      filteredList = products
          .where((p) => p.nom.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 40,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => Profile()),
              ),
              child: CircleAvatar(
                radius: 60,
                // Plus besoin de rajouter l'IP car ton JSON l'a déjà (vu ton print) !
                backgroundImage: user != null
                    ? NetworkImage(user!["image"])
                    : AssetImage("assets/joe.JPG") as ImageProvider,
              ),
            ),
          ),
        ),

        title: ListTile(
          title: Text(
            "Good Morning!!👋",
            style: TextStyle(fontWeight: FontWeight(500)),
          ),
          subtitle: Text(
            "Hello ${user == null ? 'Guy, you\'re not connected😏👉!' : user!["username"]}",
            style: TextStyle(fontWeight: FontWeight(500)),
          ),
        ),

        actions: [
          Container(
            margin: EdgeInsets.only(right: 30),
            child: user == null
                // Login Page icon if the user is not connected
                ? InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Registration(),
                      ),
                    ),
                    child: Icon(Icons.login),
                  )
                : // Cart Page icon if the user is connected
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CartPage(),
                      ),
                    ),
                    child: Icon(Icons.shopping_cart),
                  ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),

      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         onTap: () => {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (BuildContext context) => Home()),
      //           ),
      //         },
      //         title: Text("Home"),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.person),
      //         onTap: () => {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => Profile(),
      //             ),
      //           ),
      //         },
      //         title: Text("Profile"),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.settings),
      //         onTap: () => {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => SettingsPage(),
      //             ),
      //           ),
      //         },
      //         title: Text("Settings"),
      //       ),
      //     ],
      //   ),
      // ),
      body: Container(
        margin: EdgeInsets.only(top: 10, left: 10),
        child: Column(
          children: [
            Container(  
             child: SearchPage(onText: user_message),
             
            ),

            SectionTitle(title: "Categories"),
            const Categories(),

            Expanded(
              child: ListView.builder(
                itemCount: api_Products.length,
                itemBuilder: (context, index) {
                  return ProductShow(product: api_Products[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
