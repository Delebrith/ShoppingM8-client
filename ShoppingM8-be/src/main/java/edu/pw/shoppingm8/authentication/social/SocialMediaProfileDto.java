package edu.pw.shoppingm8.authentication.social;

import lombok.Value;

@Value
public class SocialMediaProfileDto {
    String email;
    String name;
    String pictureUrl;
}