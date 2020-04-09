package edu.pw.shoppingm8.authentication.exception;

public class RefreshTokenNotFoundException extends RuntimeException {
    public RefreshTokenNotFoundException() {
        super("Refresh token not found");
    }
}
