package edu.pw.shoppingm8.product.api.dto;

import javax.validation.constraints.NotNull;

import edu.pw.shoppingm8.product.Product;
import lombok.Value;

@Value
public class ProductResponseDto {
    @NotNull
    Long id;
    @NotNull
    String name;
    @NotNull
    String unit;
    @NotNull
    String category;
    @NotNull
    Double requiredAmount;
    @NotNull
    Double purchasedAmount;

    public static ProductResponseDto of(Product product) {
        return new ProductResponseDto(
            product.getId(),
            product.getName(),
            product.getUnit(),
            product.getCategory().name(),
            product.getRequiredAmount(),
            product.getPurchasedAmount());
    }
}