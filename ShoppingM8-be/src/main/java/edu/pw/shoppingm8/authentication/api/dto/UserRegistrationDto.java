package edu.pw.shoppingm8.authentication.api.dto;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Size;

import lombok.Value;

@Value
public class UserRegistrationDto {
    @NotEmpty
    @Email
    String email;

    @NotEmpty
    String name;

    @NotEmpty
    @Size(min = 8)
    String password;
}
