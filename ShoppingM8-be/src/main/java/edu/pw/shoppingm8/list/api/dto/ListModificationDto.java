package edu.pw.shoppingm8.list.api.dto;

import edu.pw.shoppingm8.list.List;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Value;

import javax.validation.constraints.NotEmpty;

@Value
@NoArgsConstructor(force = true, access = AccessLevel.PRIVATE)
@AllArgsConstructor
public class ListModificationDto {
    @NotEmpty
    String name;

    public static ListModificationDto of(List list) {
        return new ListModificationDto(list.getName());
    }
}