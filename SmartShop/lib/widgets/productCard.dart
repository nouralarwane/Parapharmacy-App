import 'package:flutter/material.dart';
import 'package:smartshop/pages/product.dart';

class Productcard extends StatelessWidget {
  final Product product;

  const Productcard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromARGB(255, 218, 214, 231),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(30),
                height: 200,
                width: 300,
                child: Row(
                  children: [
                    Image.asset(product.image, fit: BoxFit.contain),
                    Column(
                      children: [
                        Text(product.description),
                        Text("${product.price} dhs"),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(19),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Image.asset(product.image, fit: BoxFit.cover)),
              SizedBox(height: 8),

              Text(product.nom),
              Text("${product.price} Dhs"),
              SizedBox(height: 8),

              OutlinedButton.icon(
                onPressed: () => {
                  Navigator.pushNamed(context, "/details", arguments: product),
                },
                icon: Icon(Icons.info_outline),
                label: Text("Details"),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD6C8FF), width: 1),
                  backgroundColor: const Color(0xFFF7F3FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
