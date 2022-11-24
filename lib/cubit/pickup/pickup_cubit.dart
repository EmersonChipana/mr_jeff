
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/cubit/pickup/pickup_state.dart';
import 'package:mr_jeff/model/prepickup_model/pickup_info_model.dart';

class PickUpCubit extends Cubit<PickUpState> {
  PickUpCubit() : super(PickUpState());

  void setData(PickUpInfo pickUpInfo) async{
    emit(state.copyWith(status: PageStatus.loading));

  //
  }
}
