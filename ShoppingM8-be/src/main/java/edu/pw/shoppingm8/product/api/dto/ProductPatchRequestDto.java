package edu.pw.shoppingm8.product.api.dto;

import lombok.Value;

@Value
public class ProductPatchRequestDto {
    String name;
    String unit;
    String category;
    Double requiredAmount;

}