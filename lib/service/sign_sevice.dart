import 'dart:convert';

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
}
