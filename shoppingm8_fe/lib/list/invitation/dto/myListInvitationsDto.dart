import 'package:shoppingm8_fe/list/invitation/dto/listInvitationDto.dart';

class MyListInvitationsDto {
  final List<ListInvitationDto> sent;
  final List<ListInvitationDto> received;

  MyListInvitationsDto({this.sent, this.received});

  factory MyListInvitationsDto.fromJson(Map<String, dynamic> json) {
    List sentList = json['sent'] as List;
    List receivedList = json['received'] as List;
    return MyListInvitationsDto(
      sent: sentList.map((dto) => ListInvitationDto.fromJson(dto)).toList(),
      received: receivedList.map((dto) => ListInvitationDto.fromJson(dto)).toList()
    );
  }
}