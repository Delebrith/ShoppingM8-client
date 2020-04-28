package edu.pw.shoppingm8.list;

import edu.pw.shoppingm8.list.api.dto.ListModificationDto;
import edu.pw.shoppingm8.user.User;

import java.util.Collection;

public interface ListService {
    List create(ListModificationDto listModificationDto);

    List update(List list, ListModificationDto listModificationDto);

    List getList(Long id);

    void delete(List list);

    void checkIfUserHasAccessTo(List list);

    void checkIfUserIsOwner(List list);

    Collection<List> getUsersLists(User user);

    void checkIfListExistsAndUserHasAccess(Long id);
}
