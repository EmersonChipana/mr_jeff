class Service {
  final int? id;
  final String? service;
  final String? price;
  final String? description;

  Service({this.id, this.service, this.price, this.description});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      service: json['service'],
      price: json['price'],
      description: json['description'],
    );
  }
}
