package edu.pw.shoppingm8.product;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, ProductId>{
    List<Product> findByList(edu.pw.shoppingm8.list.List list);
}