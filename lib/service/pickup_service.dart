import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mr_jeff/dto/response_dto.dart';

import 'package:mr_jeff/const.dart'; // key and ip 
 
class PickUpService{

  

  static Future<bool> addNewPickUp(Map<String, dynamic> mapa, String token) async {
    print('(PickUpService) == (addNewPickUp) : $mapa');

   
    
    
    bool result  = false;

    var uri = Uri.parse('$backendUrlBase/api/v1/test/pickup');

    var body = jsonEncode(mapa);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    //await Future.delayed(Duration(seconds: 2));
    var response = await http.post(uri, headers: headers, body: body);


    if(response.statusCode == 200){

      ResponseDto backendResponse = ResponseDto.fromJson(jsonDecode(response.body));
      if(backendResponse.success){

        print(backendResponse.data);
        if(backendResponse.data['wasCreated']){

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