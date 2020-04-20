package edu.pw.shoppingm8.authentication.social.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(code = HttpStatus.BAD_REQUEST)
public class FailedSocialMediaAuthenticationException extends RuntimeException {
    public FailedSocialMediaAuthenticationException() {
        super("Failed social media authentication.");
    }
}