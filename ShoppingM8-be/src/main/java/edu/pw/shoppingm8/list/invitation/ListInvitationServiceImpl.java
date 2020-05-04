package edu.pw.shoppingm8.list.invitation;

import edu.pw.shoppingm8.authentication.AuthenticationService;
import edu.pw.shoppingm8.list.List;
import edu.pw.shoppingm8.list.ListService;
import edu.pw.shoppingm8.list.invitation.db.ListInvitation;
import edu.pw.shoppingm8.list.invitation.db.ListInvitationRepository;
import edu.pw.shoppingm8.list.invitation.exception.ForbiddenListInvitationOperationException;
import edu.pw.shoppingm8.list.invitation.exception.ListInvitationNotFoundException;
import edu.pw.shoppingm8.list.invitation.exception.UserIsAlreadyAMemberException;
import edu.pw.shoppingm8.list.invitation.exception.UserIsAlreadyInvitedException;
import edu.pw.shoppingm8.user.db.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;

@Service
@RequiredArgsConstructor
@Transactional
public class ListInvitationServiceImpl implements ListInvitationService {
    private final ListInvitationRepository listInvitationRepository;
    private final AuthenticationService authenticationService;
    private final ListService listService;

    @Override
    public ListInvitation getInvitation(Long id) {
        return listInvitationRepository.findById(id)
                .orElseThrow(ListInvitationNotFoundException::new);
    }

    @Override
    public Collection<ListInvitation> getInvitationsByList(List list) {
        return listInvitationRepository.findByList(list);
    }

    @Override
    public Collection<ListInvitation> getInvitationsByInvited(User invited) {
        return listInvitationRepository.findByInvited(invited);
    }

    @Override
    public Collection<ListInvitation> getInvitationsByInviting(User inviting) {
        return listInvitationRepository.findByInviting(inviting);
    }

    @Override
    public ListInvitation createInvitation(List list, User invited) {
        if (list.getMembers().contains(invited) || list.getOwner().equals(invited)) {
            throw new UserIsAlreadyAMemberException();
        }
        if (listInvitationRepository.existsByListAndInvited(list, invited)) {
            throw new UserIsAlreadyInvitedException();
        }
        ListInvitation invitation = ListInvitation.builder()
                .invited(invited)
                .inviting(authenticationService.getAuthenticatedUser())
                .list(list)
                .build();
        return listInvitationRepository.save(invitation);
    }

    @Override
    public void acceptInvitation(ListInvitation invitation) {
        if (invitation.getInvited() != authenticationService.getAuthenticatedUser()) {
            throw new ForbiddenListInvitationOperationException();
        }
        List list = invitation.getList();
        listService.addMemberToList(list, invitation.getInvited());
        listInvitationRepository.delete(invitation);
    }

    @Override
    public void rejectInvitation(ListInvitation invitation) {
        if (invitation.getInvited() != authenticationService.getAuthenticatedUser()) {
            throw new ForbiddenListInvitationOperationException();
        }
        listInvitationRepository.delete(invitation);
    }

    @Override
    public void withdrawInvitation(ListInvitation invitation) {
        if (invitation.getInviting() != authenticationService.getAuthenticatedUser()) {
            throw new ForbiddenListInvitationOperationException();
        }
        listInvitationRepository.delete(invitation);
    }
}
