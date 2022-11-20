import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;
  final double price;

  ProductCard(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.price,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          Image(
            image: NetworkImage(imageUrl),
            width: 100,
            height: 100,
          ),
          Column(
            children: [
              Center(
                child: Text(title),
              ),
              Text("${price}bs."),
            ],
          ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, "/product", arguments: id);
      },
    );
  }
}
