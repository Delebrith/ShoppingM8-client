package edu.pw.shoppingm8.list.invitation.event;

import edu.pw.shoppingm8.list.invitation.db.ListInvitation;
import lombok.Value;

@Value
public class InvitationCreatedEvent {
    ListInvitation listInvitation;
}
