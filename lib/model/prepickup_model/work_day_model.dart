import 'package:intl/intl.dart';

class DayToWork{
  final DateTime dayOfWeek;
  String? nameDay;

  DayToWork({
    required this.dayOfWeek,
    this.nameDay
  }){
    if(nameDay == null){
      setNameDay();
    }

  }


  void setNameDay(){
    switch(dayOfWeek.weekday){
      case DateTime.monday:
        nameDay = 'Lunes';
        break;
      case DateTime.tuesday:
        nameDay = 'Martes';
        break;
      case DateTime.wednesday:
        nameDay = 'Miércoles';
        break;
      case DateTime.thursday:
        nameDay = 'Jueves';
        break;
      case DateTime.friday:
        nameDay = 'Viernes';
        break;
      case DateTime.saturday:
        nameDay = 'Sabado';
        break;
      default:
        nameDay = 'Domingo';
        break;


    }
  }

  bool isSameDate(DateTime date){
    return date.year == dayOfWeek.year &&  date.month == dayOfWeek.month
        &&  date.day == dayOfWeek.day;
  }

  @override
  String toString() {
    return 'Day{dayOfWeek: $dayOfWeek, nameDay: $nameDay}';
  }

  String getJustDate(){
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dayOfWeek);
  }

  String getNameDayAndDate(){
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return ' $nameDay , ${formatter.format(dayOfWeek)}';
  }
}