import 'package:mr_jeff/dto/service_dto.dart';

class ClothingOrderModel {
  final int id;
  final String title;
  final double price;
  final String image;
  int quantity;
  final List<ServiceDto> services;

  ClothingOrderModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
    required this.services,
  });

  setQuantity(int quantity) {
    this.quantity = quantity;
  }
}
