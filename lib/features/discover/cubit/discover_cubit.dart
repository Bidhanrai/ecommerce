import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import 'package:shoes_ecommerce/features/discover/model/product.dart';
import '../model/brand.dart';
import 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit(): super(const DiscoverState()) {
    fetchProductsAndBrands();
  }

  final _db = FirebaseFirestore.instance;

  selectBrand(Brand brand) {
    emit(state.copyWith(selectedBrand: brand));
    fetchSpecificBrandProducts(brand.id);
  }

  fetchProductsAndBrands() async {
    emit(state.copyWith(appStatus: AppStatus.loading));
    try {
      List<QuerySnapshot<Map<String, dynamic>>> snapshots = await Future.wait([_db.collection("products").get(), _db.collection("brands").get()]);
      List<Product> products = snapshots[0].docs.map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot)).toList();
      List<Brand> brands = snapshots[1].docs.map((docSnapshot) => Brand.fromDocumentSnapshot(docSnapshot)).toList();
      brands.insert(0, const Brand(id: "-1", name: "All", image: ""));
      emit(state.copyWith(appStatus: AppStatus.success, brands: brands, products: products));
    } catch(e) {
      emit(state.copyWith(appStatus: AppStatus.failure));
    }
  }

  fetchSpecificBrandProducts(String brandId) async {
    emit(state.copyWith(appStatus: AppStatus.loading));
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = brandId != "-1"
          ? await _db.collection("products").where("brand", isEqualTo: brandId).get()
          : await _db.collection("products").get();
      List<Product> products = snapshot.docs.map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot)).toList();
      emit(state.copyWith(appStatus: AppStatus.success, products: products));
    } catch(e) {
      emit(state.copyWith(appStatus: AppStatus.failure));
    }
  }
}