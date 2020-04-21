package edu.pw.shoppingm8.user;

import edu.pw.shoppingm8.authentication.api.dto.UserRegistrationDto;
import edu.pw.shoppingm8.authentication.social.SocialMediaProfileDto;

public interface UserService {
    User register(UserRegistrationDto registrationDto, byte[] profilePicture);
    
    User register(SocialMediaProfileDto socialMediaProfile, byte[] profilePicture);

    User getUser(Long id);

    User getUserByEmail(String username);

    void deregister(User user);
}
