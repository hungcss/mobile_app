import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị hình ảnh sản phẩm
            Image.network(
              product.image,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                    'assets/images/placeholder.png'); // Hình ảnh placeholder
              },
            ),
            SizedBox(height: 10),
            // Tên sản phẩm
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Giá sản phẩm
            Text("\$${product.price.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            // Mô tả sản phẩm
            Text(product.description),
            Spacer(),
            // Nút thêm vào giỏ hàng
            ElevatedButton(
              onPressed: () {
                cartProvider.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${product.name} added to Cart")),
                );
              },
              child: Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}
