package edu.pw.shoppingm8.list.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.NOT_FOUND)
public class ListNotFoundException extends RuntimeException {
    public ListNotFoundException() {
        super("List not found");
    }
}
