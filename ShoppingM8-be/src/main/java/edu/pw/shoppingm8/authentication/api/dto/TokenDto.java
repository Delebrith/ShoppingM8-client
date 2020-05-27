package edu.pw.shoppingm8.authentication.api.dto;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class TokenDto {
    @Builder.Default
    String tokenType = "Bearer";

    String accessToken;
    String refreshToken;
}
