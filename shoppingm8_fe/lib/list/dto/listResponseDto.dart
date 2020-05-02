import 'package:shoppingm8_fe/user/userDto.dart';

class ListResponseDto {
  final num id;
  final String name;
  final UserDto owner;
  final List<UserDto> members;

  ListResponseDto({this.id, this.name, this.owner, this.members});

  factory ListResponseDto.fromJson(Map<String, dynamic> json) {
    List memberList = json['members'] as List;
    return ListResponseDto(
        id: json['id'],
        name: json['name'],
        owner: UserDto.fromJson(json['owner']),
        members: memberList.map((member) => UserDto.fromJson(member)).toList()
    );
  }
}