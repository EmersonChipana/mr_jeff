import 'dart:convert';

import 'package:mr_jeff/dto/clothing_order_dto.dart';
import 'package:mr_jeff/ip.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static String url = ipUrl;

  Future<void> addClothingOrder(List<ClothingOrderDto> clothings) async {
    var uri = Uri.parse("$url/api/v1/order/add");
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      //"Authorization": 'Bearer $token',
    };

    Map<String, dynamic> map = {
      "clothings": clothings.map((e) => e.toJson()).toList(),
    };

    var body = jsonEncode(map);

    var response = await http.post(uri, headers: headers, body: map);
    if(response.statusCode == 200) {
      print("Pedido realizado");
    } else {
      throw Exception("Error al realizar pedido");
    }
  
  }
}
