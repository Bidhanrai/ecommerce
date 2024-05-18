import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../discover/model/brand.dart';
import '../../product/models/product.dart';
import 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit(): super(const FilterState());

  selectBrand(Brand brand) {
    emit(state.copyWith(selectedBrand: brand));
  }

  selectSortBy(SortBy value) {
    emit(state.copyWith(selectedSortBy: value));
  }

  selectGender(Gender value) {
    emit(state.copyWith(selectedGender: value));
  }

  List<String> colorList = [
    '0XFFFF0000',
    '0XFF000000',
    '0XFFFFFFFF',
    '0XFF0000FF',
    '0XFF2986CC',
    '0XFFFFC0CB',
  ];
  selectColor(String hexCode) {
    emit(state.copyWith(selectedColor: hexCode));
  }

  selectRange(RangeValues values) {
    emit(state.copyWith(selectedPriceRange: values));
  }

  reset() {
    emit(const FilterState());
  }

  int get filterCount {
    int count = 0;
    if(state.selectedBrand != null) {
      count++;
    }
    if(state.selectedPriceRange != null) {
      count++;
    }
    if(state.selectedSortBy != null) {
      count++;
    }
    if(state.selectedGender != null) {
      count++;
    }
    if(state.selectedColor != null) {
      count++;
    }
    return count;
  }
}

///A simple json to map hex codes with color names
final Map<String, String> hexToColorName = {
  '0XFFFF0000': 'Red',
  '0XFF000000': 'Black',
  '0XFFFFFFFF': 'White',
  '0XFF0000FF': 'Blue',
  '0XFF2986CC': 'Light Blue',
  '0XFFFFC0CB': 'Pink',
};

String getColorName(String hexCode) {
  return hexToColorName[hexCode.toUpperCase()] ?? 'Unknown Color';
}


enum SortBy {
  mostRecent("Most recent"),
  lowPrice("Lowest price"),
  highReviews("Highest reviews");

  final String value;
  const SortBy(this.value);

}