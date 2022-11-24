
import 'package:equatable/equatable.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/model/prepickup_model/prepickup_info_model.dart';

class PrePickupState extends Equatable{
  final  PageStatus status;
  final PrePickUpInfo? prePickUpInfo;
  final String? errorMessage;
  final int pointerAddress;
  final int pointerTime;
  final int pointerDate;
  final Map<String, double> coordinates;
  final bool showMarker;
  final bool findUser;

  PrePickupState({
    this.status = PageStatus.initial,
    this.prePickUpInfo,
    this.errorMessage,
    this.pointerAddress = -1,
    this.pointerTime = 0,
    this.pointerDate = 0,
     coordinates,
    this.showMarker = false,
    this.findUser = false,
  }): coordinates = coordinates ?? {} ;

  @override
  List<Object?> get props => [
    status,
    prePickUpInfo,
    errorMessage,
    pointerAddress,
    pointerTime,
    pointerDate,
    coordinates,
    showMarker,
    findUser
  ];

  PrePickupState copyWith(
      {
        PageStatus? status,
        PrePickUpInfo? prePickUpInfo,
        String? errorMessage,
        int? pointerAddress,
        int? pointerTime,
        int? pointerDate,
        Map<String, double>? coordinates,
        bool? showMarker,
        bool? findUser
      }){
    return PrePickupState(
        status: status ?? this.status,
        prePickUpInfo: prePickUpInfo ?? this.prePickUpInfo,
        errorMessage: errorMessage ?? this.errorMessage,
        pointerAddress: pointerAddress ?? this.pointerAddress,
        pointerTime: pointerTime ?? this.pointerTime,
        pointerDate: pointerDate ?? this.pointerDate,
        coordinates: coordinates ?? this.coordinates,
        showMarker: showMarker ?? this.showMarker,
        findUser: findUser ?? this.findUser
    );
  }

  @override
  String toString() {
    return 'PrePickupState{status: $status, prePickUpInfo: $prePickUpInfo, errorMessage: $errorMessage, pointerAddress: $pointerAddress, pointerTime: $pointerTime, pointerDate: $pointerDate, coordinates: $coordinates, showMarker: $showMarker, findUser: $findUser}';
  }

  String? lessData() {
    return 'PrePickupState{status: $status,  errorMessage: $errorMessage, pointerAddress: $pointerAddress, pointerTime: $pointerTime, pointerDate: $pointerDate, coordinates: $coordinates, showMarker: $showMarker, findUser: $findUser}';
  }
}


