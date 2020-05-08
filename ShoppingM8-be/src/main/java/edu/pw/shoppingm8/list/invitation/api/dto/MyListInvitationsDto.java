package edu.pw.shoppingm8.list.invitation.api.dto;

import lombok.Builder;
import lombok.Value;

import java.util.Collection;

@Value
@Builder
public class MyListInvitationsDto {
    Collection<ListInvitationDto> sent;
    Collection<ListInvitationDto> received;
}
