package edu.pw.shoppingm8.product.api.dto;

import javax.validation.constraints.NotNull;

import lombok.Value;

@Value
public class ProductCreateRequestDto {
    @NotNull
    String name;
    @NotNull
    String unit;
    @NotNull
    String category;
    @NotNull
    Double requiredAmount;

}