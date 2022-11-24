import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/products/products_cubit.dart';
import 'package:mr_jeff/cubit/products/products_state.dart';
import 'package:mr_jeff/widget/product_card.dart';

class PageOfProducts extends StatelessWidget {
  final int categoryId;

  PageOfProducts({Key? key, required this.categoryId}) : super(key: key);

  final screenCubit = ProductsCubit();

  @override
  Widget build(BuildContext context) {
    screenCubit.loadCategoryProducts(categoryId);
    return BlocConsumer<ProductsCubit, ProductsState>(
      bloc: screenCubit,
      listener: (BuildContext context, ProductsState state) {
        if (state.error != null) {
          print("Error Producto");
        }
      },
      builder: (BuildContext context, ProductsState state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                  title: state.products[index].title,
                  price: state.products[index].price,
                  imageUrl: state.products[index].image,
                  id: state.products[index].id,
                  service: state.products[index].services);
            });
      },
    );
  }
}
