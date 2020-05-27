import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';
import 'package:shoppingm8_fe/user/dto/userDto.dart';

class ListInvitationDto {
  final num id;
  final UserDto invited;
  final UserDto inviting;
  final ListResponseDto list;

  ListInvitationDto({this.id, this.invited, this.inviting, this.list});

  factory ListInvitationDto.fromJson(Map<String, dynamic> json) {
    return ListInvitationDto(
      id: json['id'],
      invited: UserDto.fromJson(json['invited']),
      inviting: UserDto.fromJson(json['inviting']),
      list: ListResponseDto.fromJson(json['list']),
    );
  }
}