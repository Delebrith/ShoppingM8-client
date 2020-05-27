class SocialMediaLoginDto  {
  final String token;

  SocialMediaLoginDto({this.token});

  Map toJson() {
    Map map = Map();
    map['token'] = token;
    return map;
  }
}