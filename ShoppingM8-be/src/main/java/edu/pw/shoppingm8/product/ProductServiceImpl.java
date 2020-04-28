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
        listService.checkIfListExistsAndUserHasAccess(listId);
        return productRepository.findByListId(listId);
    }

    @Override
    public Product getProduct(Long listId, Long productId) {
        listService.checkIfListExistsAndUserHasAccess(listId);
        return productRepository.findById(new ProductId(productId, listId))
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
        listService.checkIfListExistsAndUserHasAccess(listId);
        Product product = Product.builder()
            .listId(listId)
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
    public void updateProduct(Long listId, Long productId, ProductPatchRequestDto productDto) {
        Product product = getProduct(listId, productId);
        if (productDto.getName() != null)
            product.setName(productDto.getName());
        if (productDto.getRequiredAmount() != null)
            product.setRequiredAmount(productDto.getRequiredAmount());
        if (productDto.getCategory() != null)
            product.setCategory(productDto.getCategory());
        if (productDto.getUnit() != null)
            product.setUnit(productDto.getUnit());

        productRepository.save(product);
    }

    @Override
    public void deleteProduct(Long listId, Long productId) {
        productRepository.delete(getProduct(listId, productId));
    }
    
}