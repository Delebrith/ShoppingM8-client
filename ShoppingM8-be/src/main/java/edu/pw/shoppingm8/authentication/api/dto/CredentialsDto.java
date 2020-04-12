package edu.pw.shoppingm8.authentication.api.dto;

import lombok.Value;

@Value
public class CredentialsDto {
    String email;
    String password;
}
