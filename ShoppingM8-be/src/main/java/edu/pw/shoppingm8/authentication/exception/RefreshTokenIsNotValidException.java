package edu.pw.shoppingm8.authentication.exception;

public class RefreshTokenIsNotValidException extends RuntimeException {
    public RefreshTokenIsNotValidException() {
        super("Refresh token expired or invalidated. Authenticate again");
    }
}
