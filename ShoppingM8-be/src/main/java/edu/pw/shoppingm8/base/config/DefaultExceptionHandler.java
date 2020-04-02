package edu.pw.shoppingm8.base.config;

import edu.pw.shoppingm8.base.api.model.ErrorDto;
import edu.pw.shoppingm8.user.exception.InvalidCredentialsException;
import edu.pw.shoppingm8.user.exception.UserNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import javax.servlet.http.HttpServletRequest;

@ControllerAdvice
public class DefaultExceptionHandler {

    @ResponseStatus(HttpStatus.NOT_FOUND)
    @ExceptionHandler({UserNotFoundException.class, UsernameNotFoundException.class})
    @ResponseBody
    ErrorDto handleResourceNotFound(final HttpServletRequest req, final Exception ex) {
        return ErrorDto.builder()
                .code(HttpStatus.NOT_FOUND.value())
                .message(ex.getMessage())
                .uri(req.getRequestURI())
                .build();
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler({InvalidCredentialsException.class})
    @ResponseBody
    ErrorDto handleBadRequest(final HttpServletRequest req, final Exception ex) {
        return ErrorDto.builder()
                .code(HttpStatus.BAD_REQUEST.value())
                .message(ex.getMessage())
                .uri(req.getRequestURI())
                .build();
    }
}
