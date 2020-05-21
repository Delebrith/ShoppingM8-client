class FcmTokenDto {
  final String token;

  FcmTokenDto({this.token});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['token'] = this.token;
    return map;
  }
}