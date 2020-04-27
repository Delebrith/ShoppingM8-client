import 'package:shoppingm8_fe/user/userDto.dart';

class ListResponseDto {
  final num id;
  final String name;
  final UserDto owner;

  ListResponseDto({this.id, this.name, this.owner});

  factory ListResponseDto.fromJson(Map<String, dynamic> json) {
    return ListResponseDto(
        id: json['id'],
        name: json['name'],
        owner: UserDto.fromJson(json['owner'])
    );
  }
}