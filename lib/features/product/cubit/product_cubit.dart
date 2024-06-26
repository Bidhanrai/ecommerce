import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/app_status.dart';
import '../../../services/auth_service.dart';
import '../../../services/service_locator.dart';
import '../../cart/model/cart.dart';
import '../../review/model/review.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(super.initialState);

  final _reviewRef = FirebaseFirestore.instance.collection("reviews");
  final _cartRef = FirebaseFirestore.instance.collection("carts");

  fetchReviews(String docId) async {
    emit(state.copyWith(reviewStatus: AppStatus.loading));
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _reviewRef.doc(docId).get();
      if(documentSnapshot.data() != null) {
        List<Review> reviews = (documentSnapshot.data()!["data"] as List)
            .map((docSnapshot) => Review.fromJson(docSnapshot))
            .toList();
        emit(state.copyWith(reviewStatus: AppStatus.success, reviews: reviews));
      } else {
        emit(state.copyWith(reviewStatus: AppStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(reviewStatus: AppStatus.failure, errorMessage: "$e"));
    }
  }


  selectColor(String color) {
    emit(state.copyWith(productColor: color));
  }
  selectSize(int size) {
    emit(state.copyWith(productSize: size));
  }
  addQuantity(int value) {
    emit(state.copyWith(quantity: value));
  }

  addToCart(VoidCallback onSuccess) async {
    return await _cartRef.doc(locator<AuthService>().user?.uid).set({
      "data": FieldValue.arrayUnion([CartData(quantity: state.quantity, size: state.productSize, color: state.productColor, productId: state.product.id).toJson()])
    }, SetOptions(merge: true)).then(
          (value) {
            onSuccess();
      },
    ).catchError((error) {
      debugPrint("Failed to add: $error");
    });
  }
}
