package edu.pw.shoppingm8.list.api;

import java.net.URI;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import edu.pw.shoppingm8.authentication.AuthenticationService;
import edu.pw.shoppingm8.list.List;
import edu.pw.shoppingm8.list.ListService;
import edu.pw.shoppingm8.list.api.dto.ListDto;
import edu.pw.shoppingm8.user.User;
import io.swagger.annotations.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@RestController
@RequestMapping("list")
@RequiredArgsConstructor
@Slf4j
public class ListController {
    private final ListService listService;
    private final AuthenticationService authenticationService;

    @ApiOperation(value = "Create list", nickname = "create list", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 201, message = "If list was created", response = ListDto.class),
        @ApiResponse(code = 400, message = "If request has list id or owner id set")})
    @PostMapping(value="/new")
    ResponseEntity<ListDto> createList(@RequestBody ListDto listDto) {
        if (listDto.getId() != null || listDto.getOwnerId() != null)
            return ResponseEntity.badRequest().build();

        List created = listService.create(listDto);
        return ResponseEntity.created(URI.create("/list/" + created.getId()))
            .body(ListDto.of(created));
    }

    @ApiOperation(value = "Get list", nickname = "get list", notes = "",
        authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If list was updated", response = ListDto.class),
        @ApiResponse(code = 403, message = "If user has no access to this list"),
        @ApiResponse(code = 404, message = "If list does not exist"),
    })
    @GetMapping(value="/{id}")
    ResponseEntity<ListDto> getList(@PathVariable Long id) {
        User authenticatedUser = authenticationService.getAuthenticatedUser();

        List list = listService.getList(id);
        if (!authenticatedUser.getId().equals(list.getOwner().getId()))
            // TODO in future allow access for non-owner members of the list
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        
        return ResponseEntity.ok(ListDto.of(list));
    }

    @ApiOperation(value = "Update list", nickname = "update list", notes = "", authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If list was updated"),
        @ApiResponse(code = 400, message = "If invalid data was provided"),
        @ApiResponse(code = 403, message = "If current user is not owner"),
        @ApiResponse(code = 404, message = "If list does not exist"),
    })
    @PatchMapping(value="/{id}")
    ResponseEntity<Void> updateList(@PathVariable Long id, @RequestBody ListDto listDto) {
        User authenticatedUser = authenticationService.getAuthenticatedUser();
        
        if (listDto.getId() != null)
            return ResponseEntity.badRequest().build();

        List list = listService.getList(id);

        if (!authenticatedUser.getId().equals(list.getOwner().getId()))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        
        listService.update(list, listDto);

        return ResponseEntity.ok().build();
    }
    
    @ApiOperation(value = "Delete list", nickname = "delete list", notes = "",
        authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If list was deleted"),
        @ApiResponse(code = 403, message = "If user is not owner this list"),
        @ApiResponse(code = 404, message = "If list does not exist"),
    })
    @DeleteMapping(value="/{id}")
    ResponseEntity<ListDto> deleteList(@PathVariable Long id) {
        User authenticatedUser = authenticationService.getAuthenticatedUser();

        List list = listService.getList(id);
        if (!authenticatedUser.getId().equals(list.getOwner().getId()))
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        listService.delete(list);
        return ResponseEntity.ok().build();
    }
}