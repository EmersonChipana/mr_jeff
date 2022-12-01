import 'package:mr_jeff/model/delivery_model/clothings_list_order_model.dart';

class ClothingsOrderState {
  final bool isLoading;
  final String? error;
  final int? id;
  final List<ClothingsListOrderModel> clothings;
  final double total;

  const ClothingsOrderState({
    this.isLoading = false,
    this.error,
    this.clothings = const [],
    this.id,
    this.total = 0,
  });

  ClothingsOrderState copyWith({
    bool? isLoading,
    String? error,
    List<ClothingsListOrderModel>? clothings,
    int? id,
    double? total,
  }) {
    return ClothingsOrderState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      clothings: clothings ?? this.clothings,
      id: id ?? this.id,
      total: total ?? this.total,
    );
  }
}
