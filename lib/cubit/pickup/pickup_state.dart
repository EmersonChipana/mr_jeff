import 'package:equatable/equatable.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/model/prepickup_model/pickup_info_model.dart';

class PickUpState extends Equatable{
  final PageStatus status;
  final PickUpInfo? pickUpInfo;
  final String? errorMessage;

  PickUpState ({
    this.status = PageStatus.initial,
    this.pickUpInfo,
    this.errorMessage
  });

  @override
  List<Object?> get props => [
    status,
    pickUpInfo,
    errorMessage
  ];

  PickUpState copyWith({
    PageStatus? status,
    PickUpInfo? pickUpInfo,
    String? errorMessage
  }){
    return PickUpState(
      status: status ?? this.status,
      pickUpInfo: pickUpInfo ?? this.pickUpInfo,
      errorMessage: errorMessage ?? this.errorMessage
    );

  }
}