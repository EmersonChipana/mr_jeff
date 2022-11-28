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