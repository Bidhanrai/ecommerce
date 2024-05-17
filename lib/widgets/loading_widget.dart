import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Color? valueColor;
  const LoadingWidget({super.key, this.backgroundColor, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator.adaptive(
          backgroundColor: backgroundColor ?? Colors.white,
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? AppColor.blue,
          ),
        ),
      ),
    );
  }
}

