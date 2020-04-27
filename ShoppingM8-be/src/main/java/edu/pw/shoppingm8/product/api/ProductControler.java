package edu.pw.shoppingm8.product.api;

import java.net.URI;
import java.util.stream.Collectors;

import javax.validation.Valid;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import edu.pw.shoppingm8.product.Product;
import edu.pw.shoppingm8.product.ProductService;
import edu.pw.shoppingm8.product.api.dto.ProductCreateRequestDto;
import edu.pw.shoppingm8.product.api.dto.ProductPatchRequestDto;
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
    @GetMapping
    public ResponseEntity<Iterable<ProductResponseDto>> get(@PathVariable Long listId) {
        return ResponseEntity.ok(
            productService.getProducts(listId)
            .stream().map(ProductResponseDto::of).collect(Collectors.toList()));
    }
    
    @ApiOperation(value = "Get product", nickname = "get product", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If valid id was provided", response = ProductResponseDto.class),
        @ApiResponse(code = 404, message = "If invalid id was provided")})
    @GetMapping("{id}")
    public ResponseEntity<ProductResponseDto> getProduct(@PathVariable Long listId, @PathVariable Long id) {
        return ResponseEntity.ok(ProductResponseDto.of(productService.getProduct(listId, id)));
    }

    @ApiOperation(value = "Create product", nickname = "create product", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 201, message = "If valid data was provided"),
        @ApiResponse(code = 400, message = "If invalid data was provided"),
        @ApiResponse(code = 403, message = "If user does not have access to the list"),
        @ApiResponse(code = 404, message = "If invalid list id was provided")})
    @PostMapping
    public ResponseEntity<Void> createProduct(
        @PathVariable Long listId, @Valid @RequestBody ProductCreateRequestDto productDto) {
        Product product = productService.createProduct(listId, productDto);
        return ResponseEntity.created(
            URI.create(String.format("/list/%d/product/%d", listId, product.getId())))
            .build();
    }
    
    @ApiOperation(value = "Patch product", nickname = "patch product", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If valid data was provided"),
        @ApiResponse(code = 400, message = "If invalid data was provided"),
        @ApiResponse(code = 403, message = "If user does not have access to the list"),
        @ApiResponse(code = 404, message = "If invalid id was provided")})
    @PatchMapping("{id}")
    public ResponseEntity<Void> patchProduct(
        @PathVariable Long listId, @PathVariable Long id, @Valid @RequestBody ProductPatchRequestDto productDto) {
        productService.patchProduct(listId, id, productDto);
        return ResponseEntity.ok().build();
    }
    
    @ApiOperation(value = "Purchase product", nickname = "puchase product", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If valid data was provided"),
        @ApiResponse(code = 403, message = "If user does not have access to the list"),
        @ApiResponse(code = 404, message = "If invalid id was provided")})
    @PostMapping("{id}")
    public ResponseEntity<Void> purchaseProduct(@PathVariable Long listId, @PathVariable Long id, @RequestParam Double amount) {
        productService.purchaseProduct(listId, id, amount);
        return ResponseEntity.ok().build();
    }
    
    @ApiOperation(value = "Delete product", nickname = "delete product", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "If valid id was provided"),
        @ApiResponse(code = 403, message = "If user does not have access to the list"),
        @ApiResponse(code = 404, message = "If invalid id was provided")})
    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long listId, @PathVariable Long id) {
        productService.deleteProduct(listId, id);
        return ResponseEntity.ok().build();
    }
}