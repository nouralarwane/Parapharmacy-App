class Product {
  final int id;
  final String nom;
  final double price;
  final String image;
  final int stock;
  final String description;
  final String? type;

  Product({
    required this.id,
    required this.nom,
    required this.description,
    required this.price,
    required this.image,
    required this.stock,
    this.type,
  });

  factory Product.fromJson(Map<String, dynamic> json) { 
    return Product(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      image: (json["image"] != null && json["image"] is String)
          ? json["image"]
          : "",
      stock: json["stock"] is int
          ? json["stock"]
          : int.parse(json["stock"].toString()),
      nom: json["name"] ?? "Produit sans nom",
      price: json['price'] is num
          ? json['price'].toDouble()
          : double.parse(json['price'].toString()),
      description: json["description"],
      type: json["type"] ?? "",
    );
  }
}
