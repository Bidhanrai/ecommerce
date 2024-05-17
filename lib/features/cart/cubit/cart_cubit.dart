import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_ecommerce/features/discover/model/product.dart';
import 'package:shoes_ecommerce/services/auth_service.dart';
import '../../../constants/app_status.dart';
import '../../../services/service_locator.dart';
import '../model/cart.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(String? uid): super(const CartState()) {
   fetchCart(uid);
  }

  final _db = FirebaseFirestore.instance;

  List<Product> productInCart = [];
  List<String> productIdList = [];
  fetchCart(String? uid) async {
    productInCart = [];
    productIdList = [];
    emit(state.copyWith(appStatus: AppStatus.loading));
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _db.collection("carts").doc(uid).get();
      if(documentSnapshot.exists) {
        Cart cart = Cart.fromDocumentSnapshot(documentSnapshot);
        for(var product in cart.cartDataList) {
          DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection("products").doc(product.productId).get();
          productInCart.add(Product.fromDocumentSnapshot(snapshot));
        }
        productIdList = productInCart.map((e) => e.id).toList();
        emit(state.copyWith(appStatus: AppStatus.success, cart: cart));
      } else {
        emit(state.copyWith(appStatus: AppStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(appStatus: AppStatus.failure, errorMessage: "$e"));
    }
  }

  int get totalPrice {
    if(state.cart != null && state.cart!.cartDataList.isNotEmpty) {
      List<int> price = state.cart!.cartDataList.map((e) => e.quantity * productInCart[state.cart!.cartDataList.indexOf(e)].price).toList();
      return price.sum;
    } else {
      return 0;
    }
  }

  addQuantity(String productId) {
    try {
      CartData cartData = state.cart!.cartDataList.singleWhere((element) => element.productId == productId);
      CartData updatedCartData = cartData.copyWith(quantity: cartData.quantity+1);

      List<CartData> cartDataList = List.of(state.cart!.cartDataList);
      int index = cartDataList.indexOf(cartData);
      cartDataList.removeAt(index);
      cartDataList.insert(index, updatedCartData);
      emit(state.copyWith(cart: Cart(cartDataList: cartDataList)));
      _updateQuantity();
    } catch(e) {
      debugPrint("$e");
    }
  }

  subtractQuantity(String productId) {
    try {
      CartData cartData = state.cart!.cartDataList.singleWhere((element) => element.productId == productId);
      if(cartData.quantity==1) {
        return;
      }
      CartData updatedCartData = cartData.copyWith(quantity: cartData.quantity-1);

      List<CartData> cartDataList = List.of(state.cart!.cartDataList);
      int index = cartDataList.indexOf(cartData);
      cartDataList.removeAt(index);
      cartDataList.insert(index, updatedCartData);
      emit(state.copyWith(cart: Cart(cartDataList: cartDataList)));
      _updateQuantity();
    } catch(e) {
      debugPrint("$e");
    }
  }

  _updateQuantity() {
    CollectionReference carts = _db.collection('carts');
    return carts
        .doc(locator<AuthService>().user?.uid)
        .set({
          "data": FieldValue.arrayUnion(state.cart!.cartDataList.map((e) => e.toJson()).toList())
        })
        .then((value) => debugPrint("Cart Updated successfully!"))
        .catchError((error) => debugPrint("Failed to update cart: $error"));
  }

  removeProduct(CartData cartData) {
    emit(state.copyWith(isBusy: true));
    CollectionReference carts = _db.collection('carts');
    return carts.doc(locator<AuthService>().user?.uid).set({
      "data": FieldValue.arrayRemove([cartData.toJson()])
    }, SetOptions(merge: true)).then(
      (value) {
        List<CartData> productList = List.of(state.cart!.cartDataList);
        productList.remove(cartData);
        productInCart.removeWhere((element) => cartData.productId == element.id);
        productIdList.removeWhere((element) => cartData.productId == element);
        emit(state.copyWith(cart: Cart(cartDataList: productList)));
      },
    ).catchError((error) {
      debugPrint("Failed to add: $error");
    }).whenComplete(() => emit(state.copyWith(isBusy: false)));
  }

  clearCart() {
    CollectionReference carts = _db.collection('carts');
    carts
        .doc(locator<AuthService>().user?.uid)
        .set({"data": []})
        .then((value) => emit(state.copyWith(cart: const Cart(cartDataList: []))))
        .catchError((error) => debugPrint("Failed to clear cart: $error"));
  }
}