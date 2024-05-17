import 'package:equatable/equatable.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import '../model/cart.dart';

class CartState extends Equatable {
  final AppStatus appStatus;
  final bool isBusy;
  final String? errorMessage;
  final Cart? cart;

  const CartState({
    this.cart,
    this.appStatus = AppStatus.init,
    this.errorMessage,
    this.isBusy = false,
  });

  CartState copyWith({
    AppStatus? appStatus,
    Cart? cart,
    String? errorMessage,
    bool? isBusy,
  }) {
    return CartState(
      appStatus: appStatus ?? this.appStatus,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
      isBusy: isBusy ?? this.isBusy,
    );
  }

  @override
  List<Object?> get props => [appStatus, cart, errorMessage, isBusy];
}
