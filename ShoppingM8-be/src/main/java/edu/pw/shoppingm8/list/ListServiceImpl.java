package edu.pw.shoppingm8.list;

import edu.pw.shoppingm8.authentication.AuthenticationService;
import edu.pw.shoppingm8.list.api.dto.ListModificationDto;
import edu.pw.shoppingm8.list.exception.ForbiddenListOperationException;
import edu.pw.shoppingm8.list.exception.ListNotFoundException;
import edu.pw.shoppingm8.list.invitation.db.ListInvitationRepository;
import edu.pw.shoppingm8.product.ProductRepository;
import edu.pw.shoppingm8.user.db.User;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;

@AllArgsConstructor
@Service
@Transactional
public class ListServiceImpl implements ListService {
    private final ListRepository listRepository;
    private final ListInvitationRepository listInvitationRepository;
    private final ProductRepository productRepository;
    private final AuthenticationService authenticationService;

    @Override
    public List create(ListModificationDto listModificationDto) {
        User owner = authenticationService.getAuthenticatedUser();
        List created = List.builder()
            .name(listModificationDto.getName())
            .owner(owner).build();
        return listRepository.save(created);
    }

    @Override 
    public List update(List list, ListModificationDto listModificationDto) {
        checkIfUserIsOwner(list);

        if (listModificationDto.getName() != null)
            list.setName(listModificationDto.getName());
            
        return listRepository.save(list);
    }

    @Override
    public List getList(Long id) {
        return listRepository.findById(id).orElseThrow(ListNotFoundException::new);
    }

    @Override
    public void delete(List list) {
        checkIfUserIsOwner(list);
        listRepository.delete(list);
    }

	@Override
	public void checkIfUserHasAccessTo(List list) {
        User authenticatedUser = authenticationService.getAuthenticatedUser();
        if (!list.getOwner().equals(authenticatedUser) && !list.getMembers().contains(authenticatedUser))
            throw new ForbiddenListOperationException();
    }
    
    @Override
    public void checkIfUserIsOwner(List list) {
        User authenticatedUser = authenticationService.getAuthenticatedUser();
        if (!list.getOwner().getId().equals(authenticatedUser.getId()))
            throw new ForbiddenListOperationException();
        
    }

    @Override
    public Collection<List> getUsersLists(User user) {
        return listRepository.findUsersLists(user);
    }

    @Override
    public void checkIfListExistsAndUserHasAccess(Long listId) {
        checkIfUserHasAccessTo(getList(listId));
    }

    @Override
    public void addMemberToList(List list, User user) {
        list.getMembers().add(user);
        listRepository.save(list);
    }

    @Override
    public void leaveList(List list) {
        list.getMembers().remove(authenticationService.getAuthenticatedUser());
        listRepository.save(list);
    }
}