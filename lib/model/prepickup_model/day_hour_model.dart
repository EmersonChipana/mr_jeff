import 'package:mr_jeff/model/prepickup_model/work_day_model.dart';
import 'package:mr_jeff/model/prepickup_model/work_hour_model.dart';

class DayHour{
  final DayToWork dia;
  final List<HourToWork> horas;

  DayHour({
    required this.dia,
    required this.horas
  });

  @override
  String toString() {
    return 'DayHour{dia: $dia, horas: $horas}';
  }
}
