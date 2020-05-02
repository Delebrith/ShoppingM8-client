package edu.pw.shoppingm8.user.api.dto;

import edu.pw.shoppingm8.user.db.User;
import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class UserDto {
    private static final String USER_PICTURE_URL_TEMPLATE = "/user/%d/picture";

    Long id;
    String name;
    String profilePicture;

    public static UserDto of(User user) {
        return UserDto.builder()
                .id(user.getId())
                .name(user.getName())
                .profilePicture(user.getProfilePicture() == null ? null : buildProfilePictureUrl(user.getId()))
                .build();
    }

    private static String buildProfilePictureUrl(Long id) {
        return String.format(USER_PICTURE_URL_TEMPLATE, id);
    }
}
