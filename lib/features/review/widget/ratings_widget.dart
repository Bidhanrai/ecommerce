import 'package:flutter/material.dart';
import 'package:shoes_ecommerce/constants/app_colors.dart';

class RatingsWidget extends StatelessWidget {
  final int ratings;
  const RatingsWidget({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < ratings; i++)
          const Icon(Icons.star_rounded, color: AppColor.yellow, size: 18)
      ],
    );
  }
}