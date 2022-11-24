class ClothingCardDto {
  final int id;
  final String title;
  final String image;
  final double price;
  final String services;

  ClothingCardDto({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.services,
  });

  factory ClothingCardDto.fromJson(Map<String, dynamic> json) {
    return ClothingCardDto(
      id: json['clothingId'],
      title: json['title'],
      image: json['img'],
      price: json['price'],
      services: json['service'],
    );
  }
}
