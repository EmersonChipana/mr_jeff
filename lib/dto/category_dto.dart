class CategoryDto {
  final int? id;
  final String? category;

  CategoryDto({this.id, this.category});

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: json['categoryClothId'],
      category: json['category'],
    );
  }
}
