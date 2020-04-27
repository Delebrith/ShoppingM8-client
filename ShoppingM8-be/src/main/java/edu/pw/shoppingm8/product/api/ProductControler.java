package edu.pw.shoppingm8.product.api;

import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import edu.pw.shoppingm8.product.ProductService;
import edu.pw.shoppingm8.product.api.dto.ProductResponseDto;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.Authorization;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("list/{listId}/product")
@RequiredArgsConstructor
@Slf4j
public class ProductControler {
    private ProductService productService;
    
    @ApiOperation(value = "Get list products", nickname = "get list products", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If valid list id was provided", response = Iterable.class)})
        @ApiResponse(code = 404, message = "If invalid list id was provided")
    @GetMapping()
    public ResponseEntity<Iterable<ProductResponseDto>> get(@PathVariable Long listId) {
        return ResponseEntity.ok(
            productService.getProducts(listId)
            .stream().map(ProductResponseDto::of).collect(Collectors.toList()));
    }
    
    @ApiOperation(value = "Get product", nickname = "get product", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If valid id was provided", response = Iterable.class),
        @ApiResponse(code = 404, message = "If invalid id was provided")})
    @GetMapping("{id}")
    public ResponseEntity<ProductResponseDto> getUnit(@PathVariable Long listId, @PathVariable Long id) {
        return ResponseEntity.ok(ProductResponseDto.of(productService.getProduct(listId, id)));
    }
}