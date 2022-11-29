import 'dart:convert';

import 'package:mr_jeff/dto/clothing_order_dto.dart';
import 'package:mr_jeff/ip.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static String url = ipUrl;

  Future<bool> addClothingOrder(List<ClothingOrderDto> clothings) async {
    var uri = Uri.parse("$url/api/v1/order/add");
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      //"Authorization": 'Bearer $token',
    };

    //Convertir a Json la lista clothings
    List<Map<String, dynamic>> clothingsJson = [];
    for (var element in clothings) {
      clothingsJson.add(element.toJson());
    }
    var body = jsonEncode(clothingsJson);
    print("Body: $body");
    try {
      var response = await http.post(uri, headers: headers, body: body);
      print("Se recibio la respuesta: ${response.body}");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
