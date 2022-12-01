import 'dart:convert';

import 'package:mr_jeff/const.dart';
import 'package:mr_jeff/dto/response_dto.dart';
import 'package:mr_jeff/model/delivery_model/clothings_list_order_model.dart';
import 'package:http/http.dart' as http;

class DeliveryService {
  final url = backendUrlBase;

  Future<List<ClothingsListOrderModel>> getClothingsOrder(int id) async {
    List<ClothingsListOrderModel> result = [];
    var uri = Uri.parse("$url/api/v1/order/clothings/$id");
    Map<String, String> headers = {
      "Accept": "application/json",
      //"Authorization": "Bearer $token",
    };
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      ResponseDto backendResponse =
          ResponseDto.fromJson(jsonDecode(response.body));
      if (backendResponse.success) {
        List<dynamic> data = backendResponse.data;
        result = data.map((e) => ClothingsListOrderModel.fromJson(e)).toList();
      } else {
        throw Exception(backendResponse.message);
      }
    } else {
      throw Exception("Error al obtener productos");
    }
    return result;
  }

  Future<void> createDelivery(Map<String, dynamic> mapa, String token) async {
    
  }
}
