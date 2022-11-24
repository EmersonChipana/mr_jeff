import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/order/order_state.dart';
import 'package:mr_jeff/model/delivery_model/clothing_order_model.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderState(isLoading: true));

  Future<void> loadInitialData(List<bool> services) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      emit(state.copyWith(servicesSelected: services));
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> updateServicesSelected(bool newState, int index) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      final services = state.servicesSelected;
      services[index] = newState;
      emit(state.copyWith(servicesSelected: services));
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> addClothing(ClothingOrderModel clothing) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      if (state.empty) {
        List<ClothingOrderModel> clothes = [clothing];
        emit(state.copyWith(clothes: clothes));
      } else {
        List<ClothingOrderModel> clothes = state.clothes;
        clothes.add(clothing);
        emit(state.copyWith(clothes: clothes));
      }
      emit(state.copyWith(empty: false, isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> removeClothing(int index) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      List<ClothingOrderModel> clothes = state.clothes;
      clothes.removeAt(index);
      emit(state.copyWith(clothes: clothes));
      if (clothes.isEmpty) {
        emit(state.copyWith(empty: true));
      }
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> updateClothing(ClothingOrderModel clothing, int index) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      List<ClothingOrderModel> clothes = state.clothes;
      clothes[index] = clothing;
      emit(state.copyWith(clothes: clothes));
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> setTotal(double total) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      emit(state.copyWith(total: state.total + total));
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
