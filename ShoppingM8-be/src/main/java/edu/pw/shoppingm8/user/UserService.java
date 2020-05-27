package edu.pw.shoppingm8.user;

import edu.pw.shoppingm8.authentication.api.dto.UserRegistrationDto;
import edu.pw.shoppingm8.authentication.social.SocialMediaProfileDto;
import edu.pw.shoppingm8.user.api.dto.UserSearchDto;
import edu.pw.shoppingm8.user.db.User;
import org.springframework.data.domain.Page;

import java.util.Optional;

public interface UserService {
    User register(UserRegistrationDto registrationDto, byte[] profilePicture);
    
    User register(SocialMediaProfileDto socialMediaProfile, byte[] profilePicture);

    User getUser(Long id);

    User getUserByEmail(String username);

    Optional<User> getUserOptionalByEmail(String email);

    void deregister(User user);

    Page<User> getUsers(UserSearchDto searchDto);

    void updateFmcToken(User user, String token);
}
