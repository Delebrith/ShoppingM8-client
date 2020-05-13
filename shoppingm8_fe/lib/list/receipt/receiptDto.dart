import 'package:shoppingm8_fe/user/dto/userDto.dart';

class ReceiptDto {
  final num id;
  final String url;
  final UserDto createdBy;

  ReceiptDto({this.id, this.url, this.createdBy});

  factory ReceiptDto.fromJson(Map<String, dynamic> json) {
    return ReceiptDto(
        id: json['id'],
        url: json['url'],
        createdBy: UserDto.fromJson(json['createdBy'])
    );
  }
}
