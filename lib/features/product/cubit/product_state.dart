import 'package:equatable/equatable.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import '../models/product.dart';
import '../../review/model/review.dart';

class ProductState extends Equatable {
  final Product product;
  final AppStatus reviewStatus;
  final String? errorMessage;
  final List<Review> reviews;
  final double averageRating;
  final int quantity;
  final int productSize;
  final String productColor;

  const ProductState({
    this.reviews = const [],
    this.reviewStatus = AppStatus.init,
    this.averageRating = 0,
    required this.quantity,
    required this.productSize,
    required this.productColor,
    required this.product,
    this.errorMessage,
  });

  ProductState copyWith({
    AppStatus? reviewStatus,
    List<Review>? reviews,
    double? averageRating,
    int? productSize,
    String? productColor,
    int? quantity,
    Product? product,
    String? errorMessage,
  }) {
    return ProductState(
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviews: reviews ?? this.reviews,
      averageRating: averageRating ?? this.averageRating,
      productSize: productSize ?? this.productSize,
      productColor: productColor ?? this.productColor,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [reviews, reviewStatus, averageRating, productSize, productColor, quantity, product, errorMessage];
}
