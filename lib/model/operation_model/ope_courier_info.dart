class OpeCourierInfo{
    final int id;
    final String date;
    final String timeStart;
    final String timeEnd;
    final String operation;
    final double lat;
    final double lng;
    final int operationId;
    final String message;
    final String nameClient;

    OpeCourierInfo({
      required this.id,
      required this.date,
      required this.timeStart,
      required this.timeEnd,
      required this.operation,
      required this.lat,
      required this.lng,
      required this.operationId,
      required this.message,
      required this.nameClient
    });

    @override
  String toString() {
    return 'OpeCourierInfo{id: $id, date: $date, timeStart: $timeStart, timeEnd: $timeEnd, operation: $operation, lat: $lat, lng: $lng, operationId: $operationId, message: $message, nameClient: $nameClient}';
  }
}