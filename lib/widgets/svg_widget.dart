import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWidget extends StatelessWidget {
  final String svgPath;
  final Color? color;
  final double? height;
  final double? width;

  const SvgWidget({
    super.key,
    required this.svgPath,
    this.color,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPath,
      colorFilter: color!=null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      height: height,
      width: width,
      fit: BoxFit.scaleDown,
    );
  }
}
