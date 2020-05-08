package edu.pw.shoppingm8.user.api;

import edu.pw.shoppingm8.user.db.User;
import edu.pw.shoppingm8.user.UserService;
import edu.pw.shoppingm8.user.api.dto.UserDto;
import edu.pw.shoppingm8.user.api.dto.UserSearchDto;
import io.swagger.annotations.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayInputStream;
import java.util.Collection;
import java.util.stream.Collectors;

@RestController
@RequestMapping("user")
@RequiredArgsConstructor
@Slf4j
public class UserController {
    private final UserService userService;

    @ApiOperation(value = "Get user info", nickname = "get user info", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If valid credentials were provided", response = InputStreamResource.class),
            @ApiResponse(code = 400, message = "If invalid data was provided")})
    @GetMapping
    ResponseEntity<Iterable<UserDto>> getUsers(UserSearchDto searchDto) {
        Iterable<UserDto> userDtos = userService.getUsers(searchDto).map(UserDto::of);
        return ResponseEntity.ok(userDtos);
    }


    @ApiOperation(value = "Get user info", nickname = "get user info", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If valid credentials were provided", response = InputStreamResource.class),
            @ApiResponse(code = 400, message = "If invalid data was provided")})
    @GetMapping("/{id}/picture")
    ResponseEntity<InputStreamResource> getProfilePicture(@PathVariable Long id) {
        User user = userService.getUser(id);
        return ResponseEntity.ok()
                .contentType(MediaType.IMAGE_JPEG)
                .body(new InputStreamResource(new ByteArrayInputStream(user.getProfilePicture())));
    }
}
