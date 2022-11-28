
import 'package:mr_jeff/const.dart';
import 'package:mr_jeff/dto/pickup_dto/prepickupinfo_v2_dto.dart';
import 'package:http/http.dart' as http;
import 'package:mr_jeff/dto/response_dto.dart';
import 'dart:convert';

class PrePickUpServiceV2{
  static Future<PrePickUpInfoV2Dto> getSchedule(int userId, String token) async{
    PrePickUpInfoV2Dto result;
    var uri = Uri.parse("$backendUrlBase/api/v1/test/prePickUpV2/$userId");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(uri, headers: headers);

    if(response.statusCode == 200){
      ResponseDto backendResponse = ResponseDto.fromJson(jsonDecode(response.body));
      
      if(backendResponse.success){
        result = PrePickUpInfoV2Dto.fromJson(backendResponse.data);
      }else{
        throw Exception(backendResponse.message);
      }
    }else{
      throw Exception(
          "Error desconocido al intentar consultar la informacion de un prepickup"
      );
    }


    return result;
  }
}