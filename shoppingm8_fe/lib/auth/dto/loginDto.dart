class LoginDto  {
  final String email;
  final String password;

  LoginDto({this.email, this.password});

  Map toJson() {
    Map map = Map();
    map['email'] = email;
    map['password'] = password;
    return map;
  }
}