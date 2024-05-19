import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_ecommerce/features/discover/cubit/discover_cubit.dart';
import 'package:shoes_ecommerce/features/discover/cubit/discover_state.dart';
import 'package:shoes_ecommerce/features/discover/model/brand.dart';
import 'package:shoes_ecommerce/widgets/svg_widget.dart';
import '../constants/app_colors.dart';

class GetBrandImage extends StatelessWidget {
  final String brandId;
  const GetBrandImage({super.key, required this.brandId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        Brand? brand = state.brands.singleWhereOrNull((element) => element.id == brandId);
      return brand != null
          ? SvgWidget(
              isAsset: false,
              svgPath: brand.image,
              color: AppColor.lightGrey,
              height: 24,
            )
          : const SizedBox();
    }
    );
  }
}
