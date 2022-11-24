import 'dart:convert';

import 'package:mr_jeff/dto/category_dto.dart';
import 'package:http/http.dart' as http;
import 'package:mr_jeff/dto/response_dto.dart';
import 'package:mr_jeff/ip.dart';

class CategoryService {
  static String url = ipUrl;

  Future<List<CategoryDto>> getCategories() async {
    List<CategoryDto> result = [];
    var uri = Uri.parse("$url/api/v1/product/category/all");
    Map<String, String> headers = {
      "Accept": "application/json",
      //'Authorization': 'Bearer $token',
    };
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      ResponseDto backendResponse =
          ResponseDto.fromJson(jsonDecode(response.body));
      if (backendResponse.success) {
        List<dynamic> data = backendResponse.data;
        result = data.map((e) => CategoryDto.fromJson(e)).toList();
      } else {
        throw Exception(backendResponse.message);
      }
    } else {
      throw Exception("Error al obtener categorias");
    }
    return result;
  }
}
