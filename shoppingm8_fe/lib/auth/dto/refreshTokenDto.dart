class RefreshTokenDto {
  final String refreshToken;

  RefreshTokenDto(this.refreshToken);

  Map toJson() {
    Map map = Map();
    map['refreshToken'] = refreshToken;
    return map;
  }
}