class Product {
  final String id;
  final String name;
  final String description;
  final double price; // Để giá vẫn là double
  final String image;
  final int stock; // Phải là int
  final int discount; // Phải là int

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.stock,
    required this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      price: (json['price'] is int) ? json['price'].toDouble() : json['price'],
      image: json['image'],
      stock:
          json['stock'] is int ? json['stock'] : (json['stock'] as num).toInt(),
      discount: json['discount'] is int
          ? json['discount']
          : (json['discount'] as num).toInt(),
    );
  }
}
