import '../productCategory.dart';

class ProductRequestDto {
  final String name;
  final num requiredAmount;
  final num purchasedAmount;
  final String unit;
  final ProductCategory category;

  ProductRequestDto({this.name, this.requiredAmount, this.purchasedAmount, this.unit, this.category});
}