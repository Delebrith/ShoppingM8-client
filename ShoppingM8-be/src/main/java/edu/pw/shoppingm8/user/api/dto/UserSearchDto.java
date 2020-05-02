package edu.pw.shoppingm8.user.api.dto;

import edu.pw.shoppingm8.base.api.model.SearchDto;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class UserSearchDto extends SearchDto {
    private String name;
}
