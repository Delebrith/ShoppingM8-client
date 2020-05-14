import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/iconic_icons.dart';

enum ProductCategory {
  FOOD,
  CLEANING_SUPPLIES,
  PHARMACY,
  COSMETICS,
  TOOLS,
  HOBBY_OR_FUN,
  OTHER
}

class ProductCategoryHepler {
  static String getName(ProductCategory category) {
    switch (category) {
      case ProductCategory.FOOD:
        return "Food";
      case ProductCategory.CLEANING_SUPPLIES:
        return "Cleaning supplies";
      case ProductCategory.PHARMACY:
        return "Pharmacy";
      case ProductCategory.COSMETICS:
        return "Cosmetics";
      case ProductCategory.TOOLS:
        return "Tools";
      case ProductCategory.HOBBY_OR_FUN:
        return "Hobby/for fun";
      case ProductCategory.OTHER:
        return "Others";
    }
    return "";
  }

  static IconData getIcon(ProductCategory category) {
    switch (category) {
      case ProductCategory.FOOD:
        return Icons.fastfood;
      case ProductCategory.CLEANING_SUPPLIES:
        return Entypo.droplet;
      case ProductCategory.PHARMACY:
        return Icons.local_pharmacy;
      case ProductCategory.COSMETICS:
        return FontAwesome.eyedropper;
      case ProductCategory.TOOLS:
        return Entypo.tools;
      case ProductCategory.HOBBY_OR_FUN:
        return FontAwesome.puzzle;
      case ProductCategory.OTHER:
      default:
        return Iconic.box;
    }
  }

  static Color getColor(ProductCategory category) {
    switch (category) {
      case ProductCategory.FOOD:
        return Colors.lightGreen;
      case ProductCategory.CLEANING_SUPPLIES:
        return Colors.lightBlueAccent;
      case ProductCategory.PHARMACY:
        return Colors.greenAccent;
      case ProductCategory.COSMETICS:
        return Colors.pink;
      case ProductCategory.TOOLS:
        return Colors.orangeAccent;
      case ProductCategory.HOBBY_OR_FUN:
        return Colors.purple;
      case ProductCategory.OTHER:
      default:
        return Colors.blueGrey;
    }
  }

  static ProductCategory getFromString(String value) {
    switch (value) {
      case "FOOD":
        return ProductCategory.FOOD;
      case "CLEANING_SUPPLIES":
        return ProductCategory.CLEANING_SUPPLIES;
      case "PHARMACY":
        return ProductCategory.PHARMACY;
      case "COSMETICS":
        return ProductCategory.COSMETICS;
      case "TOOLS":
        return ProductCategory.TOOLS;
      case "HOBBY_OR_FUN":
        return ProductCategory.HOBBY_OR_FUN;
      case "OTHER":
      default:
        return ProductCategory.OTHER;
    }
  }

  static Set<String> getGooglePlaceType(ProductCategory category) {
    switch(category) {
      case ProductCategory.FOOD:
        return { "bakery", "grocery_or_supermarket", "convenience_store" };
      case ProductCategory.CLEANING_SUPPLIES:
        return { "supermarket" };
      case ProductCategory.PHARMACY:
        return { "pharmacy", "drugstore" };
      case ProductCategory.COSMETICS:
        return { "supermarket", "drugstore" };
      case ProductCategory.TOOLS:
        return { "hardware_store" };
      case ProductCategory.HOBBY_OR_FUN:
        return { "bicycle store", "book store", "pet store", "electronics_store", "florist", "jewelry_store" };
      default:
        return { "store", "shopping_mall", "supermarket" };
    }
  }
}