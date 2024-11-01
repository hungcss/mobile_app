import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'cart_screen.dart';
import 'user_profile.dart';
import 'product_detail.dart';
import '../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _productService.fetchProducts();
    setState(() {
      _products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy provider cho giỏ hàng
    final cartProvider = Provider.of<CartProvider>(context);

    // Lọc sản phẩm dựa trên truy vấn tìm kiếm
    List<Product> filteredProducts = _products.where((product) {
      final query = _searchQuery.toLowerCase();
      return product.name.toLowerCase().contains(query);
      // Bỏ qua việc tìm kiếm theo 'type' vì nó không tồn tại
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Mobile Store",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.facebook),
              onPressed: () {
                // Handle Facebook icon action here
              },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt), // Instagram icon alternative
              onPressed: () {
                // Handle Instagram icon action here
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Chuyển đến trang giỏ hàng khi nhấn vào biểu tượng giỏ hàng
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => CartScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products by name",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (ctx, i) {
                final product = filteredProducts[i];
                return GestureDetector(
                  onTap: () {
                    // Chuyển đến trang chi tiết sản phẩm
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            child: Image.network(
                              product.image, // Sửa từ 'imageUrl' thành 'image'
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                    'assets/images/placeholder.png'); // Placeholder image
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name.length > 20
                                ? "${product.name.substring(0, 17)}..."
                                : product.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "\$${product.price.toStringAsFixed(2)}", // Định dạng giá
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffffffff),
        selectedItemColor: Colors.red,
        unselectedItemColor: Color(0xb33f3e3e),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            // Chuyển đến giỏ hàng
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => CartScreen()),
            );
          } else if (index == 2) {
            // Chuyển đến trang hồ sơ người dùng
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => UserProfileScreen(username: widget.username),
              ),
            );
          }
        },
      ),
    );
  }
}
