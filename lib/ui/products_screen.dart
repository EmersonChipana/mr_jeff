import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/products/products_cubit.dart';
import 'package:mr_jeff/cubit/products/products_state.dart';

class ProductsScreen extends StatefulWidget {
	const ProductsScreen({Key? key}) : super(key: key);
	
	@override
	_ProductsScreenState createState() => _ProductsScreenState();
}
	
class _ProductsScreenState extends State<ProductsScreen> {
	final screenCubit = ProductsCubit();
	
	@override
	void initState() {
		screenCubit.loadInitialData();
		super.initState();
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: BlocConsumer<ProductsCubit, ProductsState>(
				bloc: screenCubit,
				listener: (BuildContext context, ProductsState state) {
					if (state.error != null) {
						// TODO your code here
					}
				},
				builder: (BuildContext context, ProductsState state) {
					if (state.isLoading) {
						return Center(child: CircularProgressIndicator());
					}
	
					return buildBody(state);
				},
			),
		);
	}
	
	Widget buildBody(ProductsState state) {
		return ListView(
			children: [
				// TODO your code here
			],
		);
	}
}
