class HourToWork{
  final int hourId;
  final String initHour;
  List<String>? initHourSplit;
  final String finalHour;
  List<String>? finalHourSplit;
  String? detail;

  HourToWork({
    required this.hourId,
    required this.initHour,
    required this.finalHour,
    this.detail,
    this.initHourSplit,
    this.finalHourSplit
  }){
    initHourSplit = initHour.split(":");
    finalHourSplit = finalHour.split(":");
  }

  @override
  String toString() {
    return 'Hour{hourId: $hourId, initHour: $initHour, finalHour: $finalHour}';
  }

  String getStringTimeFormat(){
    return '${initHourSplit![0]}:${initHourSplit![1]} - ${finalHourSplit![0]}:${finalHourSplit![1]}';
  }
}