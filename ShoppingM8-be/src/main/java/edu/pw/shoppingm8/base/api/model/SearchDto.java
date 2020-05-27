package edu.pw.shoppingm8.base.api.model;

import lombok.Data;

import javax.validation.constraints.Min;

@Data
public class SearchDto {
    @Min(0)
    protected int pageNo = 0;
    @Min(1)
    protected int pageSize = 20;
}
