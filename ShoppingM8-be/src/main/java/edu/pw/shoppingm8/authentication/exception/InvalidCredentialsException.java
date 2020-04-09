package edu.pw.shoppingm8.authentication.exception;

public class InvalidCredentialsException extends RuntimeException {
    public InvalidCredentialsException() {
        super("Invalid username or password");
    }
}
