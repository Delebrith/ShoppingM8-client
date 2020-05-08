package edu.pw.shoppingm8.product;

import edu.pw.shoppingm8.list.List;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;
import java.util.Optional;

public interface ProductRepository extends JpaRepository<Product, Long>{
    Collection<Product> findByList(List list);

    Optional<Product> findByIdAndList(Long productId, List list);

    void deleteByList(List list);
}