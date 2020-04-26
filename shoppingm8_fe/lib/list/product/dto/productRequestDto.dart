import '../productCategory.dart';

class ProductRequestDto {
  final String name;
  final num requiredAmount;
  final String unit;
  final ProductCategory category;

  ProductRequestDto({this.name, this.requiredAmount, this.unit, this.category});
}