import 'dart:convert';

import 'package:mr_jeff/dto/login_response_dto.dart';
import 'package:mr_jeff/dto/response_dto.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static const String backendUrlBase = "http://192.168.0.7:7777";
  static Future<LoginResponseDto> login(
      String username, String password) async {
    LoginResponseDto result;

    var uri = Uri.parse("$backendUrlBase/api/v1/auth/");
    var body = jsonEncode({
      'username': username,
      'password': password,
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    var response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == 200) {
      var responseDto = ResponseDto.fromJson(jsonDecode(response.body));

      if (responseDto.success) {
        result = LoginResponseDto.fromJson(responseDto.data);
      } else {
        throw Exception(responseDto.message);
      }
    } else {
      throw Exception('Failed to login.');
    }
    return result;
  }
}
