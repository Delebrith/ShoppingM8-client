package edu.pw.shoppingm8.list.invitation.api.dto;

import edu.pw.shoppingm8.list.api.dto.ListDto;
import edu.pw.shoppingm8.list.invitation.db.ListInvitation;
import edu.pw.shoppingm8.user.api.dto.UserDto;
import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class ListInvitationDto {
    Long id;
    UserDto invited;
    UserDto inviting;
    ListDto list;

    public static ListInvitationDto of(ListInvitation entity) {
        return ListInvitationDto.builder()
                .id(entity.getId())
                .invited(UserDto.of(entity.getInvited()))
                .inviting(UserDto.of(entity.getInviting()))
                .list(ListDto.of(entity.getList()))
                .build();
    }
}
