import 'dart:convert';

import 'package:mr_jeff/dto/product_dto.dart';
import 'package:mr_jeff/dto/response_dto.dart';
import 'package:mr_jeff/ip.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static Future<List<Product>> getProductsByCategory(
      String token, int categoryId) async {
    const url = ipUrl;
    List<Product> result = [];
    var uri = Uri.parse("$url/api/v1/product/category/$categoryId");
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      ResponseDto backendResponse =
          ResponseDto.fromJson(jsonDecode(response.body));
      if (backendResponse.success) {
        List<dynamic> data = backendResponse.data;
        result = data.map((e) => Product.fromJson(e)).toList();
      } else {
        throw Exception(backendResponse.message);
      }
    } else {
      throw Exception("Error al obtener productos");
    }
    return result;
  }
}
