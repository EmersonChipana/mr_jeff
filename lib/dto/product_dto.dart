import 'package:mr_jeff/dto/service_dto.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final String image;
  final double price;
  final List<Service> services;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.services,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      services:
          (json['services'] as List).map((e) => Service.fromJson(e)).toList(),
    );
  }
}
