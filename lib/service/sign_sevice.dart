import 'dart:convert';
import 'dart:math';

import 'package:mr_jeff/dto/response_dto.dart';
import 'package:mr_jeff/dto/user_info_dto.dart';
import 'package:mr_jeff/const.dart';

import 'package:http/http.dart' as http;

class SignService {
  String _url = "$backendUrlBase/api/v1/sign/";
  Future<void> sign(String firstName, String lastName, String numPhone,
      String username, String email, String password) async {
    var uri = Uri.parse(_url);
    var body = jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
      "numPhone": numPhone,
      "username": username,
      "email": email,
      "secret": password
    });
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var responseDto = ResponseDto.fromJson(data);
      if (responseDto.success) {
        var userInfoDto = UserInfoDto.fromJson(responseDto.data);
        print(userInfoDto);
      } else {
        print(responseDto.message);
      }
    } else {
      print(response.statusCode);
    }
  }

  void signv2(String firstName, String lastName, String numPhone, String email,
      String username, String password, int gender, String role) {

    String uri1 = "$backendUrlBase/api/v1/user/prenewv2";
     
    var uri = Uri.parse(uri1); 
    var body = jsonEncode({
      "username":username,
    "password": password,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "numPhone": numPhone,
    "gender": gender,
    "role": role ,
      "token": ""
    });
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    http.post(uri, headers: headers, body: body);
  }
  Future<void>  signv2Token(String firstName, String lastName, String numPhone, String email,
      String username, String password, int gender, String role, String token) async{

    String uri1 = "$backendUrlBase/api/v1/user/newv2";
     
    var uri = Uri.parse(uri1); 
    var body = jsonEncode({
      "username":username,
    "password": password,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "numPhone": numPhone,
    "gender": gender,
    "role": role ,
      "token": token
    });
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var response = await http.post(uri, headers: headers, body: body);
    if(response.statusCode == 200){

      ResponseDto backendResponse = ResponseDto.fromJson(jsonDecode(response.body));
      if(backendResponse.success){
 
      }else{

        throw Exception(backendResponse.message);
      }
    }else{

      throw Exception("problemas con el backend code:${response.statusCode}");
    }
  }
}
