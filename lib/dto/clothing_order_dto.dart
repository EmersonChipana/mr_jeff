class ClothingOrderDto {
  final double price;
  final String quantity;
  final int serviceId;
  final int orderId;

  ClothingOrderDto({
    required this.price,
    required this.quantity,
    required this.serviceId,
    required this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'quantity': quantity,
      'serviceId': serviceId,
      'orderId': orderId,
    };
  }
}
