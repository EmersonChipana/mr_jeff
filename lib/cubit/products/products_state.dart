import 'package:mr_jeff/dto/product_dto.dart';

class ProductsState {
  final bool isLoading;
  final String? error;
  final List<Product> products;

  const ProductsState({
    this.isLoading = false,
    this.error,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLoading,
    String? error,
    List<Product>? products,
  }) {
    return ProductsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      products: products ?? this.products,
    );
  }
}
