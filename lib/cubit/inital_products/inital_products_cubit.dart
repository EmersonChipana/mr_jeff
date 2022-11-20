import 'dart:html';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mr_jeff/cubit/inital_products/inital_products_state.dart';
import 'package:mr_jeff/service/category_service.dart';

class InitalProductsCubit extends Cubit<InitalProductsState> {
  InitalProductsCubit() : super(InitalProductsState(isLoading: true));

  Future<void> loadInitialData() async {
    final stableState = state;
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: "TOKEN");
    try {
      emit(state.copyWith(isLoading: true));
      if(token != null){
        final categories = await CategoryService().getCategories(token);
        emit(state.copyWith(categories: categories));
      }else{
        emit(state.copyWith(error: "Usuario no autenticado"));
      }
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
