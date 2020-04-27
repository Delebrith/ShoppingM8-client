package edu.pw.shoppingm8.product;

import java.util.List;

import org.springframework.stereotype.Service;

import edu.pw.shoppingm8.list.ListService;
import edu.pw.shoppingm8.product.exception.ProductNotFoundException;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ProductServiceImpl implements ProductService {
    private final ProductRepository productRepository;
    private final ListService listService;

    @Override
    public List<Product> getProducts(Long listId) {
        return productRepository.findByList(listService.getList(listId));
    }

    @Override
    public Product getProduct(Long listId, Long productId) {
        return productRepository.findById(
            new ProductId(productId, listService.getList(listId)))
            .orElseThrow(ProductNotFoundException::new);
    }
    
}