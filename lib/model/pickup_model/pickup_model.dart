class Schedule{
  final String day;
  final String beautyDay;
  final List<Hours> hours;

  Schedule({required this.day, required this.hours, required this.beautyDay});

  factory Schedule.fromJson(Map<String, dynamic> json){
    return Schedule(
      day: json['day'],
      beautyDay: json['beautyDay'],
      hours: json['hours'],
    );
  }

}
class Hours{
  final int mrScheduleId;
  final String timeStart;
  final String timeEnd;
  final String detail;

  Hours({required this.mrScheduleId, required this.timeStart,
    required this.timeEnd, required this.detail});

  factory Hours.fromJson(Map<String, dynamic> json){
    return Hours(
        detail: json['detail'],
        timeEnd: json['timeEnd'],
        timeStart:json['timeStart'] ,
        mrScheduleId:json['mrScheduleId']
    );
  }

  @override
  String toString() {

    return '${timeStart.substring(0,6)} - ${timeEnd.substring(0,6)}';

  }
}

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

class PrePickUpInfo{
  final List<Schedule> schedule = [];
  final List<dynamic> schedulePre;

  final List<Address> address = [];
  final List<dynamic> addressPre;
  PrePickUpInfo({ required this.addressPre, required this.schedulePre});

  void startCooking(){
    for(Map e in schedulePre){
      List<dynamic> temp_Hours = e['hours'];
      List<Hours> horas = [];
      for(Map h in temp_Hours){
        horas.add(Hours(
            mrScheduleId: h['mrScheduleId'],
            timeStart: h['timeStart'],
            timeEnd: h['timeEnd'],
            detail: h['detail']
        )
        );
      }
      schedule.add(Schedule(
          day: e['day'],
          beautyDay: e['beautyDay'],
          hours: horas ));
    }

    for(Map i in addressPre){
      address.add(Address(
          mrAddressId: i['mrAddressId'],
          latitude: i['latitude'],
          longitude: i['longitude'],
          name: i['name'],
          detail: i['detail'],
          addressLink: i['addressLink']
      )
      );
    }

  }
}