package edu.pw.shoppingm8.list.invitation.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class ListInvitationNotFoundException extends RuntimeException {
    public ListInvitationNotFoundException() {
        super("List invitation not found");
    }
}
