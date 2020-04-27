package edu.pw.shoppingm8.list;

import org.springframework.stereotype.Service;

import edu.pw.shoppingm8.authentication.AuthenticationService;
import edu.pw.shoppingm8.list.api.dto.ListDto;
import edu.pw.shoppingm8.list.api.dto.ListModificationDto;
import edu.pw.shoppingm8.list.exception.ForbiddenListOperationException;
import edu.pw.shoppingm8.list.exception.ListNotFoundException;
import edu.pw.shoppingm8.user.User;
import edu.pw.shoppingm8.user.UserService;
import lombok.AllArgsConstructor;

import java.util.Collection;

@AllArgsConstructor
@Service
public class ListServiceImpl implements ListService {
    private final ListRepository listRepository;
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
        if (list.getOwner().getId().equals(authenticatedUser.getId())) 
            // TODO replace with check if user is a member
            throw new ForbiddenListOperationException();
    }
    
    @Override
    public void checkIfUserIsOwner(List list) {
        User authenticatedUser = authenticationService.getAuthenticatedUser();
        if (list.getOwner().getId().equals(authenticatedUser.getId()))
            throw new ForbiddenListOperationException();
        
    }

    @Override
    public Collection<List> getUsersLists(User user) {
        return listRepository.findByOwner(user);
    }
}