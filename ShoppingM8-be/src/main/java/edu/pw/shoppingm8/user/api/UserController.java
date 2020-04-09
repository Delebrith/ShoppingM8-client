package edu.pw.shoppingm8.user.api;

import edu.pw.shoppingm8.user.User;
import edu.pw.shoppingm8.user.UserService;
import io.swagger.annotations.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayInputStream;

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
    @GetMapping("/{id}/picture")
    ResponseEntity<InputStreamResource> getProfilePicture(@PathVariable Long id) {
        User user = userService.getUser(id);
        return ResponseEntity.ok(new InputStreamResource(new ByteArrayInputStream(user.getProfilePicture())));
    }
}
