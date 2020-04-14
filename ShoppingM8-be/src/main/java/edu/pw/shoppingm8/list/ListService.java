package edu.pw.shoppingm8.list;

import edu.pw.shoppingm8.list.api.dto.ListDto;

public interface ListService {
    List create(ListDto listDto);

    List update(List list, ListDto patch);

    List getList(Long id);

    void delete(List list);
}
