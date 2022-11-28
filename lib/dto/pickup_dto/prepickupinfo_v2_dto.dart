class PrePickUpInfoV2Dto{
  final List<dynamic> schedule;
  final List<dynamic> address;

  PrePickUpInfoV2Dto({required this.schedule, required this.address});

  factory PrePickUpInfoV2Dto.fromJson(Map<String, dynamic> json){
    return PrePickUpInfoV2Dto(
        schedule: json['schedule'],
        address: json['address']);
  }

}