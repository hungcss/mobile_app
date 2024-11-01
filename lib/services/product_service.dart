import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final Uri url =
      Uri.parse('https://api.jsonbin.io/v3/b/6722e078e41b4d34e44ba170');

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List products = json.decode(response.body)['record'];
        return products.map((product) => Product.fromJson(product)).toList();
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching products: $error");
    }
    return [];
  }
}
