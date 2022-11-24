import 'package:equatable/equatable.dart';
import 'package:mr_jeff/model/operation_model/ope_courier_info.dart';

import '../pickup/al_pagestatus.dart';

class OpeCourierState extends Equatable{
    final PageStatus status;
    final List<OpeCourierInfo> availableOperations;
    final List<OpeCourierInfo> currentOperations;
    final int? operationId;
    final String? operationName;
    final String? errorMessage;
    final int pointerAvailable;
    final int pointerCurrent;
    final int pointerOperation;
    final double latCurrent;
    final double lngCurrent;

    OpeCourierState({

      this.status = PageStatus.initial,
      availableOperations,
      currentOperations,
      this.operationId,
      this.operationName,
      this.errorMessage,
      this.pointerAvailable = 0,
      this.pointerCurrent = 0,
      this.pointerOperation = 0,
      this.latCurrent = 0,
      this.lngCurrent = 0,
    }):
      availableOperations = availableOperations ?? [],
      currentOperations = currentOperations ?? [];



    @override
    List<Object?> get props => [
    status,
      availableOperations,
      currentOperations,
      operationId,
      operationName,
      errorMessage,
      pointerAvailable,
      pointerCurrent,
      pointerOperation,
      latCurrent,
      lngCurrent
    ];

    OpeCourierState copyWith({
      PageStatus? status,
      List<OpeCourierInfo>? availableOperations,
      List<OpeCourierInfo>? currentOperations,
      int? operationId,
      String? operationName,
      String? errorMessage,
      int? pointerAvailable,
      int? pointerCurrent,
      int? pointerOperation,
      double? latCurrent,
      double? lngCurrent
    }){
      return OpeCourierState(
        status: status ?? this.status,
          availableOperations: availableOperations ?? this.availableOperations,
          currentOperations: currentOperations ?? this.currentOperations,
        operationId : operationId ?? this.operationId,
        operationName: operationName ?? this.operationName,
        errorMessage: errorMessage ?? this.errorMessage,
          pointerAvailable : pointerAvailable ?? this.pointerAvailable,
          pointerCurrent : pointerCurrent ?? this.pointerCurrent,
          pointerOperation: pointerOperation ?? this.pointerOperation,
        latCurrent: latCurrent ?? this.latCurrent,
        lngCurrent: lngCurrent ?? this.lngCurrent
      );
    }

    @override
  String toString() {
    return 'OpeCourierState{status: $status, availableOperations: $availableOperations, currentOperations: $currentOperations, operationId: $operationId, operationName: $operationName, errorMessage: $errorMessage, pointerAvailable: $pointerAvailable, pointerCurrent: $pointerCurrent, pointerOperation: $pointerOperation}';
  }

    String lessData() {
      return 'OpeCourierState{status: $status,    operationId: $operationId, operationName: $operationName, errorMessage: $errorMessage, pointerAvailable: $pointerAvailable, pointerCurrent: $pointerCurrent, pointerOperation: $pointerOperation}';
    }
}