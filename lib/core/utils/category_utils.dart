import 'package:flutter/material.dart';

class CategoryUtils {
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'jewelery':
        return Icons.diamond;
      case "men's clothing":
        return Icons.male;
      case "women's clothing":
        return Icons.female;
      default:
        return Icons.category;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return const Color(0xFFD7E3FC); // Soft Periwinkle
      case 'jewelery':
        return const Color(0xFFFFF2C5); // Soft Creamy Yellow
      case "men's clothing":
        return const Color(0xFFE2F6D3); // Soft Mint
      case "women's clothing":
        return const Color(0xFFFFDEE1); // Soft Rose
      default:
        return const Color(0xFFF0F0F0); // Light Grey
    }
  }
}
