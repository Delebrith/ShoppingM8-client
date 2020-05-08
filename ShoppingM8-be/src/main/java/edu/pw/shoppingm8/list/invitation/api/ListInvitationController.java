package edu.pw.shoppingm8.list.invitation.api;

import edu.pw.shoppingm8.authentication.AuthenticationService;
import edu.pw.shoppingm8.list.api.dto.ListDto;
import edu.pw.shoppingm8.list.invitation.db.ListInvitation;
import edu.pw.shoppingm8.list.invitation.ListInvitationService;
import edu.pw.shoppingm8.list.invitation.api.dto.ListInvitationDto;
import edu.pw.shoppingm8.list.invitation.api.dto.MyListInvitationsDto;
import edu.pw.shoppingm8.user.db.User;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.Authorization;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.stream.Collectors;

@RestController
@RequestMapping("list-invitation")
@RequiredArgsConstructor
public class ListInvitationController {
    private final ListInvitationService listInvitationService;
    private final AuthenticationService authenticationService;

    @ApiOperation(value = "get list invitation", nickname = "get single invitation", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If list invitation was created", response = ListDto.class),
            @ApiResponse(code = 403, message = "If user has no access to this list"),
            @ApiResponse(code = 404, message = "If list does not exist"),
    })
    @GetMapping("{id}")
    ResponseEntity<ListInvitationDto> getListInvitation(@PathVariable Long id) {
        return ResponseEntity.ok(ListInvitationDto.of(listInvitationService.getInvitation(id)));
    }

    @ApiOperation(value = "get list invitation", nickname = "get single invitation", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If list invitation was created", response = ListDto.class),
            @ApiResponse(code = 403, message = "If user has no access to this list"),
            @ApiResponse(code = 404, message = "If list does not exist"),
    })
    @GetMapping("my-invitations")
    ResponseEntity<MyListInvitationsDto> getMyListInvitation() {
        User authenticated = authenticationService.getAuthenticatedUser();
        return ResponseEntity.ok(MyListInvitationsDto.builder()
                .sent(listInvitationService.getInvitationsByInviting(authenticated).stream()
                        .map(ListInvitationDto::of)
                        .collect(Collectors.toSet()))
                .received(listInvitationService.getInvitationsByInvited(authenticated).stream()
                        .map(ListInvitationDto::of)
                        .collect(Collectors.toSet()))
                .build());
    }

    @ApiOperation(value = "create list invitations", nickname = "invite to list", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If list invitation was created", response = ListDto.class),
            @ApiResponse(code = 403, message = "If user has no access to this list"),
            @ApiResponse(code = 404, message = "If list does not exist"),
    })
    @PostMapping("{id}")
    ResponseEntity<Void> acceptInvitation(@PathVariable Long id) {
        ListInvitation listInvitation = listInvitationService.getInvitation(id);
        listInvitationService.acceptInvitation(listInvitation);
        return ResponseEntity.noContent().build();
    }


    @ApiOperation(value = "create list invitations", nickname = "invite to list", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If list invitation was created", response = ListDto.class),
            @ApiResponse(code = 403, message = "If user has no access to this list"),
            @ApiResponse(code = 404, message = "If list does not exist"),
    })
    @DeleteMapping("{id}")
    ResponseEntity<Void> rejectInvitation(@PathVariable Long id) {
        ListInvitation listInvitation = listInvitationService.getInvitation(id);
        listInvitationService.rejectInvitation(listInvitation);
        return ResponseEntity.noContent().build();
    }


    @ApiOperation(value = "create list invitations", nickname = "invite to list", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If list invitation was created", response = ListDto.class),
            @ApiResponse(code = 403, message = "If user has no access to this list"),
            @ApiResponse(code = 404, message = "If list does not exist"),
    })
    @DeleteMapping("{id}/withdraw")
    ResponseEntity<Void> withdrawInvitation(@PathVariable Long id) {
        ListInvitation listInvitation = listInvitationService.getInvitation(id);
        listInvitationService.withdrawInvitation(listInvitation);
        return ResponseEntity.noContent().build();
    }
}
