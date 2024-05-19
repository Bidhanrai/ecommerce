import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import 'package:shoes_ecommerce/features/filter/cubit/filter_cubit.dart';
import 'package:shoes_ecommerce/features/product/models/product.dart';
import '../../filter/cubit/filter_state.dart';
import '../model/brand.dart';
import 'discover_state.dart';
import 'package:cloud_functions/cloud_functions.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit() : super(const DiscoverState()) {
    fetchProductsAndBrands();
  }

  final _productRef = FirebaseFirestore.instance.collection("products").limit(10);
  final _brandsRef = FirebaseFirestore.instance.collection("brands");
  final _prodFunction = FirebaseFunctions.instance.httpsCallable('fetchProducts');

  selectBrand(Brand brand) {
    emit(state.copyWith(selectedBrand: brand));
    fetchSpecificBrandProducts(brand.id);
  }

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

  Future<void> getProducts() async {
    try {
      final HttpsCallableResult response =
          await _prodFunction.call({"lastProductId": null});
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
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _brandsRef.get();
      List<Brand> brands = snapshot.docs
          .map((docSnapshot) => Brand.fromDocumentSnapshot(docSnapshot))
          .toList();
      emit(state.copyWith(brands: brands));
    } catch (e) {
      rethrow;
    }
  }

  loadMoreProducts() async {
    if (state.paginating || state.products.isEmpty) return;
    emit(state.copyWith(paginating: true));
    try {
      late HttpsCallableResult response;
      List<Product> moreProducts = [];
      if (state.selectedBrand.id != "-1") {
        response = await _prodFunction.call({"lastProductId": state.products.last.id, "brandId": state.selectedBrand.id});
        // QuerySnapshot<Map<String, dynamic>> snapshot = await _productRef
        //     .where("brand", isEqualTo: state.selectedBrand.id)
        //     .orderBy("id")
        //     .startAfter([state.products.last.id]).get();
        // moreProducts =
        //     snapshot.docs.map((e) => Product.fromDocumentSnapshot(e)).toList();
      } else {
        response = await _prodFunction.call({"lastProductId": state.products.last.id});
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
  fetchSpecificBrandProducts(String brandId) async {
    emit(state.copyWith(appStatus: AppStatus.loading));
    try {
      final HttpsCallableResult response = brandId != "-1"
          ? await _prodFunction.call({"lastProductId": "", "brandId": brandId})
          : await _prodFunction.call({"lastProductId": "", });
      List<Product> products = (response.data as List)
          .map((prod) => Product.fromJson(prod))
          .toList();
      emit(state.copyWith(appStatus: AppStatus.success, products: products));
    } catch (e) {
      emit(state.copyWith(appStatus: AppStatus.failure, errorMessage: "$e"));
    }
  }

  ///
  applyFilter(FilterState filterState) async {
    print(filterState.selectedBrand?.id);
    print(filterState.selectedColor);
    print(filterState.selectedSortBy);
    print(filterState.selectedGender?.name.toUpperCase());
    print(
      filterState.selectedPriceRange?.start,
    );
    print(
      filterState.selectedPriceRange?.end,
    );
    emit(state.copyWith(
        appStatus: AppStatus.loading,
        selectedBrand: filterState.selectedBrand));

    late Query<Map<String, dynamic>> query;
    if (filterState.selectedSortBy == SortBy.lowPrice) {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .orderBy("price", descending: false)
          .where("gender",
              isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price",
              isLessThanOrEqualTo: filterState.selectedPriceRange?.end,
              isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
    } else if (filterState.selectedSortBy == SortBy.mostRecent) {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .orderBy("createdDate", descending: false)
          .where("gender",
              isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price",
              isLessThanOrEqualTo: filterState.selectedPriceRange?.end,
              isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
      //TODO: add highest reviews filter
    } else {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .where("gender",
              isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price",
              isLessThanOrEqualTo: filterState.selectedPriceRange?.end,
              isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
    }

    try {
      QuerySnapshot<Map<String, dynamic>> snapshots = await query.get();
      List<Product> products = snapshots.docs
          .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
          .toList();
      emit(state.copyWith(appStatus: AppStatus.success, products: products));
    } catch (e) {
      print(e);
      emit(state.copyWith(appStatus: AppStatus.failure, errorMessage: "$e"));
    }
  }

  loadMoreFilteredProducts(FilterState filterState) async {
    if (state.paginating || state.products.isEmpty) return;
    emit(state.copyWith(paginating: true));
    late Query<Map<String, dynamic>> query;
    if (filterState.selectedSortBy == SortBy.lowPrice) {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .orderBy("price", descending: false)
          .where("gender",
              isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price",
              isLessThanOrEqualTo: filterState.selectedPriceRange?.end,
              isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
    } else if (filterState.selectedSortBy == SortBy.mostRecent) {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .orderBy("createdDate", descending: false)
          .where("gender",
              isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price",
              isLessThanOrEqualTo: filterState.selectedPriceRange?.end,
              isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
      //TODO: add highest reviews filter
    } else {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .where("gender",
              isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price",
              isLessThanOrEqualTo: filterState.selectedPriceRange?.end,
              isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
    }

    try {
      QuerySnapshot<Map<String, dynamic>> snapshots =
          await query.orderBy("id").startAfter([state.products.last.id]).get();
      List<Product> moreProducts = snapshots.docs
          .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
          .toList();
      List<Product> products = [...state.products];
      products.addAll(moreProducts);
      emit(state.copyWith(products: products));
    } catch (e) {
      print(e);
    } finally {
      emit(state.copyWith(paginating: false));
    }
  }
}
