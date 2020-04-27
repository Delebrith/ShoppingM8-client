package edu.pw.shoppingm8.product;

import java.util.List;

public interface ProductService {
    List<Product> getProducts(Long listId);

    Product getProduct(Long listId, Long productId);
}