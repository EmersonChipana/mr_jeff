
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/cubit/pickup/prepickup/prepickup_state.dart';
import 'package:mr_jeff/dto/prepickup_dto.dart';
import 'package:mr_jeff/model/prepickup_model/prepickup_info_model.dart';
import 'package:mr_jeff/service/pickup_service.dart';
import 'package:mr_jeff/service/prepickup_service.dart';

class PrePickupCubit extends Cubit<PrePickupState> {
  PrePickupCubit() : super(PrePickupState());

  void init() async {
    emit(state.copyWith(status: PageStatus.loading));
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: "TOKEN");
    try{
      if(token != null){
        PrePickUpDto prePickUpDto = await PrePickUpService.getPrePickUp(0, token);
        PrePickUpInfo prePickUpInfo  = PrePickUpInfo(
            holidays: prePickUpDto.holidays,
            daysToWork: prePickUpDto.daysPermitted,
            listOfMapOfHours: prePickUpDto.horas,
            listOfMapOfAddresses: prePickUpDto.addresses);
        prePickUpInfo.processData();

        emit(state.copyWith(
            status: PageStatus.success, prePickUpInfo:  prePickUpInfo
        ));
      }else{
        //TODO: botar al usario
        emit(state.copyWith(
            status: PageStatus.failure,
            errorMessage: "Usuario no autenticado"));
      }
    }on Exception catch(ex, stacktrace){
      emit(state.copyWith(
          status: PageStatus.failure,
          errorMessage: "Error al consultar prepickup $ex \n $stacktrace"));
    }

  }

  void passToOtherPage() async{


    emit(state.copyWith(status: PageStatus.verifying));
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: "TOKEN");
    try{
      if(state.coordinates.isNotEmpty){
        int result = await PrePickUpService.isValidAreaService(state.coordinates, token);
        if(result == 1){
          emit(state.copyWith(status: PageStatus.correctVerified));
        }else{
          emit(state.copyWith(status: PageStatus.incorrectVerified, errorMessage: 'La ubicacion esta fuera de nuestro alcance'));
        }

      }else{
        emit(state.copyWith(status: PageStatus.incorrectVerified, errorMessage: 'Por favor seleccionar una ubicacion'));
      }

    } on Exception catch(ex, stacktrace){
      emit(state.copyWith(
          status: PageStatus.failure,
          errorMessage: "Error al consultar valid braches $ex \n $stacktrace"));
    }
  }

  void endPickUpRequest(String name, String detail) async{
    if(state.pointerAddress == -1){

      if(name.isEmpty){

        emit(state.copyWith(status: PageStatus.incorrectVerified2, errorMessage: 'Por favor introduzca al menos el nombre'));
      }else{

        endPickUp(name, detail);
      }
    }else{

      endPickUp(name, detail);
    }
  }

  void endPickUp(String name, String detail)async{

    emit(state.copyWith(status: PageStatus.verifying2));
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: "TOKEN");

    try{

      if(token != null){
        Map<String, dynamic> maped = mapTheRequest(name, detail);

        // procesos para llamar al servicio
        bool stado = await PickUpService.addNewPickUp(maped, token);



        if(stado){
          emit(state.copyWith(status: PageStatus.correctVerified2 ));
        }else{
          emit(state.copyWith(status: PageStatus.incorrectVerified2, errorMessage: 'Algo saliio mal'));
        }
      }else{
        // TODO No hay token deber??amos botar al usuario al login
        emit(state.copyWith(
            status: PageStatus.failure,
            errorMessage: "Usuario no autenticado"));
      }

    }on Exception catch(ex, stacktrace){
      print('ex: $ex stacktrace $stacktrace');
      emit(state.copyWith(
          status: PageStatus.failure,
          errorMessage: ex.toString()));
    }
  }

  void setPointerAddress(int pointer){
    emit(state.copyWith(pointerAddress: pointer ));
  }

  void setNewMarker(Map<String, double> coord) {
    emit(state.copyWith(coordinates: coord, showMarker: true));

  }

  void setNewTimePointer(int index) {
    emit(state.copyWith(pointerTime: index));
  }

  void setNewDatePointer(int index) {
    emit(state.copyWith(pointerDate: index));
  }

  void findUser(bool find){
    emit(state.copyWith(findUser: find));
  }

  void setPageState(PageStatus pageStatus){
    emit(state.copyWith(status: PageStatus.success));
  }

  Map<String, dynamic> mapTheRequest(String name1, String detail1) {
    int addressId = 0;
    String name = name1;
    String detail = detail1;
    String addressLink = '';
    if(state.pointerAddress != -1){
      addressId = state.prePickUpInfo!.finalListAddress[state.pointerAddress].addressId;
      name = state.prePickUpInfo!.finalListAddress[state.pointerAddress].name;
      detail = state.prePickUpInfo!.finalListAddress[state.pointerAddress].detail;
      addressLink = state.prePickUpInfo!.finalListAddress[state.pointerAddress].addressLink;
    }
    Map<String, dynamic> maped = {
      "addressId": addressId,
      "name": name,
      "latitude":  state.coordinates['lat'],
      "longitude": state.coordinates['lng'],
      "detail": detail,
      "addressLink": addressLink,
      "userId": 0,
      "timeId": state.prePickUpInfo!.finalListTime[state.pointerDate].horas[state.pointerTime].hourId,
      "date": state.prePickUpInfo!.finalListTime[state.pointerDate].dia.getJustDate()
    };
    
    return maped;
  }

  void setInitial() {

    emit(state.copyWith(showMarker: false,
    status: PageStatus.initial,
    pointerAddress: -1,
    pointerDate: 0,
    pointerTime: 0,
    coordinates: {},
    findUser: false

    ));
  }


}
