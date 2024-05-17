import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({super.key, this.width = double
      .infinity, required this.height, this.shapeBorder = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))});

  const ShimmerWidget.circular({super.key, required this.width, required this.height, this.shapeBorder = const CircleBorder(),});


  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 4),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          color: Colors.grey,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
