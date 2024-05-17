import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BadgeWidget extends StatelessWidget {
  final Widget child;
  final bool highlight;
  const BadgeWidget({super.key, required this.child, this.highlight = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        child,
        highlight
            ? Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  color: AppColor.red,
                  shape: BoxShape.circle,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
