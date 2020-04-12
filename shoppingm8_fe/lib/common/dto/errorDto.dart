class ErrorDto {
  final num code;
  final String message;
  final String uri;

  ErrorDto({this.code, this.message, this.uri});

  factory ErrorDto.fromJson(Map<String, dynamic> json) {
    return ErrorDto(
      code: json['code'],
      message: json['message'],
      uri: json['uri']
    );
  }
}