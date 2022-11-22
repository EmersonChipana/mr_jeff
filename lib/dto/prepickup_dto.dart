class PrePickUpDto{
  final int daysPermitted;
  final List<dynamic> holidays;
  final List<dynamic> horas;
  final List<dynamic> addresses;


  PrePickUpDto({
    required this.daysPermitted,
    required this.holidays,
    required this.horas,
    required this.addresses
  });

  factory PrePickUpDto.fromJson(Map<String, dynamic> json){
    return PrePickUpDto(
        daysPermitted: json['daysPermited'],
        holidays: json['holidays'],
        horas: json['horas'],
        addresses: json['address']);
  }


}