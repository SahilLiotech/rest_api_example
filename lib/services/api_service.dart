import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rest_api_example/models/product.dart';

class ApiServices {
  final String baseUrl = "https://fakestoreapi.com/";

  Future<List<Product>> getData() async {
    final response = await http.get(Uri.parse("${baseUrl}products"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse("${baseUrl}products"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse("${baseUrl}products/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse("${baseUrl}products/$id"));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
