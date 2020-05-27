package edu.pw.shoppingm8.list.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.FORBIDDEN)
public class ForbiddenListOperationException extends RuntimeException {
    public ForbiddenListOperationException() {
        super("User not allowed to perform this operation");
    }
}
