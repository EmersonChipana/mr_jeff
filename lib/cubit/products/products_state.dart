import 'package:mr_jeff/dto/clothing_card_dto.dart';

class ProductsState {
  final bool isLoading;
  final String? error;
  final List<ClothingCardDto> products;

  const ProductsState({
    this.isLoading = false,
    this.error,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLoading,
    String? error,
    List<ClothingCardDto>? products,
  }) {
    return ProductsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      products: products ?? this.products,
    );
  }
}
