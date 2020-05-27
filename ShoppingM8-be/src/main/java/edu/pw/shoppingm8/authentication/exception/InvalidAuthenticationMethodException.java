package edu.pw.shoppingm8.authentication.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.BAD_REQUEST)
public class InvalidAuthenticationMethodException  extends RuntimeException {
    public InvalidAuthenticationMethodException() {
        super("Invalid authentication method");
    }
}