class ListRequestDto {
  final String name;

  ListRequestDto({this.name});

  Map toJson() {
    Map map = Map();
    map['name'] = name;
    return map;
  }
}