package edu.pw.shoppingm8.user.api.dto;

import lombok.Value;

@Value
public class UserRegistrationDto {
    String email;
    String name;
    String password;
}
