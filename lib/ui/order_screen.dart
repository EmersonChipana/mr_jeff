import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/order/order_cubit.dart';
import 'package:mr_jeff/cubit/order/order_state.dart';
import 'package:mr_jeff/widget/clothing_order_card.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  double total = 0;

  @override
  Widget build(BuildContext context) {
    final screenCubit = BlocProvider.of<OrderCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedido"),
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        bloc: screenCubit,
        listener: (BuildContext context, OrderState state) {
          if (state.error != null) {}
        },
        builder: (BuildContext context, OrderState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.empty) {
            return const Center(child: Text("El carrito está vacío"));
          }
          return buildBody(state);
        },
      ),
      bottomNavigationBar: screenCubit.state.empty
          ? Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Agregar más productos"),
              ),
            )
          : Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  screenCubit.addAllClothings();
                  Navigator.pushNamed(context, "/home");
                },
                child: const Text("Confirmar pedido"),
              ),
            ),
    );
  }

  Widget buildBody(OrderState state) {
    return ListView(
      children: [
        Container(
            margin: const EdgeInsets.all(10),
            child: const Center(
                child: Text("Lista de Productos",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
        ListView.builder(
          shrinkWrap: true,
          itemCount: state.clothes.length,
          itemBuilder: (context, index) {
            return ClothingOrderCard(id: index);
          },
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 80),
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Agregar más productos")),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("${setTotal(state)} bs.",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  setTotal(OrderState state) {
    total = 0;
    for (var i = 0; i < state.clothes.length; i++) {
      total += state.clothes[i].price * state.clothes[i].quantity;
    }
    return total;
  }
}
