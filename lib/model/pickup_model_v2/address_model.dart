class Address{
  final int mrAddressId;
  final double latitude;
  final double longitude;
  final String name;
  final String detail;
  final String addressLink;
  Address({ required this.mrAddressId, required this.latitude,
  required this.longitude, required this.name, required this.detail,
  required this.addressLink});

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      detail: json['detail'] ,
      addressLink: json['addressLink'] ,
      latitude: json['latitude'] ,
      longitude: json['longitude'] ,
      mrAddressId: json['mrAddressId'] ,
      name: json['name']
    );
  }

}