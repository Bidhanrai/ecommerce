import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import 'package:shoes_ecommerce/features/filter/cubit/filter_cubit.dart';
import 'package:shoes_ecommerce/features/product/models/product.dart';
import 'package:shoes_ecommerce/utils/toast_message.dart';
import '../../filter/cubit/filter_state.dart';
import '../model/brand.dart';
import 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit(): super(const DiscoverState()) {
    fetchProductsAndBrands();
  }


  final _productRef = FirebaseFirestore.instance.collection("products").limit(10);
  final _brandsRef = FirebaseFirestore.instance.collection("brands");

  selectBrand(Brand brand) {
    emit(state.copyWith(selectedBrand: brand));
    fetchSpecificBrandProducts(brand.id);
  }

  ///Fetching all products, brand list
  fetchProductsAndBrands() async {
    emit(state.copyWith(appStatus: AppStatus.loading, selectedBrand: const Brand(id: "-1", name: "All", image: "")));
    try {
      List<QuerySnapshot<Map<String, dynamic>>> snapshots = await Future.wait([_productRef.get(), _brandsRef.get()]);
      List<Product> products = snapshots[0].docs.map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot)).toList();
      List<Brand> brands = snapshots[1].docs.map((docSnapshot) => Brand.fromDocumentSnapshot(docSnapshot)).toList();
      emit(state.copyWith(appStatus: AppStatus.success, brands: brands, products: products));
    } catch(e) {
      emit(state.copyWith(appStatus: AppStatus.failure, errorMessage: "$e"));
    }
  }

  loadMoreProducts() async {
    if(state.paginating || state.products.isEmpty) return;
    emit(state.copyWith(paginating: true));
    try {
      late QuerySnapshot<Map<String, dynamic>> snapshot;
      if(state.selectedBrand.id != "-1") {
        snapshot = await _productRef.where("brand", isEqualTo: state.selectedBrand.id).orderBy("id").startAfter([state.products.last.id]).get();
      } else {
        snapshot = await _productRef.orderBy("id").startAfter([state.products.last.id]).get();
      }
      List<Product> moreProducts = snapshot.docs.map((e) => Product.fromDocumentSnapshot(e)).toList();
      List<Product> products = [...state.products];
      products.addAll(moreProducts);
      emit(state.copyWith(products: products));
    } catch(e) {
      debugPrint("$e");
    } finally {
      emit(state.copyWith(paginating: false));
    }

  }

  ///Fetching products of a specific brand
  fetchSpecificBrandProducts(String brandId) async {
    emit(state.copyWith(appStatus: AppStatus.loading));
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = brandId != "-1"
          ? await _productRef.where("brand", isEqualTo: brandId).get()
          : await _productRef.get();
      List<Product> products = snapshot.docs.map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot)).toList();
      emit(state.copyWith(appStatus: AppStatus.success, products: products));
    } catch(e) {
      emit(state.copyWith(appStatus: AppStatus.failure, errorMessage: "$e"));
    }
  }


  ///
  applyFilter(FilterState filterState) async {
    print(filterState.selectedBrand?.id);
    print(filterState.selectedColor);
    print(filterState.selectedSortBy);
    print(filterState.selectedGender?.name.toUpperCase());
    print(filterState.selectedPriceRange?.start,);
    print(filterState.selectedPriceRange?.end,);
    emit(state.copyWith(appStatus: AppStatus.loading, selectedBrand: filterState.selectedBrand));

    late Query<Map<String, dynamic>> query;
    if(filterState.selectedSortBy == SortBy.lowPrice) {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .orderBy("price", descending: false)
          .where("gender", isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price", isLessThanOrEqualTo: filterState.selectedPriceRange?.end, isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
    } else if(filterState.selectedSortBy == SortBy.mostRecent) {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .orderBy("createdDate", descending: false)
          .where("gender", isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price", isLessThanOrEqualTo: filterState.selectedPriceRange?.end, isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
    //TODO: add highest reviews filter
    } else {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .where("gender", isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price", isLessThanOrEqualTo: filterState.selectedPriceRange?.end, isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
    }

    try {
      QuerySnapshot<Map<String, dynamic>> snapshots = await query.get();
      List<Product> products = snapshots.docs.map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot)).toList();
      emit(state.copyWith(appStatus: AppStatus.success, products: products));
    } catch(e) {
      print(e);
      emit(state.copyWith(appStatus: AppStatus.failure, errorMessage: "$e"));
    }
  }


  loadMoreFilteredProducts(FilterState filterState) async {
    if(state.paginating || state.products.isEmpty) return;
    emit(state.copyWith(paginating: true));
    late Query<Map<String, dynamic>> query;
    if(filterState.selectedSortBy == SortBy.lowPrice) {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .orderBy("price", descending: false)
          .where("gender", isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price", isLessThanOrEqualTo: filterState.selectedPriceRange?.end, isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
    } else if(filterState.selectedSortBy == SortBy.mostRecent) {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .orderBy("createdDate", descending: false)
          .where("gender", isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price", isLessThanOrEqualTo: filterState.selectedPriceRange?.end, isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
      //TODO: add highest reviews filter
    } else {
      query = _productRef
          .where("brand", isEqualTo: filterState.selectedBrand?.id)
          .where("color", arrayContains: filterState.selectedColor)
          .where("gender", isEqualTo: filterState.selectedGender?.name.toUpperCase())
          .where("price", isLessThanOrEqualTo: filterState.selectedPriceRange?.end, isGreaterThanOrEqualTo: filterState.selectedPriceRange?.start);
    }

    try {
      QuerySnapshot<Map<String, dynamic>> snapshots = await query.orderBy("id").startAfter([state.products.last.id]).get();
      List<Product> moreProducts = snapshots.docs.map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot)).toList();
      List<Product> products = [...state.products];
      products.addAll(moreProducts);
      emit(state.copyWith(products: products));
    } catch(e) {
      print(e);
    } finally {
      emit(state.copyWith(paginating: false));
    }
  }
}