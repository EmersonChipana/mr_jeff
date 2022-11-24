import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mr_jeff/cubit/products/products_state.dart';
import 'package:mr_jeff/service/clothing_service.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(const ProductsState(isLoading: true));

  Future<void> loadInitialData() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      // TODO your code here

      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  Future<void> loadCategoryProducts(int categoryId) async {
    final stableState = state;
    const storage = FlutterSecureStorage();
    //String? token = await storage.read(key: "token");
    try {
      emit(state.copyWith(isLoading: true));
      /* if(token!=null){
        final products = await ProductService.getProductsByCategory(token, categoryId);
        emit(state.copyWith(products: products));
      }else{
        emit(state.copyWith(error: "Usuario no autenticado"));
      } */
      final products =
          await ClothingService().getClothingsByCategory(categoryId);
      emit(state.copyWith(products: products));
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
