import 'package:flutter/material.dart';
import 'package:shoes_ecommerce/widgets/svg_widget.dart';
import '../constants/app_colors.dart';

class GetBrandImage extends StatelessWidget {
  final String brandName;
  const GetBrandImage({super.key, required this.brandName});

  @override
  Widget build(BuildContext context) {
    String imagePath = "";
    switch(brandName) {
      case "Nike":
        imagePath = "assets/icons/brands/Nike.svg";
      case "Puma":
        imagePath = "assets/icons/brands/puma.svg";
      case "Adidas":
        imagePath = "assets/icons/brands/adidas.svg";
      case "Reebok":
        imagePath = "assets/icons/brands/reebok.svg";
      default:
        imagePath = "assets/icons/brands/Nike.svg";
    }
    return SvgWidget(
      svgPath: imagePath,
      color: AppColor.lightGrey,
    );
  }
}
