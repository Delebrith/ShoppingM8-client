package edu.pw.shoppingm8.authentication.api.dto;

import edu.pw.shoppingm8.user.User;
import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class AuthenticatedUserDto {
    private static final String USER_PICTURE_URL_TEMPLATE = "/user/{id}/picture";

    Long id;
    String name;
    String email;
    String profilePicture;

    public static AuthenticatedUserDto of(User user) {
        return AuthenticatedUserDto.builder()
                .id(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .profilePicture(buildProfilePictureUrl(user.getId()))
                .build();
    }

    private static String buildProfilePictureUrl(Long id) {
        return String.format(USER_PICTURE_URL_TEMPLATE, id);
    }
}
