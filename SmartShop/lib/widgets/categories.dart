import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartshop/ApiURL.dart';
import 'package:smartshop/pages/home_page.dart';
import 'package:smartshop/pages/product_Details.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => Categories_State();
}

class Categories_State extends State<Categories> {
  List<dynamic> categories = [];

  final categories_url =
      '${Apiurl.URL}${Apiurl.categories_endpoint}'; // The url for the categories

  @override
  void initState() {
    fetch_categories();

    super.initState();
  }

  // Fetch the categories
  Future<void> fetch_categories() async {
    final response = await http.get(Uri.parse(categories_url));

    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);

      setState(() {
        categories = results["results"];
      });

      print("Success fetching categories!!!");
    } else {
      print('Erreur de fetch dans categories');
    }
  }

  bool color = false;
  String categorie = "";
  String user_value = "";
  // String user_input = SearchPage_State().user_value;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            children: [
              ...categories.map((category) {
                return InkWell(
                  onTap: () => setState(() {
                    categorie = category["name"]!;
                  }),
                  child: Column(
                    children: [
                      // Category image
                      Container(
                        height: 90,
                        margin: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: DecorationImage(
                            image: NetworkImage(category["image"]),
                            // fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              categorie == category["image"]
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              BlendMode.srcOver,
                            ),
                          ),
                        ),
                        child: SizedBox(
                          
                          width: 80,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(category["image"]),
                            foregroundColor: Colors.blueAccent,
                          ),
                        ),
                      ),

                      // Name of category
                      Text(
                        category["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),

          Text(categorie != "" ? "Catégorie sélectionnée : $categorie" : ""),
        ],
      ),
    );
  }
}
