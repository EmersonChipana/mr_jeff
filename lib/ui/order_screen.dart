import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/order/order_cubit.dart';
import 'package:mr_jeff/cubit/order/order_state.dart';

class OrderScreen extends StatefulWidget {
	const OrderScreen({Key? key}) : super(key: key);
	
	@override
	_OrderScreenState createState() => _OrderScreenState();
}
	
class _OrderScreenState extends State<OrderScreen> {
	final screenCubit = OrderCubit();
	
	@override
	void initState() {
		screenCubit.loadInitialData();
		super.initState();
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: BlocConsumer<OrderCubit, OrderState>(
				bloc: screenCubit,
				listener: (BuildContext context, OrderState state) {
					if (state.error != null) {
						// TODO your code here
					}
				},
				builder: (BuildContext context, OrderState state) {
					if (state.isLoading) {
						return const Center(child: CircularProgressIndicator());
					}
	
					return buildBody(state);
				},
			),
		);
	}
	
	Widget buildBody(OrderState state) {
		return ListView(
			children: [
				// TODO your code here
			],
		);
	}
}
