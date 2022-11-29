import 'package:flutter/material.dart';

class ClothingsOfOrderCard extends StatelessWidget {
  final int quantity;
  final String title;
  final double total;
  final String image;

  const ClothingsOfOrderCard({
    Key? key,
    required this.quantity,
    required this.title,
    required this.total,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text("$quantity"),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: NetworkImage(image)),
              ),
            ),
            Center(child: Text(title)),
            Center(child: Text("$total")),
          ],
        ));
  }
}
