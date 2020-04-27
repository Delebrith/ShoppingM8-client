package edu.pw.shoppingm8.product;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import edu.pw.shoppingm8.list.ListService;
import edu.pw.shoppingm8.product.api.dto.ProductCreateRequestDto;
import edu.pw.shoppingm8.product.api.dto.ProductPatchRequestDto;
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
        return productRepository.findById(new ProductId(productId, listService.getList(listId)))
                .orElseThrow(ProductNotFoundException::new);
    }

    @Transactional
    @Override
    public void purchaseProduct(Long listId, Long productId, Double amountChange) {
        Product product = getProduct(listId, productId);
        product.setPurchasedAmount(product.getPurchasedAmount() + amountChange);
        productRepository.save(product);
    }

    @Override
    public Product createProduct(Long listId, ProductCreateRequestDto productDto) {
        edu.pw.shoppingm8.list.List list = listService.getList(listId);
        Product product = Product.builder()
            .list(list)
            .name(productDto.getName())
            .unit(productDto.getUnit())
            .requiredAmount(productDto.getRequiredAmount())
            .category(ProductCategory.fromString(productDto.getCategory()))
            .build();
        productRepository.save(product);

        return product;
    }

    @Override
    @Transactional
    public void patchProduct(Long listId, Long productId, ProductPatchRequestDto productDto) {
        Product product = getProduct(listId, productId);
        if (productDto.getName() != null)
            product.setName(productDto.getName());
        if (productDto.getRequiredAmount() != null)
            product.setRequiredAmount(productDto.getRequiredAmount());
        if (productDto.getCategory() != null)
            product.setCategory(ProductCategory.fromString(productDto.getCategory()));
        if (productDto.getUnit() != null)
            product.setUnit(productDto.getUnit());

        productRepository.save(product);
    }

    @Override
    public void deleteProduct(Long listId, Long productId) {
        productRepository.delete(getProduct(listId, productId));
    }
    
}