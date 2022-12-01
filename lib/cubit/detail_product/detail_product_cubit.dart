import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/detail_product/detail_product_state.dart';
import 'package:mr_jeff/service/clothing_service.dart';

class DetailProductCubit extends Cubit<DetailProductState> {
  DetailProductCubit() : super(DetailProductState(isLoading: true));

  Future<void> loadInitialData() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> loadClothing(int id) async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      try {
        final clothing = await ClothingService().getClothingById(id);
        emit(state.copyWith(clothing: clothing));
      } catch (error) {
        emit(state.copyWith(error: "Error al cargar la prenda"));
      }
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
