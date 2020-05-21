package edu.pw.shoppingm8.base.push;

import lombok.Builder;
import lombok.Value;

import java.util.Collections;
import java.util.Map;

@Value
@Builder
public class PushNotificationDto {
    String title;
    String message;

    @Builder.Default
    Map<String, String> data = Collections.emptyMap();
}
