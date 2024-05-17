import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class Button extends StatelessWidget {
  final String label;
  final Color labelColor;
  final bool disable;
  final bool isBusy;
  final VoidCallback onTap;
  final OutlinedBorder outlinedBorder;
  final Color backgroundColor;
  final Widget? prefixIcon;


  const Button.primary({
    super.key,
    required this.label,
    this.labelColor = Colors.white,
    this.backgroundColor = AppColor.black,
    required this.onTap,
    this.disable = false,
    this.isBusy = false,
    this.prefixIcon,
    this.outlinedBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
    ),
  });

  const Button.outlined({
    super.key,
    required this.label,
    this.labelColor = AppColor.black,
    this.backgroundColor = Colors.transparent,
    required this.onTap,
    this.disable = false,
    this.isBusy = false,
    this.prefixIcon,
    this.outlinedBorder = const RoundedRectangleBorder(
      side: BorderSide(color: AppColor.grey),
      borderRadius: BorderRadius.all(Radius.circular(100)),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disable || isBusy
          ? null
          : onTap,
      style: TextButton.styleFrom(
        backgroundColor: disable
            ? AppColor.grey
            : backgroundColor,
        foregroundColor: labelColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColor.grey),
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      child: prefixIcon !=null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                prefixIcon!,
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            )
          : Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
