class AuthenticationResponseDto {
  final String accessToken;
  final String refreshToken;

  AuthenticationResponseDto({this.accessToken, this.refreshToken});

  factory AuthenticationResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponseDto(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken']
    );
  }
}