class ClothingOrderDto {
  final double price;
  final int quantity;
  final int idClothing;
  final int idOrder;

  ClothingOrderDto(
      {required this.price,
      required this.quantity,
      required this.idClothing,
      required this.idOrder});

  Map<String, dynamic> toJson() => {
        'price': price,
        'quantity': quantity,
        'idClothing': idClothing,
        'idOrder': idOrder,
      };
}
