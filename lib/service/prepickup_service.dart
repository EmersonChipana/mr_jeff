 import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mr_jeff/dto/prepickup_dto.dart';
import 'package:mr_jeff/dto/response_dto.dart';
import 'package:mr_jeff/const.dart'; // key and ip 

class PrePickUpService{

 

  static Future<PrePickUpDto> getPrePickUp(int userId, String token) async{

    PrePickUpDto result;

 
    var uri = Uri.parse("$backendUrlBase/api/v1/test/prePickUp/$userId");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    // se invoca al backend
    var response = await http.get(uri, headers: headers);

    //await Future.delayed(Duration(seconds: 1));
    if(response.statusCode == 200){
      ResponseDto backendResponse = ResponseDto.fromJson(jsonDecode(response.body));
      print('(prepickUp_Service) == (getPrePickUp) $backendResponse');
      print('${backendResponse.success}');
      print('${backendResponse.message}');
      print('${backendResponse.data}');
      if(backendResponse.success){
        result = PrePickUpDto.fromJson(backendResponse.data);
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

  static Future<int> isValidAreaService(Map<String, double> coord, String? token)async {
    int result = -1;
    //await Future.delayed(Duration(seconds: 1));

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    //http://localhost:7777/api/v1/test/prePickUp/branches?lat=-16.642356933136433&lng=-68.28699611991307
    var uri = Uri.parse('$backendUrlBase/api/v1/test/prePickUp/branches?lat=${coord['lat']}&lng=${coord['lng']}');
    var response = await http.get(uri, headers: headers);

    if(response.statusCode == 200){

      ResponseDto backendResponse = ResponseDto.fromJson(jsonDecode(response.body));
      if(backendResponse.success){
        print('${backendResponse.data}');
        print('isValidAreaService === ${backendResponse.data['isValidForService']}');
        if(backendResponse.data['isValidForService']){
          result = 1;
        }else{
          result = 2;
        }
      }else{
        throw Exception(backendResponse.message);
      }
    }else{
      throw Exception("Error del backend");
    }
    

    return result;
  }



}