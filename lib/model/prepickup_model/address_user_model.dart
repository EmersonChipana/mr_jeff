class Address{
  final int addressId;
  final double latitude;
  final double longitude;
  final String name;
  final String detail;
  final String addressLink;

  Address({
    required this.addressId,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.detail,
    required this.addressLink
  });

  @override
  String toString() {
    return 'Address{addressId: $addressId, latitude: $latitude, longitude: $longitude, name: $name, detail: $detail, addressLink: $addressLink}';
  }
}