import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import 'package:shoes_ecommerce/core/error_component.dart';
import 'package:shoes_ecommerce/features/payment/payment_view.dart';
import 'package:shoes_ecommerce/services/auth_service.dart';
import 'package:shoes_ecommerce/widgets/loading_widget.dart';
import '../../constants/app_colors.dart';
import '../../services/service_locator.dart';
import '../../widgets/primary_button.dart';
import '../discover/model/product.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/cart_state.dart';
import 'model/cart.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    context.read<CartCubit>().fetchCart(locator<AuthService>().user?.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          switch (state.appStatus) {
            case AppStatus.loading:
              return const LoadingWidget();
            case AppStatus.failure:
              return ErrorComponent(
                exception: state.errorMessage,
                retry: () => context
                    .read<CartCubit>()
                    .fetchCart(locator<AuthService>().user?.uid),
              );
            default:
              if (state.cart != null && state.cart!.cartDataList.isNotEmpty) {
                return Stack(
                  children: [
                    ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 28),
                      padding: const EdgeInsets.all(20),
                      itemCount: state.cart!.cartDataList.length,
                      itemBuilder: (context, index) {
                        Product product =
                            context.read<CartCubit>().productInCart[index];
                        CartData cartData = state.cart!.cartDataList[index];
                        return Slidable(
                          actionPane: const SlidableScrollActionPane(),
                          secondaryActions: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  context
                                      .read<CartCubit>()
                                      .removeProduct(cartData);
                                },
                              ),
                            ),
                          ],
                          direction: Axis.horizontal,
                          child: _cartItem(context, product, cartData),
                        );
                      },
                    ),
                    state.isBusy
                        ? Container(
                            color: Colors.black12,
                            child: const LoadingWidget(),
                          )
                        : const SizedBox(),
                  ],
                );
              } else {
                return Center(
                  child: Button.outlined(
                    label: "Cart is empty. Let's shop!",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              }
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _cTA(),
    );
  }

  Widget _cartItem(BuildContext context, Product product, CartData cartData) {
    return Row(
      children: [
        Container(
          height: 88,
          width: 88,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.network(product.imageUrl),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                product.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                "${product.brand} . ${cartData.color} . ${cartData.size}",
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColor.lightGrey3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "\$${product.price * cartData.quantity}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: cartData.quantity > 1
                            ? () {
                                context
                                    .read<CartCubit>()
                                    .subtractQuantity(cartData.productId);
                              }
                            : null,
                        child: Icon(
                          Icons.remove_circle_outline_rounded,
                          color: cartData.quantity > 1
                              ? AppColor.black
                              : AppColor.lightGrey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(" ${cartData.quantity} "),
                      ),
                      InkWell(
                        onTap: () {
                          context
                              .read<CartCubit>()
                              .addQuantity(cartData.productId);
                        },
                        child: const Icon(Icons.add_circle_outline_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cTA() {
    return BlocBuilder<CartCubit, CartState>(builder: (context, state) {
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
                  state.appStatus == AppStatus.loading || state.appStatus == AppStatus.failure
                      ? "..."
                      : "\$${context.read<CartCubit>().totalPrice}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Button.primary(
              label: "CHECK OUT",
              disable: !(state.cart != null && state.cart!.cartDataList.isNotEmpty),
              onTap: state.cart != null && state.cart!.cartDataList.isNotEmpty && state.appStatus != AppStatus.loading && !state.isBusy
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PaymentView()));
                    }
                  : () {},
            ),
          ],
        ),
      );
    });
  }
}
