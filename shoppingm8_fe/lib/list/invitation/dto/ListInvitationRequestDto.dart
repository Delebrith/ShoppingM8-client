class ListInvitationRequestDto {
  final num invitedId;

  ListInvitationRequestDto(this.invitedId);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['invitedId'] = invitedId;
    return map;
  }
}