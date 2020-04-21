package edu.pw.shoppingm8.authentication.api.dto;

import javax.validation.constraints.NotEmpty;

import lombok.Value;

@Value
public class UserRegistrationDto {
    String email;
    String name;
    @NotEmpty
    String password;
}
