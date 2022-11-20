import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/inital_products/inital_products_cubit.dart';
import 'package:mr_jeff/cubit/inital_products/inital_products_state.dart';
import 'package:mr_jeff/widget/page_of_products.dart';

class InitalProductsScreen extends StatefulWidget {
  const InitalProductsScreen({Key? key}) : super(key: key);

  @override
  _InitalProductsScreenState createState() => _InitalProductsScreenState();
}

class _InitalProductsScreenState extends State<InitalProductsScreen> {
  final screenCubit = InitalProductsCubit()..loadInitialData();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: screenCubit.state.categories.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Mr. Jeff'),
            bottom: TabBar(
              isScrollable: true,
              tabs: screenCubit.state.categories
                  .map((category) => Tab(text: category.category))
                  .toList(),
            ),
          ),
          body: TabBarView(
            children: screenCubit.state.categories
                .map((category) => PageOfProducts(categoryId: category.id ?? 0))
                .toList(),
          ),
        ));
  }
}
