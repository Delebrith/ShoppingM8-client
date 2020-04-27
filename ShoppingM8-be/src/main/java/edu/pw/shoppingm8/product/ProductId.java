package edu.pw.shoppingm8.product;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import edu.pw.shoppingm8.list.List;
import lombok.Value;

@Value
public class ProductId implements Serializable {
    @NotNull
    Long id;
    @NotNull
    List list;
}