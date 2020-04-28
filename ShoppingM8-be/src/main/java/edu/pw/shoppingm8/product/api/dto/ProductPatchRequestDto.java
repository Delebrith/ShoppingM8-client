package edu.pw.shoppingm8.product.api.dto;

import edu.pw.shoppingm8.product.ProductCategory;
import lombok.Value;

@Value
public class ProductPatchRequestDto {
    String name;
    String unit;
    ProductCategory category;
    Double requiredAmount;

}