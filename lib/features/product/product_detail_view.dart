import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import 'package:shoes_ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:shoes_ecommerce/features/cart/widget/add_to_card.dart';
import 'package:shoes_ecommerce/features/product/cubit/product_cubit.dart';
import 'package:shoes_ecommerce/features/product/cubit/product_state.dart';
import 'package:shoes_ecommerce/features/review/review_view.dart';
import 'package:shoes_ecommerce/widgets/badge_widget.dart';
import 'package:shoes_ecommerce/widgets/shimmer_widget.dart';
import 'package:shoes_ecommerce/widgets/svg_widget.dart';
import '../../constants/app_colors.dart';
import '../../core/error_component.dart';
import '../../widgets/primary_button.dart';
import '../cart/cart_view.dart';
import '../cart/cubit/cart_state.dart';
import 'models/product.dart';
import '../review/widget/ratings_widget.dart';
import '../review/widget/review_card.dart';

class ProductDetailView extends StatefulWidget {
  final Product product;
  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {

  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCubit>(
      create: (_) => ProductCubit(
        ProductState(
          product: widget.product,
          productSize: widget.product.size.isNotEmpty?widget.product.size.first:0,
          productColor: widget.product.color.isNotEmpty?widget.product.color.first:"0XFFFFFFFF",
          quantity: 1,
        ),
      )..fetchReviews(widget.product.id),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartView(),
                  ),
                );
              },
              icon: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  return BadgeWidget(
                    highlight: state.cart!= null && state.cart!.cartDataList.isNotEmpty,
                    child: const SvgWidget(svgPath: "assets/icons/cart.svg"),
                  );
                },
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _product(),

            _productSize(),

            const SizedBox(height: 24),
            const Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            const SizedBox(height: 8),
            Text(widget.product.description, style: const TextStyle(fontWeight: FontWeight.w400, height: 1.7, color: AppColor.lightGrey1),),
            const SizedBox(height: 24),
            _review(),
            const SizedBox(height: 100),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _cTA(),
      ),
    );
  }

  Widget _product() {
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  height: 250,
                  padding: const EdgeInsets.only(top: 40),
                  child: widget.product.color.isNotEmpty
                      ? PageView.builder(
                          controller: pageController,
                          itemCount: widget.product.color.length,
                          onPageChanged: (int value) {
                            context
                                .read<ProductCubit>()
                                .selectColor(widget.product.color[value]);
                          },
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(imageUrl: widget.product.imageUrl);
                          },
                        )
                      : CachedNetworkImage(imageUrl: widget.product.imageUrl),
                ),

                ///Color indicator
                widget.product.color.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...widget.product.color.map(
                                  (e) => Container(
                                    height: 7,
                                    width: 7,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: e == state.productColor
                                          ? AppColor.black
                                          : AppColor.lightGrey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Wrap(
                                spacing: 8,
                                children: [
                                  ...widget.product.color.map(
                                    (e) => InkWell(
                                      onTap: () {
                                        pageController.animateToPage(
                                            (widget.product.color.indexOf(e)),
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.ease);
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(e)),
                                          shape: BoxShape.circle,
                                          border: e.toUpperCase() ==
                                                  "0XFFFFFFFF"
                                              ? Border.all(color: AppColor.grey)
                                              : null,
                                        ),
                                        child: e == state.productColor
                                            ? Icon(
                                                Icons.done,
                                                size: 16,
                                                color: e.toUpperCase() ==
                                                        "0XFFFFFFFF"
                                                    ? Colors.black
                                                    : Colors.white,
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.product.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          _averageRating(),
          const SizedBox(height: 20),
        ],
      );
    });
  }

  Widget _productSize() {
    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (state, previousState) {
        return state.productSize != previousState.productSize;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Size",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: widget.product.size
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        context.read<ProductCubit>().selectSize(e);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: state.productSize == e ? Colors.transparent : AppColor.grey,
                          ),
                          color: state.productSize == e ? AppColor.black: Colors.transparent,
                        ),
                        child: Text("$e", style: TextStyle(color: state.productSize == e ?Colors.white: AppColor.black),),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      }
    );
  }

  Widget _averageRating() {
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
      switch (state.reviewStatus) {
        case AppStatus.loading:
          return const Text("...");
        default:
          return state.reviews.isNotEmpty
              ? Row(
                  children: [
                    RatingsWidget(ratings: state.averageRating.toInt()),
                    const SizedBox(width: 4),
                    Text.rich(
                      TextSpan(
                        text: "${state.averageRating}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 11),
                        children: <TextSpan>[
                          TextSpan(
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColor.lightGrey),
                            text: "  (${state.reviews.length} ${state.reviews.length >1?"Reviews":"Review"})",
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox();
      }
    });
  }

  Widget _review() {
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
      switch (state.reviewStatus) {
        case AppStatus.loading:
          return const Column(
            children: [
              ShimmerWidget.rectangular(height: 30),
              SizedBox(height: 10),
              ShimmerWidget.rectangular(height: 30),
              SizedBox(height: 10),
              ShimmerWidget.rectangular(height: 30),
            ],
          );
        case AppStatus.failure:
          return ErrorComponent(
            exception: state.errorMessage,
            retry: () => context
                .read<ProductCubit>()
                .fetchReviews(widget.product.id),
          );
        default:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Review ${state.reviews.isEmpty ? "" : "(${state.reviews.length})"}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 12),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 32),
                itemCount: state.reviews.length > 3 ? 3 : state.reviews.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ReviewCard(review: state.reviews[index]);
                },
              ),
              const SizedBox(height: 28),
              state.reviews.isEmpty
                  ? const Text(
                      "No reviews yet",
                      style: TextStyle(fontSize: 18),
                    )
                  : Button.outlined(
                      label: "SEE ALL REVIEW",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReviewView(allReview: state.reviews),
                          ),
                        );
                      },
                    ),
            ],
          );
      }
    });
  }

  Widget _cTA() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        ProductCubit productCubit = context.read<ProductCubit>();
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
                    "Price",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.lightGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${widget.product.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Button.primary(
                label: context.watch<CartCubit>().productIdList.contains(widget.product.id)
                    ? "Already in cart": "ADD TO CART",
                backgroundColor: context.read<CartCubit>().productIdList.contains(widget.product.id)
                    ? Colors.grey.shade400
                    : AppColor.black,
                onTap: () {
                  if( context.read<CartCubit>().productIdList.contains(widget.product.id)) {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const CartView()));
                  } else {
                    showModalBottomSheet(
                      context: context,
                      useSafeArea: true,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(bottom:  MediaQuery.of(context).viewInsets.bottom, top: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 4,
                                width: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColor.grey,
                                ),
                              ),
                              AddToCart(productCubit: productCubit),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        );
      }
    );
  }
}
