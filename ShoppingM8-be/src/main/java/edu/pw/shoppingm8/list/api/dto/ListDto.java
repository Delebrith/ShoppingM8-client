package edu.pw.shoppingm8.list.api.dto;

import edu.pw.shoppingm8.list.List;
import lombok.Value;

@Value
public class ListDto {
    Long id;
    String name;
    Long ownerId;

    public static ListDto of(List list) {
        return new ListDto(list.getId(), list.getName(), list.getOwner().getId());
    }
}