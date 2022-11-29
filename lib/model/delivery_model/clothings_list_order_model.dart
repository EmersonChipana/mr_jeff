class ClothingsListOrderModel {
  final int quantity;
  final String title;
  final double total;
  final String image;

  ClothingsListOrderModel({
    required this.quantity,
    required this.title,
    required this.total,
    required this.image,
  });

  factory ClothingsListOrderModel.fromJson(Map<String, dynamic> json) =>
      ClothingsListOrderModel(
        quantity: json["quantity"],
        title: json["title"],
        total: json["total"],
        image: json["url"],
      );
}
