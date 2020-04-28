package edu.pw.shoppingm8.product.api.dto;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.validation.constraints.NotNull;

import edu.pw.shoppingm8.product.Product;
import edu.pw.shoppingm8.product.ProductCategory;
import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class ProductResponseDto {
    @NotNull
    Long id;
    @NotNull
    String name;
    @NotNull
    String unit;
    @NotNull
    @Enumerated(EnumType.STRING)
    ProductCategory category;
    @NotNull
    Double requiredAmount;
    @NotNull
    Double purchasedAmount;

    public static ProductResponseDto of(Product product) {
        return builder()
            .id(product.getId())
            .name(product.getName())
            .unit(product.getUnit())
            .category(product.getCategory())
            .requiredAmount(product.getRequiredAmount())
            .purchasedAmount(product.getPurchasedAmount())
            .build();
    }
}