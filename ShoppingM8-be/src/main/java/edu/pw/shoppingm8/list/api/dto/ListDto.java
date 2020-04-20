package edu.pw.shoppingm8.list.api.dto;

import edu.pw.shoppingm8.list.List;
import edu.pw.shoppingm8.user.api.dto.UserDto;
import lombok.Value;

@Value
public class ListDto {
    Long id;
    String name;
    UserDto owner;

    public static ListDto of(List list) {
        return new ListDto(list.getId(), list.getName(), UserDto.of(list.getOwner()));
    }
}