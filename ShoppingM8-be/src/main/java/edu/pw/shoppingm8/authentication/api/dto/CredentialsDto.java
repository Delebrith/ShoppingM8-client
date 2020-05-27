package edu.pw.shoppingm8.authentication.api.dto;

import lombok.Value;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Size;

@Value
public class CredentialsDto {
    @NotEmpty
    @Email
    String email;

    @NotEmpty
    @Size(min = 8)
    String password;
}
