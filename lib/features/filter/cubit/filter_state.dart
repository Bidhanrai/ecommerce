import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import 'package:shoes_ecommerce/features/discover/model/brand.dart';
import '../../product/models/product.dart';
import 'filter_cubit.dart';

class FilterState extends Equatable {
  final AppStatus appStatus;
  final Brand? selectedBrand;
  final SortBy? selectedSortBy;
  final Gender? selectedGender;
  final String? selectedColor;
  final RangeValues? selectedPriceRange;

  const FilterState({
    this.selectedBrand,
    this.selectedColor,
    this.selectedGender,
    this.selectedPriceRange,
    this.selectedSortBy,
    this.appStatus = AppStatus.init,
  });

  FilterState copyWith({
    AppStatus? appStatus,
    Brand? selectedBrand,
    SortBy? selectedSortBy,
    Gender? selectedGender,
    String? selectedColor,
    RangeValues? selectedPriceRange,
  }) {
    return FilterState(
      appStatus: appStatus ?? this.appStatus,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedSortBy: selectedSortBy ?? this.selectedSortBy,
      selectedPriceRange: selectedPriceRange ?? this.selectedPriceRange,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  @override
  List<Object?> get props => [selectedBrand, selectedColor, selectedGender, selectedPriceRange, selectedSortBy, appStatus,];
}
