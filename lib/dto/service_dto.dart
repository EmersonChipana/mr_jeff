class ServiceDto {
  final int serviceId;
  final double price;
  final String catStatus;
  final int principalService;
  final String size;
  final String detTitle;
  final String detDescription;

  ServiceDto({
    required this.serviceId,
    required this.price,
    required this.catStatus,
    required this.principalService,
    required this.size,
    required this.detTitle,
    required this.detDescription,
  });

  factory ServiceDto.fromJson(Map<String, dynamic> json) {
    return ServiceDto(
      serviceId: json['serviceId'],
      price: json['price'],
      catStatus: json['catStatus'],
      principalService: json['principalService'],
      size: json['size'],
      detTitle: json['detTitle'],
      detDescription: json['detDescription'],
    );
  }
}
