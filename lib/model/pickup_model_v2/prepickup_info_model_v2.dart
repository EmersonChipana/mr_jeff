import 'package:mr_jeff/model/pickup_model_v2/address_model.dart';
import 'package:mr_jeff/model/pickup_model_v2/hours_model.dart';
import 'package:mr_jeff/model/pickup_model_v2/schedule_model.dart';

class PrePickUpInfoV2{
  final List<Schedule> schedule = [];
  final List<dynamic> schedulePre;

  final List<Address> address = [];
  final List<dynamic> addressPre;
  PrePickUpInfoV2({ required this.addressPre, required this.schedulePre});

  void startCooking(){
    for(Map e in schedulePre){
      List<dynamic> tempHours = e['hours'];
      List<Hours> horas = [];
      for(Map h in tempHours){
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