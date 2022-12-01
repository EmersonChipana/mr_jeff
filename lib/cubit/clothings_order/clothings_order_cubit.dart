import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/clothings_order/clothings_order_state.dart';
import 'package:mr_jeff/service/delivery_service.dart';

class ClothingsOrderCubit extends Cubit<ClothingsOrderState> {
  ClothingsOrderCubit() : super(ClothingsOrderState(isLoading: true));

  Future<void> loadInitialData() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      try {
        final clothings =
            await DeliveryService().getClothingsOrder(state.id ?? 1);
        emit(state.copyWith(clothings: clothings));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }

      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> setTotal() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      double total = 0;
      for (var element in state.clothings) {
        total += element.total;
      }
      emit(state.copyWith(total: total));
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> setIdOrder(int id) async {
    emit(state.copyWith(id: id));
  }
}
