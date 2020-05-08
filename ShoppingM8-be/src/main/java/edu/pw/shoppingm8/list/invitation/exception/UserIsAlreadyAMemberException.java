package edu.pw.shoppingm8.list.invitation.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.CONFLICT)
public class UserIsAlreadyAMemberException extends RuntimeException {
    public UserIsAlreadyAMemberException() {
        super("Cannot send invitation. User already is a member of given list");
    }
}
