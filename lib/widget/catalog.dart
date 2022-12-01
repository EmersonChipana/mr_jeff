import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/inital_products/inital_products_cubit.dart';
import 'package:mr_jeff/cubit/inital_products/inital_products_state.dart';
import 'package:mr_jeff/widget/page_of_products.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final screenCubit = InitalProductsCubit()..loadInitialData();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InitalProductsCubit, InitalProductsState>(
      bloc: screenCubit,
      listener: (BuildContext context, InitalProductsState state) {
        if (state.error != null) {
          // TODO your code here
          print("Error");
        }
      },
      builder: (BuildContext context, InitalProductsState state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return DefaultTabController(
            length: screenCubit.state.categories.length,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Catálogo de productos'),
                bottom: TabBar(
                  isScrollable: true,
                  tabs: screenCubit.state.categories
                      .map((category) => Tab(text: category.category))
                      .toList(),
                ),
              ),
              body: TabBarView(
                children: screenCubit.state.categories
                    .map((category) => PageOfProducts(
                          categoryId: category.id ?? 1,
                          isOrder: false,
                        ))
                    .toList(),
              ),
              bottomNavigationBar: Container(
                margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/prepickupv2");
                  },
                  child: const Text('Solicitar servicio!'),
                ),
              ),
            ));
      },
    );
  }
}
