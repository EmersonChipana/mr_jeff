class ImageDto {
  final int imageId;
  final String image;

  ImageDto({required this.imageId, required this.image});

  factory ImageDto.fromJson(Map<String, dynamic> json) {
    return ImageDto(
      imageId: json['imageId'],
      image: json['image'],
    );
  }
}
