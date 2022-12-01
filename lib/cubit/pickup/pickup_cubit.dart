import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mr_jeff/cubit/clothings_order/clothings_order_cubit.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/cubit/pickup/pickup_state.dart';
import 'package:mr_jeff/dto/pickup_dto/prepickupinfo_v2_dto.dart';
import 'package:mr_jeff/model/pickup_model_v2/prepickup_info_model_v2.dart';
import 'package:mr_jeff/service/delivery_service.dart';
import 'package:mr_jeff/service/pickup_service/prepickup_v2_service.dart';
import 'package:mr_jeff/service/prepickup_service.dart';

import '../../service/pickup_service.dart';

class PickUpCubit extends Cubit<PickUpState> {
  PickUpCubit() : super(PickUpState());

  void init() async {
    // cordenadas de la Paz
    emit(state.copyWith(status: PageStatus.loading));
    try {
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: "TOKEN");
      if (token != null) {
        PrePickUpInfoV2Dto prePickUpInfoV2Dto =
            await PrePickUpServiceV2.getSchedule(0, token);
        PrePickUpInfoV2 prePickUpInfoV2 = PrePickUpInfoV2(
            addressPre: prePickUpInfoV2Dto.address,
            schedulePre: prePickUpInfoV2Dto.schedule);
        prePickUpInfoV2.startCooking();

        emit(state.copyWith(
            status: PageStatus.success, prePickUpInfoV2: prePickUpInfoV2));
      } else {
        emit(state.copyWith(
            status: PageStatus.failure,
            errorMessage: "Usuario no autenticado"));
      }
    } on Exception catch (ex, stacktrace) {
      emit(state.copyWith(
          status: PageStatus.failure,
          errorMessage: "Error al consultar prepickup $ex \n $stacktrace"));
    }
  }

  void passToOtherPage() async {
    print(state.shoLess());
    emit(state.copyWith(status: PageStatus.verifying));
    try {
      if (state.coordinates.isNotEmpty) {
        print('cubit>pcikup>pickup_cubit.dart> ================');
        print(state.coordinates);
        int result = await PrePickUpService.isValidAreaService(
            state.coordinates, "token aqui XD");
        print(result);
        if (result == 1) {
          emit(state.copyWith(status: PageStatus.correctVerified));
        } else {
          emit(state.copyWith(
              status: PageStatus.incorrectVerified,
              errorMessage: 'La ubicacion esta fuera de nuestro alcance'));
        }
      } else {
        emit(state.copyWith(
            status: PageStatus.incorrectVerified,
            errorMessage: 'Por favor seleccionar una ubicacion'));
      }
    } on Exception catch (ex, stacktrace) {
      emit(state.copyWith(
          status: PageStatus.failure,
          errorMessage: "Error al consultar valid braches $ex \n $stacktrace"));
    }
  }

  void setPageState(PageStatus pageStatus) {
    emit(state.copyWith(status: PageStatus.success));
  }

  void setCoordinates(Map<String, double> map) {
    emit(state.copyWith(coordinates: map));
  }

  void setNewDatePointer(int index) {
    emit(state.copyWith(pointerDate: index));
  }

  void setNewTimePointer(int index) {
    emit(state.copyWith(pointerTime: index));
  }

  void setPointerAddress(int pointer) {
    emit(state.copyWith(pointerAddress: pointer));
  }

  void setInitial() {
    emit(state.copyWith(
        showMarker: false,
        status: PageStatus.initial,
        pointerAddress: -1,
        pointerDate: 0,
        pointerTime: 0,
        coordinates: {},
        findUser: false));
  }

  void endPickUpRequest(String name, String detail) async {
    if (state.pointerAddress == -1) {
      if (name.isEmpty) {
        emit(state.copyWith(
            status: PageStatus.incorrectVerified2,
            errorMessage: 'Por favor introduzca al menos el nombre'));
      } else {
        endPickUp(name, detail);
      }
    } else {
      endPickUp(name, detail);
    }
  }

  void endDeliveryRequest(
      String name, String detail, String comment, int? id) async {
    if (state.pointerAddress == -1) {
      if (name.isEmpty) {
        emit(state.copyWith(
            status: PageStatus.incorrectVerified2,
            errorMessage: 'Por favor introduzca al menos el nombre'));
      } else {
        endDelivery(name, detail, comment, 1);
      }
    } else {
      endDelivery(name, detail, comment, 1);
    }
  }

  void endDelivery(String name, String detail, String comment, int id) async {
    emit(state.copyWith(status: PageStatus.verifying2));
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: "TOKEN");
    try {
      if (token != null) {
        Map<String, dynamic> maped = mapDelivery(name, detail, comment, id);

        bool stado = await DeliveryService().createDelivery(maped, token);

        if (stado) {
          emit(state.copyWith(status: PageStatus.correctVerified2));
        } else {
          emit(state.copyWith(
              status: PageStatus.incorrectVerified2,
              errorMessage: 'Algo saliio mal'));
        }
      } else {
        emit(state.copyWith(
            status: PageStatus.failure,
            errorMessage: "Usuario no autenticado"));
      }
    } on Exception catch (ex, stacktrace) {
      print('ex: $ex stacktrace $stacktrace');
      emit(state.copyWith(
          status: PageStatus.failure, errorMessage: ex.toString()));
    }
  }

  void endPickUp(String name, String detail) async {
    emit(state.copyWith(status: PageStatus.verifying2));
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: "TOKEN");

    try {
      if (token != null) {
        Map<String, dynamic> maped = mapTheRequest(name, detail);

        print(maped);
        // procesos para llamar al servicio
        bool stado = await PickUpService.addNewPickUp(maped, token);

        if (stado) {
          emit(state.copyWith(status: PageStatus.correctVerified2));
        } else {
          emit(state.copyWith(
              status: PageStatus.incorrectVerified2,
              errorMessage: 'Algo saliio mal'));
        }
      } else {
        // TODO No hay token deberíamos botar al usuario al login
        emit(state.copyWith(
            status: PageStatus.failure,
            errorMessage: "Usuario no autenticado"));
      }
    } on Exception catch (ex, stacktrace) {
      print('ex: $ex stacktrace $stacktrace');
      emit(state.copyWith(
          status: PageStatus.failure, errorMessage: ex.toString()));
    }
  }

  Map<String, dynamic> mapDelivery(
      String name1, String detail1, String comment, int id) {
    int addressId = 0;
    String name = name1;
    String detail = detail1;
    String addressLink = '';
    if (state.pointerAddress != -1) {
      addressId =
          state.prePickUpInfoV2!.address[state.pointerAddress].mrAddressId;
      name = state.prePickUpInfoV2!.address[state.pointerAddress].name;
      detail = state.prePickUpInfoV2!.address[state.pointerAddress].detail;
      addressLink =
          state.prePickUpInfoV2!.address[state.pointerAddress].addressLink;
    }
    Map<String, dynamic> maped = {
      "addressId": addressId,
      "name": name,
      "latitude": state.coordinates['lat'],
      "longitude": state.coordinates['lng'],
      "detail": detail,
      "addressLink": addressLink,
      "timeId": state.prePickUpInfoV2!.schedule[state.pointerDate]
          .hours[state.pointerTime].mrScheduleId,
      "date": state.prePickUpInfoV2!.schedule[state.pointerDate].day,
      "comment": comment,
      "orderId": id
    };
    return maped;
  }

  Map<String, dynamic> mapTheRequest(String name1, String detail1) {
    int addressId = 0;
    String name = name1;
    String detail = detail1;
    String addressLink = '';
    if (state.pointerAddress != -1) {
      addressId =
          state.prePickUpInfoV2!.address[state.pointerAddress].mrAddressId;
      name = state.prePickUpInfoV2!.address[state.pointerAddress].name;
      detail = state.prePickUpInfoV2!.address[state.pointerAddress].detail;
      addressLink =
          state.prePickUpInfoV2!.address[state.pointerAddress].addressLink;
    }
    Map<String, dynamic> maped = {
      "addressId": addressId,
      "name": name,
      "latitude": state.coordinates['lat'],
      "longitude": state.coordinates['lng'],
      "detail": detail,
      "addressLink": addressLink,
      "userId": 0,
      "timeId": state.prePickUpInfoV2!.schedule[state.pointerDate]
          .hours[state.pointerTime].mrScheduleId,
      "date": state.prePickUpInfoV2!.schedule[state.pointerDate].day
    };

    return maped;
  }
}
