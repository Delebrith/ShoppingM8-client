import 'package:eventhandler/eventhandler.dart';
import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';

class InvitationAcceptedEvent extends EventBase {
  final ListResponseDto listDto;

  InvitationAcceptedEvent(this.listDto);
}
