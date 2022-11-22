import 'package:mr_jeff/model/prepickup_model/address_user_model.dart';
import 'package:mr_jeff/model/prepickup_model/day_hour_model.dart';
import 'package:mr_jeff/model/prepickup_model/work_day_model.dart';
import 'package:mr_jeff/model/prepickup_model/work_hour_model.dart';

class PrePickUpInfo {
  final List<dynamic> holidays;
  final int daysToWork;
  final List<dynamic> listOfMapOfHours;
  final List<dynamic> listOfMapOfAddresses;
  final List<DateTime> listOfHolidays = [];
  final List<DayHour> finalListTime = [];
  final List<HourToWork> listOfHours = [];
  final List<Address> finalListAddress = [];

  PrePickUpInfo({
    required this.holidays,
    this.daysToWork = 0,
    required this.listOfMapOfHours,
    required this.listOfMapOfAddresses
  });



  void prepareData(){
    for(int i = 0 ; i < listOfMapOfHours.length ; i++){
      listOfHours.add(HourToWork(hourId: listOfMapOfHours[i]['mrScheduleId'], initHour: listOfMapOfHours[i]['timeStart'], finalHour: listOfMapOfHours[i]['timeEnd']));
    }
    for (Map element in listOfMapOfAddresses) {
      finalListAddress.add(Address(
          addressId: element['mrAddressId'],
          latitude: element['latitude'],
          longitude: element['longitude'],
          name: element['name'],
          detail: element['detail'],
          addressLink: element['addressLink']));
    }
  }

  void processData(){
    prepareData();
    for(final e in holidays){
      listOfHolidays.add(DateTime.parse(e));
    }

    DateTime now2 = DateTime.now();

    int counter = 0;

    while(finalListTime.length < daysToWork){
      DateTime val = now2.add(Duration(days: counter));

      if(isDatePermited(val)){
        DayToWork getADay = DayToWork(dayOfWeek: val);

        if(getADay.isSameDate(now2)){
          List<HourToWork> copyListOfHours = [];
          for(int i = 0 ; i< listOfHours.length ; i++){
            DateTime dateObjective = DateTime(now2.year, now2.month, now2.day, int.parse(listOfHours[i].initHourSplit![0]) );
            if(now2.isBefore(dateObjective)){
              copyListOfHours.add(HourToWork(hourId: listOfHours[i].hourId, initHour: listOfHours[i].initHour, finalHour: listOfHours[i].finalHour));
            }
          }

          finalListTime.add(DayHour(dia: getADay, horas: copyListOfHours));
        }else{
          finalListTime.add(DayHour(dia: getADay, horas: listOfHours));
        }




      }

      counter++;

    }


  }

  bool isDatePermited(DateTime date){

    for(final other in listOfHolidays){
      if( date.year == other.year &&  date.month == other.month
          &&  date.day == other.day){
        return false;
      }
    }

    if(date.weekday == DateTime.saturday  || date.weekday == DateTime.sunday){
      return false;
    }

    return true;
  }

  @override
  String toString() {
    return 'PrePickUpInfo{holidays: $holidays, daysToWork: $daysToWork, listOfMapOfHours: $listOfMapOfHours, listOfMapOfAddresses: $listOfMapOfAddresses, listOfHolidays: $listOfHolidays, finalListTime: $finalListTime, listOfHours: $listOfHours, finalListAddress: $finalListAddress}';
  }
}