package edu.pw.shoppingm8.product;

import edu.pw.shoppingm8.product.exception.InvalidProductCategoryException;

public enum ProductCategory {
    FOOD,
    CLEANING_SUPPLIES,
    PHARMACY,
    COSMETICS,
    TOOLS,
    HOBBY_OR_FUN,
    OTHER;
    
    public static ProductCategory fromString(String value) {
        try {
            return valueOf(value);   
        } catch (IllegalArgumentException exception) {
            throw new InvalidProductCategoryException();
        }
    }
}