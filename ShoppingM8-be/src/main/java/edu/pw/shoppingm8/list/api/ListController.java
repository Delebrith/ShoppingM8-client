package edu.pw.shoppingm8.list.api;

import edu.pw.shoppingm8.authentication.AuthenticationService;
import edu.pw.shoppingm8.list.List;
import edu.pw.shoppingm8.list.ListService;
import edu.pw.shoppingm8.list.api.dto.ListDto;
import edu.pw.shoppingm8.list.api.dto.ListModificationDto;
import edu.pw.shoppingm8.user.User;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.Authorization;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.net.URI;
import java.util.ArrayList;
import java.util.Collection;
import java.util.stream.Collectors;

@Validated
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
    @PostMapping
    ResponseEntity<ListDto> createList(@RequestBody @Valid ListModificationDto listModificationDto) {
        List created = listService.create(listModificationDto);
        return ResponseEntity.created(URI.create("/list/" + created.getId()))
            .body(ListDto.of(created));
    }

    @ApiOperation(value = "Get all my lists", nickname = "get lists", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If list was updated", response = ListDto.class),
    })
    @GetMapping("my-lists")
    ResponseEntity<Collection<ListDto>> getMyList() {
        User user = authenticationService.getAuthenticatedUser();
        Collection<List> lists = listService.getUsersLists(user);
        return ResponseEntity.ok(lists.stream().map(ListDto::of).collect(Collectors.toCollection(ArrayList::new)));
    }

    @ApiOperation(value = "Get list", nickname = "get list", notes = "",
        authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If list was updated", response = ListDto.class),
        @ApiResponse(code = 403, message = "If user has no access to this list"),
        @ApiResponse(code = 404, message = "If list does not exist"),
    })
    @GetMapping("{id}")
    ResponseEntity<ListDto> getList(@PathVariable Long id) {
        List list = listService.getList(id);
        listService.checkIfUserHasAccessTo(list);
        return ResponseEntity.ok(ListDto.of(list));
    }

    @ApiOperation(value = "Update list", nickname = "update list", notes = "", authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If list was updated"),
        @ApiResponse(code = 400, message = "If invalid data was provided"),
        @ApiResponse(code = 403, message = "If current user is not owner"),
        @ApiResponse(code = 404, message = "If list does not exist"),
    })
    @PatchMapping("{id}")
    ResponseEntity<Void> updateList(@PathVariable Long id,
                                    @RequestBody @Valid ListModificationDto listModificationDto) {
        List list = listService.getList(id);
        listService.update(list, listModificationDto);
        return ResponseEntity.ok().build();
    }
    
    @ApiOperation(value = "Delete list", nickname = "delete list", notes = "",
        authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If list was deleted"),
        @ApiResponse(code = 403, message = "If user is not owner this list"),
        @ApiResponse(code = 404, message = "If list does not exist"),
    })
    @DeleteMapping("{id}")
    ResponseEntity<ListDto> deleteList(@PathVariable Long id) {
        List list = listService.getList(id);
        listService.delete(list);
        return ResponseEntity.ok().build();
    }
}