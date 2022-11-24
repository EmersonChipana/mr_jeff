import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/order/order_cubit.dart';
import 'package:mr_jeff/cubit/order/order_state.dart';
import 'package:mr_jeff/model/delivery_model/clothing_order_model.dart';

class ClothingOrderCard extends StatefulWidget {
  final int id;

  ClothingOrderCard({
    Key? key,
    required this.id,
  });

  @override
  State<ClothingOrderCard> createState() => _ClothingOrderCardState();
}

class _ClothingOrderCardState extends State<ClothingOrderCard> {
  @override
  Widget build(BuildContext context) {
    final order = BlocProvider.of<OrderCubit>(context);
    final clothing = order.state.clothes[widget.id];
    return Container(
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
        margin: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            margin: const EdgeInsets.all(10),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: NetworkImage(clothing.image)),
            ),
          ),
          Column(
            children: [
              Text(clothing.title),
              Text("${clothing.price * clothing.quantity} bs."),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: clothing.services
                    .map((e) => Container(
                          margin: const EdgeInsets.only(right: 2),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            e.detTitle,
                            style: const TextStyle(fontSize: 8),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (clothing.quantity >= 1) {
                        clothing.quantity = clothing.quantity - 1;
                        order.updateClothing(clothing, widget.id);
                      }
                      if (clothing.quantity == 0) {
                        _showDialog(
                            context,
                            "Eliminar producto",
                            "¿Desea quitar el producto del carrito?",
                            order,
                            clothing);
                      }
                    });
                  },
                  icon: clothing.quantity > 1
                      ? const Icon(
                          Icons.remove,
                          color: Colors.grey,
                        )
                      : const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
              Text("${clothing.quantity}"),
              IconButton(
                  onPressed: () {
                    setState(() {
                      clothing.quantity = clothing.quantity + 1;
                      order.updateClothing(clothing, widget.id);
                    });
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.grey,
                  )),
            ],
          )
        ]));
  }

  Future<void> _showDialog(BuildContext context, String title, String message,
      OrderCubit order, ClothingOrderModel clothing) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  order.removeClothing(widget.id);
                  Navigator.of(context).pop();
                },
                child: const Text("Aceptar")),
            TextButton(
                onPressed: () {
                  clothing.quantity = 1;
                  order.updateClothing(clothing, widget.id);
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar")),
          ],
        );
      },
    );
  }
}
