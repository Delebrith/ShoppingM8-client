package edu.pw.shoppingm8.list.api.dto;

import edu.pw.shoppingm8.list.List;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import lombok.Value;

@Value
@NoArgsConstructor(force = true, access = AccessLevel.PRIVATE)
public class ListModificationDto {
    String name;

    public static ListModificationDto of(List list) {
        return new ListModificationDto(list.getName());
    }
}