import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoes_ecommerce/features/product/cubit/product_cubit.dart';
import 'package:shoes_ecommerce/widgets/loading_widget.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/primary_button.dart';
import 'added_to_cart_success.dart';

class AddToCart extends StatefulWidget {
  final ProductCubit productCubit;
  const AddToCart({super.key, required this.productCubit});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {

  late TextEditingController _textEditingController;

  bool _loading = false;
  setLoading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  @override
  void initState() {
    _textEditingController = TextEditingController(text: "${widget.productCubit.state.quantity}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Add to cart",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            "Quantity",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextField(
            controller: _textEditingController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              suffix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      _subtractQuantity();
                    },
                    child: const Icon(
                      Icons.remove_circle_outline_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      _addQuantity();
                    },
                    child: const Icon(
                      Icons.add_circle_outline_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Price",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.lightGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${widget.productCubit.state.product.price * widget.productCubit.state.quantity}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              _loading
                  ? const LoadingWidget()
                  : Button.primary(
                      label: "ADD TO CART",
                      onTap: () async {
                        setLoading(true);
                        await widget.productCubit.addToCart(() {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            useSafeArea: true,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return const AddedToCartSuccess();
                            },
                          );
                        });
                        setLoading(false);
                      },
                    ),
            ],
          ),
        ],
      ),
    );
  }

  _subtractQuantity() {
    if(widget.productCubit.state.quantity>1) {
      int value = widget.productCubit.state.quantity-1;
      setState(() {
        _textEditingController.text = "$value";
        widget.productCubit.addQuantity(widget.productCubit.state.quantity-1);
      });
    }
  }

  _addQuantity() {
    int value = widget.productCubit.state.quantity+1;
    setState(() {
      _textEditingController.text = "$value";
      widget.productCubit.addQuantity(widget.productCubit.state.quantity+1);
    });
  }
}
