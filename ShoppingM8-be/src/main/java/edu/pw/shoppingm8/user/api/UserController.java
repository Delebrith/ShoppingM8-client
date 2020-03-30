package edu.pw.shoppingm8.user.api;

import edu.pw.shoppingm8.user.User;
import edu.pw.shoppingm8.user.UserService;
import edu.pw.shoppingm8.user.api.dto.AuthTokenDto;
import edu.pw.shoppingm8.user.api.dto.CredentialsDto;
import edu.pw.shoppingm8.user.api.dto.UserDto;
import edu.pw.shoppingm8.user.api.dto.UserRegistrationDto;
import io.swagger.annotations.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.URI;
import java.util.Optional;

@RestController
@RequestMapping("user")
@RequiredArgsConstructor
@Slf4j
public class UserController {
    private final UserService userService;

    @ApiOperation(value = "Request registration with user data", nickname = "register", notes = "")
    @ApiResponses(value = {
            @ApiResponse(code = 201, message = "If valid data were provided", response = AuthTokenDto.class),
            @ApiResponse(code = 400, message = "If invalid data was provided")})
    @PostMapping(consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    ResponseEntity<AuthTokenDto> register(@RequestPart(name = "data") UserRegistrationDto registrationDto,
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
        return ResponseEntity
                .created(URI.create("/user/" + registered.getId()))
                .body(new AuthTokenDto(userService.getUsersToken(registered)));
    }

    @ApiOperation(value = "Log in", nickname = "login", notes = "")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If valid credentials were provided", response = AuthTokenDto.class),
            @ApiResponse(code = 400, message = "If invalid data was provided")})
    @PostMapping("login")
    ResponseEntity<AuthTokenDto> login(@RequestBody CredentialsDto registrationDto) {
        User authenticated = userService.login(registrationDto.getEmail(), registrationDto.getPassword());
        return ResponseEntity.ok(new AuthTokenDto(userService.getUsersToken(authenticated)));
    }

    @ApiOperation(value = "Get user info", nickname = "get user info", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If valid credentials were provided", response = UserDto.class),
            @ApiResponse(code = 400, message = "If invalid data was provided")})
    @GetMapping("me")
    ResponseEntity<UserDto> getAuthenticatedUser() {
        return ResponseEntity.ok(UserDto.of(userService.getAuthenticatedUser()));
    }

    @ApiOperation(value = "Get user info", nickname = "get user info", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If valid credentials were provided", response = InputStreamResource.class),
            @ApiResponse(code = 400, message = "If invalid data was provided")})
    @GetMapping("/{id}/picture")
    ResponseEntity<InputStreamResource> getProfilePicture(@PathVariable Long id) {
        User user = userService.getUser(id);
        return ResponseEntity.ok(new InputStreamResource(new ByteArrayInputStream(user.getProfilePicture())));
    }
}
