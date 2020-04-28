package edu.pw.shoppingm8.product.api.dto;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;

import edu.pw.shoppingm8.product.ProductCategory;
import lombok.Value;

@Value
public class ProductPatchRequestDto {
    String name;
    String unit;
    @Enumerated(EnumType.STRING)
    ProductCategory category;
    Double requiredAmount;

}