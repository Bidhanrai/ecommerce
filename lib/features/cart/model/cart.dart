import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final List<CartData> cartDataList;

  const Cart({
    required this.cartDataList,
  });

  factory Cart.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Cart(
      cartDataList: (doc.data()!["data"] as List).map((e) => CartData.fromDocumentSnapshot(e)).toList(),
    );
  }

  Cart copyWith({
    List<CartData>? cartDataList,
  }) {
    return Cart(
      cartDataList: cartDataList?? this.cartDataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': cartDataList.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [cartDataList];
}


class CartData extends Equatable {
  final String productId;
  final int size;
  final String color;
  final int quantity;

  const CartData({
    required this.productId,
    required this.size,
    required this.color,
    required this.quantity,
  });

  factory CartData.fromDocumentSnapshot(Map<String, dynamic> json) {
    return CartData(
      productId: json["productId"],
      size: json["size"],
      color: json["color"],
      quantity: json["quantity"],
    );
  }

  CartData copyWith({
    int? quantity,
  }) {
    return CartData(
      quantity: quantity ?? this.quantity,
      productId: productId,
      color: color,
      size: size,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "size": size,
      "color": color,
      "quantity": quantity,
    };
  }

  @override
  List<Object?> get props => [productId, size, color, quantity];
}
