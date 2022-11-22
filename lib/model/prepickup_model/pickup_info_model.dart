import 'package:mr_jeff/model/prepickup_model/work_day_model.dart';
import 'package:mr_jeff/model/prepickup_model/work_hour_model.dart';
import 'package:mr_jeff/model/prepickup_model/address_user_model.dart';

class PickUpInfo{
  final Address address;
  final int userId ;
  final HourToWork hour;
  final DayToWork day;

  PickUpInfo({
    required this.address,
    required this.userId,
    required this.hour,
    required this.day
  });


}