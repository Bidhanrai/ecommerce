import 'package:equatable/equatable.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import 'package:shoes_ecommerce/features/discover/model/brand.dart';
import '../../product/models/product.dart';

class DiscoverState extends Equatable {
  final AppStatus appStatus;
  final String? errorMessage;
  final bool paginating;
  final Brand selectedBrand;
  final List<Brand> brands;
  final List<Product> products;

  const DiscoverState({
    this.selectedBrand = const Brand(id: "-1", name: "All", image: ""),
    this.products = const [],
    this.appStatus = AppStatus.init,
    this.brands = const [],
    this.paginating = false,
    this.errorMessage,
  });

  DiscoverState copyWith({
    AppStatus? appStatus,
    Brand? selectedBrand,
    List<Product>? products,
    List<Brand>? brands,
    bool? paginating,
    String? errorMessage,
  }) {
    return DiscoverState(
      appStatus: appStatus ?? this.appStatus,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      products: products ?? this.products,
      brands: brands ?? this.brands,
      paginating: paginating ?? this.paginating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedBrand, products, brands, appStatus, paginating, errorMessage];
}
