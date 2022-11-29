import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/clothings_order/clothings_order_state.dart';
import 'package:mr_jeff/model/delivery_model/clothings_list_order_model.dart';
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
}
