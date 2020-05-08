package edu.pw.shoppingm8.list.invitation.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.FORBIDDEN)
public class ForbiddenListInvitationOperationException extends RuntimeException {
    public ForbiddenListInvitationOperationException() {
        super("User does not have authority to modify invitation this way");
    }
}
