import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/detail_product/detail_product_cubit.dart';
import 'package:mr_jeff/cubit/order/order_cubit.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;
  final double price;
  final String service;

  ProductCard(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.price,
      required this.id,
      required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 60, top: 10, bottom: 10),
                width: 100,
                height: 100,
                child: Image.network(imageUrl)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                  Text("$price bs.", style: const TextStyle(fontSize: 15)),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(service, style: const TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () async {
        final cubit = BlocProvider.of<DetailProductCubit>(context);
        await cubit.loadClothing(id);
        final order = BlocProvider.of<OrderCubit>(context);
        List<bool> stateServices = [];
        for (var element in cubit.state.clothing!.services) {
          if (element.principalService == 1) {
            stateServices.add(true);
          } else {
            stateServices.add(false);
          }
        }
        order.loadInitialData(stateServices);
        Navigator.pushNamed(context, "/clothing", arguments: {"id": id});
      },
    );
  }
}
