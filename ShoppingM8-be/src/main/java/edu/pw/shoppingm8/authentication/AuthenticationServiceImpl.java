package edu.pw.shoppingm8.authentication;

import edu.pw.shoppingm8.authentication.api.dto.SocialMediaLoginDto;
import edu.pw.shoppingm8.authentication.db.RefreshToken;
import edu.pw.shoppingm8.authentication.db.RefreshTokenRepository;
import edu.pw.shoppingm8.authentication.exception.InvalidAuthenticationMethodException;
import edu.pw.shoppingm8.authentication.exception.InvalidCredentialsException;
import edu.pw.shoppingm8.authentication.exception.RefreshTokenIsNotValidException;
import edu.pw.shoppingm8.authentication.exception.RefreshTokenNotFoundException;
import edu.pw.shoppingm8.authentication.social.SocialMediaProfileDto;
import edu.pw.shoppingm8.authentication.social.SocialMediaService;
import edu.pw.shoppingm8.user.UserService;
import edu.pw.shoppingm8.user.exception.UserNotFoundException;
import edu.pw.shoppingm8.user.db.User;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.Optional;

@Service
@Transactional
class AuthenticationServiceImpl implements AuthenticationService {
    private static final int REFRESH_TOKEN_SIZE = 64;

    private final RefreshTokenRepository refreshTokenRepository;
    private final UserService userService;
    private final BCryptPasswordEncoder passwordEncoder;
    private final byte[] secretKey;
    private final SocialMediaService socialMediaServiceGoogle;
    private final SocialMediaService socialMediaServiceFacebook;

    AuthenticationServiceImpl(RefreshTokenRepository refreshTokenRepository,
                              UserService userService,
                              @Value("${shoppingM8.security.secretKey}") String secretKey,
                              @Qualifier(value="socialMediaServiceGoogleImpl") SocialMediaService socialMediaServiceGoogle,
                              @Qualifier(value="socialMediaServiceFacebookImpl") SocialMediaService socialMediaServiceFacebook) {
        this.refreshTokenRepository = refreshTokenRepository;
        this.userService = userService;
        this.secretKey = secretKey.getBytes(StandardCharsets.UTF_8);
        passwordEncoder = new BCryptPasswordEncoder();
        
        this.socialMediaServiceGoogle = socialMediaServiceGoogle;
        this.socialMediaServiceFacebook = socialMediaServiceFacebook;
    }

    @Override
    public User authenticate(String email, String password) {
        final User user = userService.getUserByEmail(email);
        if (user.getPassword() == null)
            throw new InvalidAuthenticationMethodException();
        final boolean passwordMatches = passwordEncoder.matches(password, user.getPassword());
        if (passwordMatches) {
            return user;
        } else {
            throw new InvalidCredentialsException();
        }
    }

    @Override
    public User authenticateFromRefreshToken(String token) {
        RefreshToken refreshToken = refreshTokenRepository.findByToken(token)
                .orElseThrow(RefreshTokenNotFoundException::new);
        if (!refreshToken.isValid() || refreshToken.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new RefreshTokenIsNotValidException();
        }
        return refreshToken.getUser();
    }

    @Override
    public void invalidateRefreshToken(String token) {
        RefreshToken refreshToken = refreshTokenRepository.findByToken(token)
                .orElseThrow(RefreshTokenNotFoundException::new);
        refreshToken.setValid(false);
        refreshTokenRepository.save(refreshToken);
    }

    @Override
    public String getAccessToken(User user) {
        LocalDateTime expiresAt = LocalDateTime.now().plus(AuthTokenType.ACCESS_TOKEN.getValidityPeriod());
        return Jwts.builder()
                .setSubject(user.getUsername())
                .setIssuedAt(new Date())
                .setExpiration(Date.from(expiresAt.atZone(ZoneId.systemDefault()).toInstant()))
                .signWith(SignatureAlgorithm.HS512, secretKey)
                .compact();
    }

    @Override
    public String getRefreshToken(User user) {
        LocalDateTime expiresAt = LocalDateTime.now().plus(AuthTokenType.REFRESH_TOKEN.getValidityPeriod());
        String token = RandomStringUtils.randomAlphanumeric(REFRESH_TOKEN_SIZE);
        RefreshToken refreshToken = RefreshToken.builder()
                .token(token)
                .expiresAt(expiresAt)
                .user(user)
                .build();
        refreshTokenRepository.save(refreshToken);

        return token;
    }

    @Override
    public User getAuthenticatedUser() {
        final String username = Optional.ofNullable(SecurityContextHolder.getContext().getAuthentication())
                .map(Principal::getName)
                .orElseThrow(IllegalStateException::new);
        return Optional.ofNullable(userService.getUserByEmail(username))
                .orElseThrow(IllegalStateException::new);
    }

    @Override
    public User authenticateWithGoogle(SocialMediaLoginDto socialMediaLoginDto) {
        return authenticateWithSocialMedia(socialMediaLoginDto, this.socialMediaServiceGoogle);
    }
    
    @Override
    public User authenticateWithFacebook(SocialMediaLoginDto socialMediaLoginDto) {
        return authenticateWithSocialMedia(socialMediaLoginDto, this.socialMediaServiceFacebook);
    }

    private User authenticateWithSocialMedia(SocialMediaLoginDto socialMediaLoginDto, SocialMediaService socialMediaService) {
        SocialMediaProfileDto socialMediaProfile = socialMediaService.getProfile(socialMediaLoginDto);

        return userService
                .getUserOptionalByEmail(socialMediaProfile.getEmail())
                .orElseGet(() -> {
                    byte[] picture = socialMediaService.getPicture(socialMediaProfile);
                    return userService.register(socialMediaProfile, picture);
                });
    }
}
