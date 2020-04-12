package edu.pw.shoppingm8.user.exception;

public class EmailAlreadyUsedException extends RuntimeException {
    public EmailAlreadyUsedException() {
        super("Given email already has an account");
    }
}
