package edu.pw.shoppingm8.authentication.api;

import edu.pw.shoppingm8.authentication.AuthenticationService;
import edu.pw.shoppingm8.authentication.api.dto.*;
import edu.pw.shoppingm8.user.db.User;
import edu.pw.shoppingm8.user.UserService;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.Authorization;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URI;
import java.util.Optional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import javax.validation.Valid;


@Validated
@RestController
@RequestMapping("auth")
@RequiredArgsConstructor
@Slf4j
public class AuthenticationController {
    private final AuthenticationService authenticationService;
    private final UserService userService;

    @ApiOperation(value = "Request registration with user data", nickname = "register", notes = "")
    @ApiResponses(value = {
            @ApiResponse(code = 201, message = "If valid data were provided", response = TokenDto.class),
            @ApiResponse(code = 400, message = "If invalid data was provided")})
    @PostMapping(value = "register", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    ResponseEntity<TokenDto> register(@RequestPart(name = "data") @Valid UserRegistrationDto registrationDto,
                                      @RequestPart(name = "picture", required = false) MultipartFile profilePicture) {
        byte[] picture = Optional.ofNullable(profilePicture)
                .map(multipartFile -> {
                    try {
                        return multipartFile.getBytes();
                    } catch (IOException e) {
                        log.error("Error reading profile picture file", e);
                        return null;
                    }
                })
                .orElse(new byte[0]);
        User registered = userService
                .register(registrationDto, picture);
        return ResponseEntity.created(URI.create("/user/" + registered.getId()))
                .body(TokenDto.builder()
                .accessToken(authenticationService.getAccessToken(registered))
                .refreshToken(authenticationService.getRefreshToken(registered))
                .build());
    }

    @ApiOperation(value = "Authenticate", nickname = "login", notes = "")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If valid credentials were provided", response = RefreshTokenDto.class),
            @ApiResponse(code = 400, message = "If invalid data was provided")})
    @PostMapping("login")
    ResponseEntity<TokenDto> authenticate(@RequestBody @Valid CredentialsDto credentialsDto) {
        User authenticated = authenticationService.authenticate(credentialsDto.getEmail(), credentialsDto.getPassword());
        return ResponseEntity.ok(TokenDto.builder()
                .accessToken(authenticationService.getAccessToken(authenticated))
                .refreshToken(authenticationService.getRefreshToken(authenticated))
                .build());
    }

    @ApiOperation(value = "Refresh token", nickname = "refresh", notes = "")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If valid credentials were provided", response = RefreshTokenDto.class),
            @ApiResponse(code = 400, message = "If invalid data was provided")})
    @PostMapping("refresh")
    ResponseEntity<TokenDto> refreshAuthentication(@RequestBody @Valid RefreshTokenDto refreshTokenDto) {
        User authenticated = authenticationService.authenticateFromRefreshToken(refreshTokenDto.getRefreshToken());
        authenticationService.invalidateRefreshToken(refreshTokenDto.getRefreshToken());
        return ResponseEntity.ok(TokenDto.builder()
                .accessToken(authenticationService.getAccessToken(authenticated))
                .refreshToken(authenticationService.getRefreshToken(authenticated))
                .build());
    }

    @ApiOperation(value = "Get authenticated user info", nickname = "get user info", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If valid credentials were provided", response = AuthenticatedUserDto.class),
            @ApiResponse(code = 400, message = "If invalid data was provided")})
    @GetMapping("me")
    ResponseEntity<AuthenticatedUserDto> getAuthenticatedUser() {
        return ResponseEntity.ok(AuthenticatedUserDto.of(authenticationService.getAuthenticatedUser()));
    }

    @ApiOperation(value = "Deregister", nickname = "delete user account", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If valid credentials were provided"),
            @ApiResponse(code = 400, message = "If invalid data was provided")})
    @DeleteMapping("me")
    ResponseEntity<Void> deregister() {
        userService.deregister(authenticationService.getAuthenticatedUser());
        return ResponseEntity.noContent().build();
    }

    @ApiOperation(value = "Login via facebook", nickname = "facebook login", notes = "")
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If valid data was provided", response = TokenDto.class),
        @ApiResponse(code = 400, message = "If invalid data was provided")})
    @PostMapping(value="login/facebook")
    ResponseEntity<TokenDto> facebookLogin(@RequestBody @Valid SocialMediaLoginDto socialMediaLoginDto) {
        User authenticated = authenticationService.authenticateWithFacebook(socialMediaLoginDto);
        return ResponseEntity.ok(TokenDto.builder()
                .accessToken(authenticationService.getAccessToken(authenticated))
                .refreshToken(authenticationService.getRefreshToken(authenticated))
                .build());
    }
    
    @ApiOperation(value = "Login via google", nickname = "google login", notes = "")
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If valid data was provided", response = TokenDto.class),
        @ApiResponse(code = 400, message = "If invalid data was provided")})
    @PostMapping(value="login/google")
    ResponseEntity<TokenDto> googleLogin(@RequestBody @Valid SocialMediaLoginDto socialMediaLoginDto) {
        User authenticated = authenticationService.authenticateWithGoogle(socialMediaLoginDto);
        return ResponseEntity.ok(TokenDto.builder()
                .accessToken(authenticationService.getAccessToken(authenticated))
                .refreshToken(authenticationService.getRefreshToken(authenticated))
                .build());
    }
    

}
