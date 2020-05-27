package edu.pw.shoppingm8.product;

import javax.transaction.Transactional;

import edu.pw.shoppingm8.list.List;
import org.springframework.stereotype.Service;

import edu.pw.shoppingm8.product.api.dto.ProductCreateRequestDto;
import edu.pw.shoppingm8.product.api.dto.ProductPatchRequestDto;
import edu.pw.shoppingm8.product.exception.ProductNotFoundException;
import lombok.AllArgsConstructor;

import java.util.Collection;

@Service
@AllArgsConstructor
public class ProductServiceImpl implements ProductService {
    private final ProductRepository productRepository;

    @Override
    public Collection<Product> getProductsByList(List list) {
        return productRepository.findByList(list);
    }

    @Override
    public Product getProduct(List list, Long productId) {
        return productRepository.findByIdAndList(productId, list)
                .orElseThrow(ProductNotFoundException::new);
    }

    @Transactional
    @Override
    public void purchaseProduct(List list, Long productId, Double amountChange) {
        Product product = getProduct(list, productId);
        product.setPurchasedAmount(product.getPurchasedAmount() + amountChange);
        productRepository.save(product);
    }

    @Override
    public Product createProduct(List list, ProductCreateRequestDto productDto) {
        Product product = Product.builder()
            .list(list)
            .name(productDto.getName())
            .unit(productDto.getUnit())
            .requiredAmount(productDto.getRequiredAmount())
            .category(productDto.getCategory())
            .build();
        productRepository.save(product);

        return product;
    }

    @Override
    @Transactional
    public Product updateProduct(List list, Long productId, ProductPatchRequestDto productDto) {
        Product product = getProduct(list, productId);
        if (productDto.getName() != null)
            product.setName(productDto.getName());
        if (productDto.getRequiredAmount() != null)
            product.setRequiredAmount(productDto.getRequiredAmount());
        if (productDto.getCategory() != null)
            product.setCategory(productDto.getCategory());
        if (productDto.getUnit() != null)
            product.setUnit(productDto.getUnit());

        return productRepository.save(product);
    }

    @Override
    public void deleteProduct(List list, Long productId) {
        productRepository.delete(getProduct(list, productId));
    }
    
}