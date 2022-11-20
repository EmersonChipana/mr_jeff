class ResponseDto<T> {
  final T? data;
  final String? message;
  final bool success;

  ResponseDto({
    this.success = false,
    this.message,
    this.data,
  });

  factory ResponseDto.fromJson(Map<String, dynamic> json) {
    return ResponseDto(
      success: json['success'],
      message: json['message'],
      data: json['data'],
    );
  }
}
