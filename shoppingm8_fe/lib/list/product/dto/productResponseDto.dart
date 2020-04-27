import 'package:shoppingm8_fe/list/product/productCategory.dart';

class ProductResponseDto {
  final num id;
  final String name;
  final num requiredAmount;
  final num purchasedAmount;
  final String unit;
  final ProductCategory category;

  ProductResponseDto({this.id, this.name, this.requiredAmount, this.purchasedAmount, this.unit, this.category});

  factory ProductResponseDto.fromJson(Map<String, dynamic> json) {
    return ProductResponseDto(
        id: json['id'],
        name: json['name'],
        requiredAmount: json['requiredAmount'],
        purchasedAmount: json['purchasedAmount'],
        unit: json['unit'],
        category: ProductCategoryHepler.getFromString(json['category'])
    );
  }
}