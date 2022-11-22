class LoginResponseDto {
  final String? token;
  final String? refresh;

  LoginResponseDto({this.token, this.refresh});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(token: json['token'], refresh: json['refresh']);
  }
}
