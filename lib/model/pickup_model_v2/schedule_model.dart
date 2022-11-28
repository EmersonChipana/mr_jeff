import 'package:mr_jeff/model/pickup_model_v2/hours_model.dart';

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