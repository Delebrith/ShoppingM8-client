package edu.pw.shoppingm8.list.api.dto;

import edu.pw.shoppingm8.list.List;
import edu.pw.shoppingm8.user.api.dto.UserDto;
import lombok.Builder;
import lombok.Value;

import java.util.Set;
import java.util.stream.Collectors;

@Value
@Builder
public class ListDto {
    Long id;
    String name;
    UserDto owner;
    Set<UserDto> members;

    public static ListDto of(List list) {
        return ListDto.builder()
                .id(list.getId())
                .name(list.getName())
                .owner(UserDto.of(list.getOwner()))
                .members(list.getMembers().stream()
                        .map(UserDto::of)
                        .collect(Collectors.toSet()))
                .build();
    }
}