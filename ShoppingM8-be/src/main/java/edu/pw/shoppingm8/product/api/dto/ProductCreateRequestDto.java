package edu.pw.shoppingm8.product.api.dto;

import javax.validation.constraints.NotNull;

import edu.pw.shoppingm8.product.ProductCategory;
import lombok.Value;

@Value
public class ProductCreateRequestDto {
    @NotNull
    String name;
    @NotNull
    String unit;
    @NotNull
    ProductCategory category;
    @NotNull
    Double requiredAmount;

}