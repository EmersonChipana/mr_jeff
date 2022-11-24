import 'package:mr_jeff/dto/clothing_dto.dart';

class DetailProductState {
  final bool isLoading;
  final String? error;
  final ClothingDto? clothing;
  final int? id;

  DetailProductState(
      {this.isLoading = false, this.error, this.clothing, this.id});

  DetailProductState copyWith(
      {bool? isLoading, String? error, ClothingDto? clothing, int? id}) {
    return DetailProductState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        clothing: clothing ?? this.clothing,
        id: id ?? this.id);
  }
}
