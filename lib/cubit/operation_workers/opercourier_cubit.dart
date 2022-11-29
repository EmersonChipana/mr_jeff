import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mr_jeff/cubit/operation_workers/opecourier_state.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/dto/ope_courier_dto.dart';
import 'package:mr_jeff/model/operation_model/ope_courier_info.dart';
import 'package:mr_jeff/service/ope_courier_service.dart';

class OpeCourierCubit extends Cubit<OpeCourierState>{
  OpeCourierCubit() : super(OpeCourierState());

  void init() async {
    emit(state.copyWith(status: PageStatus.loading));
    try{
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: "TOKEN");
      if(token != null){
        OpeCourierDto opeCourierDto = await OpeCourierService.getOperationInfo(token);
        List<OpeCourierInfo> listAvailableOpe = opeCourierDto.getInformationAboutDto(opeCourierDto.availableOperations);
        List<OpeCourierInfo> listCurrentOpe = opeCourierDto.getInformationAboutDto(opeCourierDto.currentOperations);

        emit(state.copyWith(status: PageStatus.success, availableOperations: listAvailableOpe, currentOperations: listCurrentOpe));

      }else{
        emit(state.copyWith(
            status: PageStatus.failure,
            errorMessage: "Usuario no autenticado"));
      }


    } on Exception catch(ex, stacktrace){
      emit(state.copyWith(
          status: PageStatus.failure,
          errorMessage:   ex.toString() ));
    }
  }

  void openAvailableMap(int index, int operationList) {
    if(operationList == 1) {
      // mapa para aceptar una operacion
      emit(state.copyWith(
          operationId: state.availableOperations[index].operationId,
          operationName: state.availableOperations[index].operation,
          pointerAvailable: index,
          pointerOperation: operationList,
          status: PageStatus.verifying,
          latCurrent: state.availableOperations[index].lat,
          lngCurrent: state.availableOperations[index].lng
      ));
    }else if(operationList == 2){
      emit(state.copyWith(
          operationId: state.currentOperations[index].operationId,
          operationName: state.currentOperations[index].operation,
          pointerCurrent: index,
          pointerOperation: operationList,
          status: PageStatus.verifying,
          latCurrent: state.currentOperations[index].lat,
          lngCurrent: state.currentOperations[index].lng
      ));
    }


    emit(state.copyWith(status: PageStatus.correctVerified));



  }

  void setPageState(PageStatus pageStatus){
    emit(state.copyWith(status: pageStatus));
  }

  void acceptRequest() {
    print(state);

  }

  void sendOperation() async {
    emit(state.copyWith(status: PageStatus.verifying2));
    try{
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: "TOKEN");
      if(token != null){
        OpeCourierInfo flag = state.availableOperations[state.pointerAvailable];

        bool a = await OpeCourierService.sendOperation(
            token,
            true,
            flag
        );
        print(a);
        emit(state.copyWith(status: PageStatus.correctVerified2));

      }else{
        emit(state.copyWith(
            status: PageStatus.failure,
            errorMessage: "Usuario no autenticado"));
      }


    }on Exception catch(ex, extrace){
      emit(state.copyWith(
          status: PageStatus.failure,
          errorMessage: "Error al consultar prepickup $ex \n $extrace"));
    }
  }



}