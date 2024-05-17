import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import 'package:shoes_ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:shoes_ecommerce/features/cart/cubit/cart_state.dart';
import 'package:shoes_ecommerce/features/discover/cubit/discover_cubit.dart';
import 'package:shoes_ecommerce/features/discover/cubit/discover_state.dart';
import 'package:shoes_ecommerce/features/discover/model/brand.dart';
import 'package:shoes_ecommerce/features/filter.dart';
import 'package:shoes_ecommerce/features/product/product_detail_view.dart';
import 'package:shoes_ecommerce/widgets/loading_widget.dart';
import '../../constants/app_colors.dart';
import '../../widgets/badge_widget.dart';
import '../../widgets/get_brand_image.dart';
import '../../widgets/svg_widget.dart';
import '../cart/cart_view.dart';
import '../settings_view.dart';
import 'model/product.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscoverCubit>(
      create: (_) => DiscoverCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _appBar(),
              _brandsFilter(),
              Expanded(
                child: BlocBuilder<DiscoverCubit, DiscoverState>(
                  builder: (context, state) {
                    switch(state.appStatus) {
                      case AppStatus.loading:
                        return const LoadingWidget();
                      case AppStatus.failure:
                        return const Center(child: Text("Error"),);
                      default:
                        return GridView.builder(
                          itemCount: state.products.length,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ).copyWith(bottom: 100),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: getValueForScreenType(
                              context: context,
                              mobile: 2,
                              tablet: 3,
                              desktop: 5,
                            ),
                            mainAxisSpacing: 40,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            return _product(state.products[index]);
                          },
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FilterView()));
          },
          style: TextButton.styleFrom(
            backgroundColor: AppColor.black,
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              BadgeWidget(
                highlight: false,
                child: SvgWidget(
                  svgPath: "assets/icons/filter.svg",
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "FILTER",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Discover",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _brandsFilter() {
    return BlocBuilder<DiscoverCubit, DiscoverState>(builder: (context, state) {
      return SizedBox(
        height: 40,
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(width: 0),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: state.brands.length,
          itemBuilder: (context, index) {
            Brand brand = state.brands[index];
            return InkWell(
              onTap: () {
                context.read<DiscoverCubit>().selectBrand(brand);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Text(
                    brand.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      letterSpacing: 1,
                      color: state.selectedBrand == brand
                          ? AppColor.black
                          : AppColor.lightGrey,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _product(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProductDetailView(product: product)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GetBrandImage(brandName: product.brand),
                  ),
                  Expanded(child: Image.network(product.imageUrl)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.name,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          //TODO: use cloud functions to fetch review details
          // const SizedBox(height: 4),
          // const Row(
          //   children: [
          //     Icon(Icons.star_rounded, color: AppColor.yellow),
          //     SizedBox(width: 4),
          //     Text.rich(
          //       TextSpan(
          //         text: "4.5",
          //         style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          //         children: <TextSpan>[
          //           TextSpan(
          //             style: TextStyle(
          //                 fontWeight: FontWeight.w400,
          //                 color: AppColor.lightGrey),
          //             text: "  (104 Reviews)",
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 4),
          Text(
            "\$${product.price}",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
