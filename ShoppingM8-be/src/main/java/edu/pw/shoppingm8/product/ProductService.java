package edu.pw.shoppingm8.product;

import edu.pw.shoppingm8.list.List;
import edu.pw.shoppingm8.product.api.dto.ProductCreateRequestDto;
import edu.pw.shoppingm8.product.api.dto.ProductPatchRequestDto;

import java.util.Collection;

public interface ProductService {
    Collection<Product> getProductsByList(List list);

    Product getProduct(List list, Long productId);

    void purchaseProduct(List list, Long productId, Double amountChange);

    Product createProduct(List list, ProductCreateRequestDto productDto);

    Product updateProduct(List list, Long productId, ProductPatchRequestDto productDto);

    void deleteProduct(List list, Long productId);
}