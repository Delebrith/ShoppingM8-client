package edu.pw.shoppingm8.authentication;

import edu.pw.shoppingm8.authentication.api.dto.SocialMediaLoginDto;
import edu.pw.shoppingm8.user.User;

public interface AuthenticationService {
    User authenticate(String email, String password);

    User authenticateFromRefreshToken(String refreshToken);

    void invalidateRefreshToken(String token);

    String getAccessToken(User user);

    String getRefreshToken(User user);

    User getAuthenticatedUser();

    User authenticateWithGoogle(SocialMediaLoginDto socialMediaLoginDto);

    User authenticateWithFacebook(SocialMediaLoginDto socialMediaLoginDto);
}
