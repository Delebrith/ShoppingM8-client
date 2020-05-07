package edu.pw.shoppingm8.product;

import javax.persistence.*;

import edu.pw.shoppingm8.list.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.Builder.Default;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Product {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @ManyToOne
    @JoinColumn(name = "list_id", nullable = false, foreignKey = @ForeignKey(name = "PRODUCT_FK1"))
    @OnDelete(action = OnDeleteAction.CASCADE)
    private List list;

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