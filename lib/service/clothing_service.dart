import 'dart:convert';

import 'package:mr_jeff/dto/clothing_card_dto.dart';
import 'package:mr_jeff/dto/clothing_dto.dart';
import 'package:mr_jeff/dto/response_dto.dart';
import 'package:mr_jeff/ip.dart';
import 'package:http/http.dart' as http;

class ClothingService {
  final url = ipUrl;
  Future<List<ClothingCardDto>> getClothingsByCategory(int categoryId) async {
    List<ClothingCardDto> result = [];
    var uri = Uri.parse("$url/api/v1/clothing/category/$categoryId");
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      ResponseDto backendResponse =
          ResponseDto.fromJson(jsonDecode(response.body));
      if (backendResponse.success) {
        List<dynamic> data = backendResponse.data;
        result = data.map((e) => ClothingCardDto.fromJson(e)).toList();
      } else {
        throw Exception(backendResponse.message);
      }
    } else {
      throw Exception("Error al obtener productos");
    }
    return result;
  }

  Future<ClothingDto> getClothingById(int productId) async {
    const url = ipUrl;
    ClothingDto result;
    var uri = Uri.parse("$url/api/v1/clothing/$productId");
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      ResponseDto backendResponse =
          ResponseDto.fromJson(jsonDecode(response.body));
      if (backendResponse.success) {
        result = ClothingDto.fromJson(backendResponse.data);
      } else {
        throw Exception(backendResponse.message);
      }
    } else {
      throw Exception("Error al obtener producto");
    }
    return result;
  }
}
