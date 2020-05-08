package edu.pw.shoppingm8.list.invitation.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.CONFLICT)
public class UserIsAlreadyInvitedException extends RuntimeException {
    public UserIsAlreadyInvitedException() {
        super("User already invited");
    }
}
