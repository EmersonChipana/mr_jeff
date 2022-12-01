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
    screenCubit.loadInitialData();
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
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancelar")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/setAddressDelivery");
                },
                child: const Text("Continuar")),
          ]),
        ));
  }

  Widget buildBody(ClothingsOrderState state) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: const Center(
              child: Text("Tus productos",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
        ),
        for (final clothing in state.clothings)
          ClothingsOfOrderCard(
            quantity: clothing.quantity,
            title: clothing.title,
            total: clothing.total,
            image: clothing.image,
          ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.all(15),
          child: Text("Total:    ${state.total} bs.",
              style: const TextStyle(
                fontSize: 20,
              )),
        )
      ],
    );
  }
}
