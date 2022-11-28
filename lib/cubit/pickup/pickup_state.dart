import 'package:equatable/equatable.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/model/pickup_model_v2/prepickup_info_model_v2.dart';

class PickUpState extends Equatable{
  final PageStatus status;
  final PrePickUpInfoV2? prePickUpInfoV2;
  final String? errorMessage;

  final int pointerAddress;
  final int pointerTime;
  final int pointerDate;
  final Map<String, double> coordinates;

  final bool showMarker;
  final bool findUser;


  PickUpState ({
    this.status = PageStatus.initial,
    this.prePickUpInfoV2,
    this.errorMessage,
    this.pointerAddress = -1,
    this.pointerTime = 0,
    this.pointerDate = 0,
    coordinates,
    this.showMarker = false,
    this.findUser = false,
  }):coordinates = coordinates ?? {} ;

  @override
  List<Object?> get props => [
    status,
    prePickUpInfoV2,
    errorMessage,
    pointerAddress,
    pointerTime,
    pointerDate,
    coordinates,
    showMarker,
    findUser
  ];

  PickUpState copyWith({
    PageStatus? status,
    PrePickUpInfoV2? prePickUpInfoV2,
    String? errorMessage,
    int? pointerAddress,
    int? pointerTime,
    int? pointerDate,
    Map<String, double>? coordinates,
    bool? showMarker,
    bool? findUser
  }){
    return PickUpState(
      status: status ?? this.status,
        prePickUpInfoV2: prePickUpInfoV2 ?? this.prePickUpInfoV2,
      errorMessage: errorMessage ?? this.errorMessage,
        pointerAddress: pointerAddress ?? this.pointerAddress,
        pointerTime: pointerTime ?? this.pointerTime,
        pointerDate: pointerDate ?? this.pointerDate,
        coordinates : coordinates ?? this.coordinates,
        showMarker: showMarker ?? this.showMarker,
        findUser: findUser ?? this.findUser
    );

  }

  String? shoLess() {
    return 'PickUpState{status: $status, errorMessage: $errorMessage, pointerAddress: $pointerAddress, pointerTime: $pointerTime, pointerDate: $pointerDate, coordinates: $coordinates, showMarker: $showMarker, findUser: $findUser}';
  }

}