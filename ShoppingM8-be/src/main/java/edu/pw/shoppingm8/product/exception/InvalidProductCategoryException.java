package edu.pw.shoppingm8.product.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(code = HttpStatus.BAD_REQUEST)
public class InvalidProductCategoryException extends RuntimeException {
    public InvalidProductCategoryException() {
        super("Invalid product category");
    }
}