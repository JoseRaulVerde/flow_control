import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/product.dart';

class WorkApiService {
  final String _baseUrl = 'https://tu-api.com/api';

  Future<Product?> fetchProductByName(String name) async {
    final response = await http.get(Uri.parse('$_baseUrl/products?search=$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data.isNotEmpty) {
        return Product.fromJson(data[0]); // si la respuesta es una lista
      }
    }
    return null;
  }

  Future<bool> sendConfirmedProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/products/confirm'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    return response.statusCode == 200;
  }
}