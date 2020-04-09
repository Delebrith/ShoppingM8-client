class RegistrationDto  {
  final String email;
  final String password;
  final String name;

  RegistrationDto(this.email, this.password, this.name);

  Map toJson() {
    Map map = Map();
    map['email'] = email;
    map['password'] = password;
    map['name'] = name;
    return map;
  }
}