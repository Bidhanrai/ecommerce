import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import 'package:shoes_ecommerce/features/product/models/product.dart';
import '../../filter/cubit/filter_state.dart';
import '../model/brand.dart';
import 'discover_state.dart';
import 'package:cloud_functions/cloud_functions.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit() : super(const DiscoverState()) {
    fetchProductsAndBrands();
  }

  final _brandsRef = FirebaseFirestore.instance.collection("brands");
  final _productFunction = FirebaseFunctions.instance.httpsCallable('fetchProducts');
  final _filterProductFunction = FirebaseFunctions.instance.httpsCallable('filterProducts');


  ///Fetching some products, brand list
  fetchProductsAndBrands() async {
    emit(state.copyWith(
        appStatus: AppStatus.loading,
        selectedBrand: const Brand(id: "-1", name: "All", image: "")));
    try {
      await Future.wait([getProducts(), getBrandsList()]);
      emit(state.copyWith(appStatus: AppStatus.success));
    } catch (e) {
      emit(state.copyWith(appStatus: AppStatus.failure, errorMessage: "$e"));
    }
  }

  ///TODO: can manage state of some products for each brand including ALL
  ///TODO: in Discover page while user switches from top horizontal bar
  Future<void> getProducts() async {
    try {
      final HttpsCallableResult response = await _productFunction.call({"payload": {}});
      List<Product> products = (response.data as List)
          .map((prod) => Product.fromJson(prod))
          .toList();
      emit(state.copyWith(products: products));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getBrandsList() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _brandsRef.get();
      List<Brand> brands = snapshot.docs
          .map((docSnapshot) => Brand.fromDocumentSnapshot(docSnapshot))
          .toList();
      emit(state.copyWith(brands: brands));
    } catch (e) {
      rethrow;
    }
  }

  ///Pagination for Discover screen
  loadMoreProducts() async {
    if (state.paginating || state.products.isEmpty) return;
    emit(state.copyWith(paginating: true));
    try {
      late HttpsCallableResult response;
      List<Product> moreProducts = [];
      if (state.selectedBrand.id != "-1") {
        response = await _productFunction.call({"lastProductId": state.products.last.id, "payload": {"brandId": state.selectedBrand.id}});
      } else {
        response = await _productFunction.call({"lastProductId": state.products.last.id, "payload": {}});
      }
      moreProducts = (response.data as List)
          .map((prod) => Product.fromJson(prod))
          .toList();
      List<Product> products = [...state.products];
      products.addAll(moreProducts);
      emit(state.copyWith(products: products));
    } catch (e) {
      debugPrint("$e");
    } finally {
      emit(state.copyWith(paginating: false));
    }
  }

  ///Fetching products of a specific brand
  selectBrand(Brand brand) {
    emit(state.copyWith(selectedBrand: brand));
    fetchSpecificBrandProducts(brand.id);
  }

  fetchSpecificBrandProducts(String brandId) async {
    emit(state.copyWith(appStatus: AppStatus.loading));
    try {
      final HttpsCallableResult response = brandId != "-1"
          ? await _productFunction.call({"payload": {"brandId": state.selectedBrand.id}})
          : await _productFunction.call({"payload": {}});
      List<Product> products = (response.data as List)
          .map((prod) => Product.fromJson(prod))
          .toList();
      emit(state.copyWith(appStatus: AppStatus.success, products: products));
    } catch (e) {
      emit(state.copyWith(appStatus: AppStatus.failure, errorMessage: "$e"));
    }
  }


  applyFilter(FilterState filterState) async {
    emit(state.copyWith(
        appStatus: AppStatus.loading,
        selectedBrand: filterState.selectedBrand));
    try {
      // print({"payload": {
      //   "brandId": filterState.selectedBrand?.id,
      //   "color": filterState.selectedColor,
      //   "gender": filterState.selectedGender?.name.toUpperCase(),
      //   "price": filterState.selectedPriceRange != null
      //       ? {"min": filterState.selectedPriceRange!.start, "max": filterState.selectedPriceRange!.end}
      //       : null,
      //   "sortBy": filterState.selectedSortBy?.value,
      // }});
      final HttpsCallableResult response = await _filterProductFunction.call({
        "payload": {
          "brandId": filterState.selectedBrand?.id,
          "color": filterState.selectedColor,
          "gender": filterState.selectedGender?.name.toUpperCase(),
          "price": filterState.selectedPriceRange != null
              ? {"min": filterState.selectedPriceRange!.start, "max": filterState.selectedPriceRange!.end}
              : null,
          "sortBy": filterState.selectedSortBy?.value,
        }
      });
      List<Product> products = (response.data as List)
          .map((prod) => Product.fromJson(prod))
          .toList();
      emit(state.copyWith(appStatus: AppStatus.success, products: products));
    } catch (e) {
      debugPrint("$e");
      emit(state.copyWith(appStatus: AppStatus.failure, errorMessage: "$e"));
    }
  }

  loadMoreFilteredProducts(FilterState filterState) async {
    if (state.paginating || state.products.isEmpty) return;
    emit(state.copyWith(paginating: true));
    try {
      // print({
      //   "lastProductId": state.products.last.id,
      //   "payload": {
      //     "brandId": filterState.selectedBrand?.id,
      //     "color": filterState.selectedColor,
      //     "gender": filterState.selectedGender?.name.toUpperCase(),
      //     "price": filterState.selectedPriceRange != null
      //         ? {"min": filterState.selectedPriceRange!.start, "max": filterState.selectedPriceRange!.end}
      //         : null,
      //     "sortBy": filterState.selectedSortBy?.value,
      //   }
      // });
      final HttpsCallableResult response = await _filterProductFunction.call({
        "lastProductId": state.products.last.id,
        "payload": {
          "brandId": filterState.selectedBrand?.id,
          "color": filterState.selectedColor,
          "gender": filterState.selectedGender?.name.toUpperCase(),
          "price": filterState.selectedPriceRange != null
              ? {"min": filterState.selectedPriceRange!.start, "max": filterState.selectedPriceRange!.end}
              : null,
          "sortBy": filterState.selectedSortBy?.value,
        }
      });
      List<Product> moreProducts = (response.data as List)
          .map((prod) => Product.fromJson(prod))
          .toList();
      List<Product> products = [...state.products];
      products.addAll(moreProducts);
      emit(state.copyWith(products: products));
    } catch (e) {
      debugPrint("$e");
    } finally {
      emit(state.copyWith(paginating: false));
    }
  }
}
