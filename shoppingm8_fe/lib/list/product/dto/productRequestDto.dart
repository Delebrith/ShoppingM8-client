import '../productCategory.dart';

class ProductRequestDto {
  final String name;
  final num requiredAmount;
  final String unit;
  final ProductCategory category;

  ProductRequestDto({this.name, this.requiredAmount, this.unit, this.category});

  Map toJson() {
    Map map = Map();
    map['name'] = name;
    map['requiredAmount'] = requiredAmount;
    map['unit'] = unit;
    map['category'] = category.toString().replaceFirst("ProductCategory.", "");
    return map;
  }
}