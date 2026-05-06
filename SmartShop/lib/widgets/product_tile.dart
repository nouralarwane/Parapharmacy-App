import 'package:flutter/material.dart';

class ProductTile extends StatefulWidget {
  late String image;
  late double price;
  late String nom;

  ProductTile({
    super.key,
    required this.image,
    required this.nom,
    required this.price,
  });

  @override
  State<ProductTile> createState() => ProductTileState();
}

class ProductTileState extends State<ProductTile> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Image.asset(
            widget.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            Text(
              widget.nom,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () => setState(() {
            favorite = !favorite;
          }),
          child: Icon(favorite ? Icons.favorite : Icons.favorite_border),
        ),
      ],
    );
  }
}
