package edu.pw.shoppingm8.product;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.IdClass;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.Builder.Default;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@IdClass(ProductId.class)
public class Product {
    @Id
    private Long id;

    @Column(nullable = false)
    private String name;

    @Id
    private Long listId;

    @Column(nullable = false)
    private String unit;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ProductCategory category;

    @Column(nullable = false)
    @Default
    private Double purchasedAmount = 0.0;

    @Column(nullable = false)
    private Double requiredAmount;
}