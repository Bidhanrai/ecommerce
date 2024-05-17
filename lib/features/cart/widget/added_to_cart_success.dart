import 'package:flutter/material.dart';
import 'package:shoes_ecommerce/features/discover/discover_view.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/primary_button.dart';
import '../cart_view.dart';

class AddedToCartSuccess extends StatelessWidget {
  const AddedToCartSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.black, width: 2),
            ),
            child: const Icon(
              Icons.done,
              size: 40,
              color: AppColor.lightGrey,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Added to cart",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "1 item total",
            style: TextStyle(
              color: AppColor.lightGrey1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Button.outlined(
                  label: "BACK EXPLORE",
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DiscoverView()),
                        (route) => false);
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Button.primary(
                  label: "TO CART",
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartView(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
