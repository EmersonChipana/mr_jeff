import 'package:mr_jeff/dto/ope_courier_dto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mr_jeff/dto/response_dto.dart';
import 'package:mr_jeff/model/operation_model/ope_courier_info.dart';
import 'package:mr_jeff/const.dart'; // key and ip 
class OpeCourierService{

  static Future<OpeCourierDto> getOperationInfo(String token) async{
    OpeCourierDto result;

  

    var uri = Uri.parse('$backendUrlBase/api/v1/test/available');

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.get(uri, headers: headers);

    if(response.statusCode == 200){
      ResponseDto backendResponse = ResponseDto.fromJson(jsonDecode(response.body));
      if(backendResponse.success){
        result = OpeCourierDto.fromJson(backendResponse.data);
      }else{


        throw Exception(backendResponse.message);
      }
    }else{
      throw Exception(
          "Lo mas probalble error del servidor ${response.statusCode}"
      );
    }
    return result;
  }

  static Future<bool> sendOperation(String token,  bool accepted, OpeCourierInfo flag) async{


    print('toker: $token    Accepted: $accepted, flag: $flag');
 
    bool result  = false;
    var uri = Uri.parse('$backendUrlBase/api/v1/test/confirmjob');
    Map<String, dynamic> mapa = {
      "idJobOperation": flag.id,
      "idOperationStateId": flag.operationId,
      "operation": flag.operation,
      "accepted": accepted
    };

    var body = jsonEncode(mapa);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.post(uri, headers: headers, body: body);

    if(response.statusCode == 200){
      ResponseDto backendResponse = ResponseDto.fromJson(jsonDecode(response.body));
      if(backendResponse.success){
        print('${backendResponse.data}');
        if(backendResponse.data['updateStatus']){
          result = true;
        }
      }else{
        throw Exception(backendResponse.message);
      }
    }else{
      throw Exception("problemas con el backend code:${response.statusCode}");
    }

    return result;

  }

}