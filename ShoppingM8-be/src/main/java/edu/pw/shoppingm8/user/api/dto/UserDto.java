package edu.pw.shoppingm8.user.api.dto;

import edu.pw.shoppingm8.user.User;
import lombok.Value;

@Value
public class UserDto {
    private static final String USER_PICTURE_URL_TEMPLATE = "/user/%d/picture";

    Long id;
    String name;
    String profilePicture;

    public static UserDto of(User user) {
        return new UserDto(user.getId(), user.getName(), UserDto.buildProfilePictureUrl(user.getId()));
    }

    private static String buildProfilePictureUrl(Long id) {
        return String.format(USER_PICTURE_URL_TEMPLATE, id);
    }
}
