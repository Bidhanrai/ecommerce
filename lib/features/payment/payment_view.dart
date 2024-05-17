import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoes_ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:shoes_ecommerce/features/cart/cubit/cart_state.dart';
import 'package:shoes_ecommerce/features/cart/model/cart.dart';
import 'package:shoes_ecommerce/features/discover/discover_view.dart';
import 'package:shoes_ecommerce/services/auth_service.dart';
import 'package:shoes_ecommerce/utils/toast_message.dart';
import 'package:shoes_ecommerce/widgets/loading_widget.dart';
import '../../constants/app_colors.dart';
import '../../services/service_locator.dart';
import '../../widgets/primary_button.dart';
import 'order.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(builder: (context, state) {
      return Material(
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text("Order Summary"),
              ),
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _title("Information"),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Payment Method",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      "Credit Card",
                      style: TextStyle(color: AppColor.lightGrey3),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: AppColor.lightGrey,
                    ),
                  ),
                  const Divider(),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Location",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      "Kathmandu, Nepal",
                      style: TextStyle(color: AppColor.lightGrey3),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: AppColor.lightGrey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _title("Order Detail"),
                  const SizedBox(height: 8),
                  ...context.read<CartCubit>().productInCart.map(
                    (product) {
                      int index = context
                          .read<CartCubit>()
                          .productInCart
                          .indexOf(product);
                      CartData cartData = state.cart!.cartDataList[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "${product.brand} . ${cartData.color} . ${cartData.size} . Qty ${cartData.quantity}",
                          style: const TextStyle(
                            color: AppColor.lightGrey3,
                          ),
                        ),
                        trailing: Text(
                          "\$${product.price * cartData.quantity}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _title("Payment Detail"),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Sub Total",
                            style: TextStyle(
                              color: AppColor.lightGrey3,
                            ),
                          ),
                        ),
                        Text(
                          "\$${context.read<CartCubit>().totalPrice}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Shipping",
                            style: TextStyle(
                              color: AppColor.lightGrey3,
                            ),
                          ),
                        ),
                        Text(
                          "\$0",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Total order",
                          style: TextStyle(
                            color: AppColor.lightGrey3,
                          ),
                        ),
                      ),
                      Text(
                        "\$${context.read<CartCubit>().totalPrice}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: _cTA(context, state),
            ),
            _loading
                ? Container(
                    color: Colors.black12,
                    child: const LoadingWidget(),
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }

  Widget _title(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _cTA(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(-1, -1),
            spreadRadius: 0.1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Grand Total",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.lightGrey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "\$${context.read<CartCubit>().totalPrice}",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Button.primary(
            label: "PAYMENT",
            onTap: () {
              placeOrder(context, state);
            },
          ),
        ],
      ),
    );
  }

  bool _loading = false;
  setLoading(bool value) {
    setState(() {
      _loading = value;
    });
  }
  placeOrder(BuildContext context, CartState state) async {
    setLoading(true);
    CollectionReference orders = FirebaseFirestore.instance.collection('orders');
    return await orders.add(OrderModel(
      userId: "${locator<AuthService>().user?.uid}",
      products: state.cart!.cartDataList,
      status: "order placed",
      totalPrice: context.read<CartCubit>().totalPrice,
    ).toJson())
        .then(
      (value) {
        toastMessage(message: "Order placed", gravity: ToastGravity.CENTER);
        context.read<CartCubit>().clearCart();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const DiscoverView()),
                (route) => false);
      },
    ).catchError((error) {
      debugPrint("Failed to add: $error");
    }).whenComplete(() => setLoading(false));
  }
}
