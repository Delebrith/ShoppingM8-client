package edu.pw.shoppingm8.list;

import org.springframework.stereotype.Service;

import edu.pw.shoppingm8.authentication.AuthenticationService;
import edu.pw.shoppingm8.list.api.dto.ListDto;
import edu.pw.shoppingm8.list.exception.ListNotFoundException;
import edu.pw.shoppingm8.user.User;
import edu.pw.shoppingm8.user.UserService;

@Service
public class ListServiceImpl implements ListService {
    private final ListRepository listRepository;
    private final UserService userService;
    private final AuthenticationService authenticationService;

    public ListServiceImpl(ListRepository listRepository,
        UserService userService, AuthenticationService authenticationService) {
        this.listRepository = listRepository;
        this.userService = userService;
        this.authenticationService = authenticationService;
    }

    @Override
    public List create(ListDto listDto) {
        User owner = authenticationService.getAuthenticatedUser();
        List created = List.builder()
            .name(listDto.getName())
            .owner(owner).build();
        return listRepository.save(created);
    }

    @Override 
    public List update(List list, ListDto listDto) {
        if (listDto.getName() != null)
            list.setName(listDto.getName());
        if (listDto.getOwnerId() != null) {
            User owner = userService.getUser(listDto.getOwnerId());
            list.setOwner(owner);
        }
        return listRepository.save(list);
    }

    @Override
    public List getList(Long id) {
        return listRepository.findById(id).orElseThrow(ListNotFoundException::new);
    }

    @Override
    public void delete(List list) {
        listRepository.delete(list);
    }
}