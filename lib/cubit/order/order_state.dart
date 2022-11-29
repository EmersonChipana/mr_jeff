import 'package:mr_jeff/model/delivery_model/clothing_order_model.dart';

class OrderState {
  final bool isLoading;
  final String? error;
  final List<ClothingOrderModel> clothes;
  final List<bool> servicesSelected;
  final bool empty;
  final double total;
  final bool submit;

  OrderState(
      {this.isLoading = false,
      this.error,
      this.clothes = const [],
      this.servicesSelected = const [],
      this.empty = true,
      this.total = 0,
      this.submit = false});

  OrderState copyWith(
      {bool? isLoading,
      String? error,
      List<ClothingOrderModel>? clothes,
      List<bool>? servicesSelected,
      bool? empty,
      bool? success,
      double? total,
      bool? submit}) {
    return OrderState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        clothes: clothes ?? this.clothes,
        servicesSelected: servicesSelected ?? this.servicesSelected,
        empty: empty ?? this.empty,
        total: total ?? this.total,
        submit: submit ?? this.submit);
  }
}
