import 'package:flutter/material.dart';
import 'package:smartshop/pages/product.dart';

class ProductShow extends StatefulWidget {
  final Product product;

  const ProductShow({super.key, required this.product});

  @override
  State<ProductShow> createState() => ProductShow_State();
}

class ProductShow_State extends State<ProductShow> {
  bool favorite = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(15),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/details", arguments: widget.product);
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: SizedBox(
              width: 60,
              child: Image.network(
                widget.product.image,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error,
                  ); // Si le lien est mort ou l'IP inaccessible
                },
              ),
            ),
            title: Text(
              widget.product.nom,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${widget.product.price} dhs",
              style: TextStyle(color: Colors.blueGrey),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  favorite = !favorite;
                });
              },
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border_rounded,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
