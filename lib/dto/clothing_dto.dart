import 'package:mr_jeff/dto/image_dto.dart';
import 'package:mr_jeff/dto/service_dto.dart';

class ClothingDto {
  final int id;
  final String title;
  final String description;
  final double price;
  final List<ImageDto> images;
  final List<ServiceDto> services;

  ClothingDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.services,
  });


  factory ClothingDto.fromJson(Map<String, dynamic> json) {
    return ClothingDto(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      images: (json['images'] as List)
          .map((e) => ImageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      services: (json['services'] as List)
          .map((e) => ServiceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'ClothingDto{id: $id, title: $title, description: $description, price: $price, images: $images, services: $services}';
  }
}
