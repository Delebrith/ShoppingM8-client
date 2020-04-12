package edu.pw.shoppingm8.user;

import edu.pw.shoppingm8.authentication.api.dto.UserRegistrationDto;

public interface UserService {
    User register(UserRegistrationDto registrationDto, byte[] profilePicture);

    User getUser(Long id);

    User getUserByEmail(String username);

    void deregister(User user);
}
