
import 'package:mr_jeff/model/operation_model/ope_courier_info.dart';

class OpeCourierDto{
  List<dynamic> availableOperations;
  List<dynamic> currentOperations;

  OpeCourierDto({
    required this.availableOperations,
    required this.currentOperations
  });

  factory OpeCourierDto.fromJson(Map<String, dynamic> json){
    return OpeCourierDto(
      availableOperations: json['availableOperations'],
      currentOperations: json['currentOperations']
    );
  }

  List<OpeCourierInfo> getInformationAboutDto(List<dynamic> list){
    List<OpeCourierInfo> listAvailableOpe = [];
    for(int x = 0 ; x < list.length ; x++ ){
      listAvailableOpe.add(OpeCourierInfo(
          id: list[x]['id'],
          date: list[x]['date'],
          timeStart: list[x]['timeStart'],
          timeEnd: list[x]['timeEnd'],
          operation: list[x]['operation'],
          lat: list[x]['lat'],
          lng: list[x]['lng'],
          operationId:list[x]['operationId'],
          message: list[x]['message'],
          nameClient: list[x]['nameClient']
      ));
    }
    return listAvailableOpe;
  }


}