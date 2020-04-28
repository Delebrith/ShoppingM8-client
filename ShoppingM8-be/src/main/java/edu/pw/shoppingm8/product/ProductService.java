package edu.pw.shoppingm8.product;

import java.util.List;

import edu.pw.shoppingm8.product.api.dto.ProductCreateRequestDto;
import edu.pw.shoppingm8.product.api.dto.ProductPatchRequestDto;

public interface ProductService {
    List<Product> getProducts(Long listId);

    Product getProduct(Long listId, Long productId);

    void purchaseProduct(Long listId, Long productId, Double amountChange);

    Product createProduct(Long listId, ProductCreateRequestDto productDto);

    void updateProduct(Long listId, Long productId, ProductPatchRequestDto productDto);

    void deleteProduct(Long listId, Long productId);
}