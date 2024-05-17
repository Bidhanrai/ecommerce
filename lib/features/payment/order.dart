import 'package:equatable/equatable.dart';
import '../cart/model/cart.dart';

class OrderModel extends Equatable {
  final int totalPrice;
  final String userId;
  final String status;
  final List<CartData> products;

  const OrderModel({
    required this.totalPrice,
    required this.userId,
    required this.status,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalPrice': totalPrice,
      'userId': userId,
      'status': status,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [totalPrice, userId, status, products];
}


