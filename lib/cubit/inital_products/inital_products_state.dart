import 'package:mr_jeff/dto/category_dto.dart';
import 'package:mr_jeff/service/category_service.dart';

class InitalProductsState {
  final bool isLoading;
  final String? error;
  final List<CategoryDto> categories;

  const InitalProductsState({
    this.isLoading = false,
    this.error,
    this.categories = const [],
  });

  InitalProductsState copyWith({
    bool? isLoading,
    String? error,
    List<CategoryDto>? categories,
  }) {
    return InitalProductsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      categories: categories ?? this.categories,
    );
  }
}
