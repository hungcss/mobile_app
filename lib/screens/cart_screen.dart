import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/item.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: cartProvider.cartItems.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (ctx, i) {
                      final item = cartProvider.cartItems[i];
                      return ListTile(
                        leading: Image.network(
                            item.product.image), // Đổi imageUrl thành image
                        title: Text(item.product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Price: \$${item.product.price.toStringAsFixed(2)}"), // Định dạng giá
                            Text(
                                "Total: \$${item.totalPrice.toStringAsFixed(2)}"), // Định dạng giá
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                cartProvider
                                    .decreaseQuantity(item); // Giảm số lượng
                              },
                            ),
                            Text("${item.quantity}"),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {
                                cartProvider
                                    .increaseQuantity(item); // Tăng số lượng
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}", // Định dạng tổng
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    cartProvider.clearCart(); // Xóa giỏ hàng
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Purchase Successful!")),
                    );
                  },
                  child: Text("Checkout"),
                ),
              ],
            ),
    );
  }
}
