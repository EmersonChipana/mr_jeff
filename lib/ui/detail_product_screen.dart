import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/detail_product/detail_product_cubit.dart';
import 'package:mr_jeff/cubit/detail_product/detail_product_state.dart';
import 'package:mr_jeff/cubit/order/order_cubit.dart';
import 'package:mr_jeff/dto/service_dto.dart';
import 'package:mr_jeff/model/delivery_model/clothing_order_model.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({Key? key}) : super(key: key);

  @override
  _DetailProductScreenState createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  int quantity = 1;
  double total = 0;

  @override
  Widget build(BuildContext context) {
    final screen = BlocProvider.of<DetailProductCubit>(context);
    final order = BlocProvider.of<OrderCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mr. Jeff"),
      ),
      body: BlocConsumer<DetailProductCubit, DetailProductState>(
        bloc: screen,
        listener: (BuildContext context, DetailProductState state) {
          if (state.error != null) {
            print("Error");
          }
        },
        builder: (BuildContext context, DetailProductState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return buildBody(state);
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              List<ServiceDto> list = [];
              double total = 0;
              for (int i = 0; i < order.state.servicesSelected.length; i++) {
                if (order.state.servicesSelected[i] == true) {
                  list.add(screen.state.clothing!.services[i]);
                  total += screen.state.clothing!.services[i].price;
                }
              }
              ClothingOrderModel clothing = ClothingOrderModel(
                  id: screen.state.clothing?.id ?? 0,
                  title: screen.state.clothing?.title ?? "",
                  price: total,
                  quantity: quantity,
                  image: screen.state.clothing?.images[0].image ?? "",
                  services: list);
              order.addClothing(clothing);
              order.setTotal(total);
              Navigator.pushNamed(context, "/clothings");
            });
          },
          child: const Text("Agregar al carrito"),
        ),
      ),
    );
  }

  Widget buildBody(DetailProductState state) {
    final order = BlocProvider.of<OrderCubit>(context);
    return ListView(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            itemCount: state.clothing?.images.length,
            pageSnapping: true,
            itemBuilder: (context, index) {
              return Container(
                  margin: const EdgeInsets.all(10),
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image:
                              NetworkImage(state.clothing!.images[index].image),
                        )),
                  ));
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Precio: ${state.clothing?.price} bs.",
              style: const TextStyle(fontSize: 20),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                          }
                        });
                      },
                      icon: const Icon(Icons.remove)),
                  Text(quantity.toString()),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: const Icon(Icons.add)),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            state.clothing?.title ?? "",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            state.clothing?.description ?? "",
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text("Servicios", style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.clothing?.services.length ?? 0,
          itemBuilder: (context, index) {
            return CheckboxListTile(
                value: order.state.servicesSelected[index],
                onChanged: (value) {
                  setState(() {
                    if (state.clothing?.services[index].principalService != 1) {
                      order.updateServicesSelected(value!, index);
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                    "${state.clothing?.services[index].detTitle} + ${state.clothing?.services[index].price} bs."));
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
