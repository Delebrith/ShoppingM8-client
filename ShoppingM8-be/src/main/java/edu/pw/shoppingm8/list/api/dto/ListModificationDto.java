package edu.pw.shoppingm8.list.api.dto;

import edu.pw.shoppingm8.list.List;
import lombok.Value;

@Value
public class ListModificationDto {
    String name;

    public static ListModificationDto of(List list) {
        return new ListModificationDto(list.getName());
    }
}