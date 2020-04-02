package edu.pw.shoppingm8.user;

import edu.pw.shoppingm8.user.api.dto.UserRegistrationDto;

public interface UserService {
    User login(String email, String password);

    User register(UserRegistrationDto registrationDto, byte[] profilePicture);

    String getUsersToken(User user);

    User getAuthenticatedUser();

    User getUser(Long id);

    void deregister(User user);
}
