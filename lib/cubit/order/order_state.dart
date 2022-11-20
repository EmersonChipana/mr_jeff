import 'package:mr_jeff/dto/product_dto.dart';

class OrderState {
  final bool isLoading;
  final String? error;

  final List<Product> products;

  const OrderState({
    this.isLoading = false,
    this.error,
    this.products = const [],
  });

  OrderState copyWith({
    bool? isLoading,
    String? error,
    List<Product>? products,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      products: products ?? this.products,
    );
  }
}

