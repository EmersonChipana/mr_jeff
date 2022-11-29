import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/clothings_order/clothings_order_cubit.dart';
import 'package:mr_jeff/cubit/clothings_order/clothings_order_state.dart';
import 'package:mr_jeff/widget/clothings_of_order_card.dart';

class ClothingsOrderScreen extends StatefulWidget {
  const ClothingsOrderScreen({super.key});

  @override
  State<ClothingsOrderScreen> createState() => _ClothingsOrderScreenState();
}

class _ClothingsOrderScreenState extends State<ClothingsOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final screenCubit = BlocProvider.of<ClothingsOrderCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedido"),
      ),
      body: BlocConsumer<ClothingsOrderCubit, ClothingsOrderState>(
          bloc: screenCubit,
          listener: (BuildContext context, ClothingsOrderState state) {
            if (state.error != null) {
              // TODO your code here
            }
          },
          builder: (BuildContext context, ClothingsOrderState state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return buildBody(state);
            }
          }),
      bottomNavigationBar:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar")),
        ElevatedButton(
            onPressed: () {
              // TODO your code here
            },
            child: const Text("Continuar")),
      ]),
    );
  }

  Widget buildBody(ClothingsOrderState state) {
    double total = 0;
    for (final clothing in state.clothings) {
      total += clothing.total;
    }
    return ListView(
      children: [
        const Center(child: Text("Tus productos")),
        for (final clothing in state.clothings)
          ClothingsOfOrderCard(
            quantity: clothing.quantity,
            title: clothing.title,
            total: clothing.total,
            image: clothing.image,
          ),
        Text("Total: $total bs.",
            style: const TextStyle(
              fontSize: 20,
            )),
      ],
    );
  }
}
