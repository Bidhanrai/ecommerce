import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_ecommerce/features/discover/cubit/discover_cubit.dart';
import 'package:shoes_ecommerce/features/filter/cubit/filter_cubit.dart';
import 'package:shoes_ecommerce/widgets/svg_widget.dart';
import '../../constants/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../discover/model/brand.dart';
import '../product/models/product.dart';
import 'cubit/filter_state.dart';


class FilterView extends StatelessWidget {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16).copyWith(bottom: 100),
        children: [
          _title("Brands"),
          _brandFilter(),

          const SizedBox(height: 28),

          _title("Price Range"),
          _priceRangeFilter(),

          const SizedBox(height: 28),

          _title("Sort By"),
          _sortByFilter(),

          const SizedBox(height: 28),

          _title("Gender"),
          _genderFilter(),

          const SizedBox(height: 28),

          _title("Color"),
          _colorFilter(),

          const SizedBox(height: 28),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _actionButton(),
    );
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _brandFilter() {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return SizedBox(
          height: 120,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 32),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: context.read<DiscoverCubit>().state.brands.length,
            itemBuilder: (context, index) {
              Brand brand = context.read<DiscoverCubit>().state.brands[index];
              return GestureDetector(
                onTap: () {
                  context.read<FilterCubit>().selectBrand(brand);
                },
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 54,
                          width: 54,
                          margin: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColor.lightGrey2,
                            shape: BoxShape.circle,
                          ),
                          child: SvgWidget(svgPath: brand.image, isAsset: false,),
                        ),
                        state.selectedBrand == brand
                            ? Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                  color: AppColor.black,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      brand.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text("100 items", style: TextStyle(color: AppColor.lightGrey, fontSize: 11),),

                  ],
                ),
              );
            },),
        );
      }
    );
  }

  Widget _priceRangeFilter() {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return Column(
          children: [
            RangeSlider(
              values: state.selectedPriceRange??const RangeValues(0, 10000),
              onChanged: (RangeValues rangeValue) {
                context.read<FilterCubit>().selectRange(rangeValue);
              },
              min: 0,
              max: 10000,
              labels: RangeLabels("${state.selectedPriceRange?.start}",
                  "${state.selectedPriceRange?.end}"),
              activeColor: AppColor.black,
              divisions: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$0",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColor.black,
                    ),
                  ),
                  Text(
                    "\$10000",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColor.black,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sortByFilter() {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            scrollDirection: Axis.horizontal,
            itemCount: SortBy.values.length,
            itemBuilder: (context, index) {
              SortBy sortBy =  SortBy.values[index];
              bool isSelected = sortBy == state.selectedSortBy;
              return GestureDetector(
                onTap: () {
                  context.read<FilterCubit>().selectSortBy(sortBy);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.black
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    border: isSelected
                        ? null
                        : Border.all(color: AppColor.grey),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    sortBy.value,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isSelected
                            ? Colors.white
                            : AppColor.black
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }

  Widget _genderFilter() {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: Gender.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              Gender gender = Gender.values[index];
              bool isSelected = gender == state.selectedGender;
              return GestureDetector(
                onTap: () {
                  context.read<FilterCubit>().selectGender(gender);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.black
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    border: isSelected
                        ? null
                        : Border.all(color: AppColor.grey),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    gender.value,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isSelected
                          ? Colors.white
                          : AppColor.black,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }

  Widget _colorFilter() {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: context.read<FilterCubit>().colorList.length,
            separatorBuilder: (context, index)=> const SizedBox(width: 16),
            itemBuilder: (context, index) {
              String hexCode = context.read<FilterCubit>().colorList[index];
              bool isSelected = hexCode == state.selectedColor;
              return GestureDetector(
                onTap: () {
                  context.read<FilterCubit>().selectColor(hexCode);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: isSelected
                        ? AppColor.black
                        : AppColor.grey,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Color(int.parse(hexCode)),
                          shape: BoxShape.circle,
                          border: hexCode == "0XFFFFFFFF"
                              ? Border.all(
                                  color: AppColor.grey,
                                )
                              : null,
                        ),
                      ),
                      Text(
                        getColorName(hexCode),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }

  Widget _actionButton() {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        int filterCount = context.read<FilterCubit>().filterCount;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Button.outlined(
                  label: "RESET${filterCount != 0?" ($filterCount)":""}",
                  onTap: () {
                    context.read<FilterCubit>().reset();
                    context.read<DiscoverCubit>().fetchProductsAndBrands();
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Button.primary(
                  label: "APPLY",
                  disable: context.read<FilterCubit>().filterCount == 0,
                  onTap: () {
                    context.read<DiscoverCubit>().applyFilter(state);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
