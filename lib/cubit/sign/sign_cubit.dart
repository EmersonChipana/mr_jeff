import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/login/page_status.dart';
import 'package:mr_jeff/cubit/sign/sign_state.dart';
import 'package:mr_jeff/model/newuser_model/newuser_model.dart';
import 'package:mr_jeff/service/sign_sevice.dart';

class SignCubit extends Cubit<SignState> {
  SignCubit() : super(const SignState());

  Future<void> sign(String firstName, String lastName, String numPhone,
      String username, String email, String password) async {
    emit(state.copyWith(status: PageStatus.loading));
    // convert to JSON firstName, lastName, email, username, password

    SignService _signService = SignService();

    // testing my version;
    _signService.sign(firstName, lastName, numPhone, email, username, password);
    emit(state.copyWith(status: PageStatus.success));
    // go to home_page
  }

  void chargeObject(NewUser newUser) {
    emit(state.copyWith(newUser: newUser));
  }

  Future<void> ingresaConToken(String token) async{
     emit(state.copyWith(status: PageStatus.checking));
      // convert to JSON firstName, lastName, email, username, password

    SignService _signService = SignService();

    
    try {
      await _signService.signv2Token( state.newUser!.firstName,
       state.newUser!.lastName, state.newUser!.numPhone, state.newUser!.email, 
       state.newUser!.username, state.newUser!.password, state.newUser!.gender,
        state.newUser!.role, token);

      emit(state.copyWith(status: PageStatus.goodcheck));
    } on Exception catch (ex) {
      emit(state.copyWith(
          status: PageStatus.badcheck,
          errorMessage: "Error al consultar valid braches $ex"));
    }
      // testing my version;
      
  }

  Future<void> signv2(NewUser nuevo) async{
  emit(state.copyWith(status: PageStatus.loading));
      // convert to JSON firstName, lastName, email, username, password

      SignService _signService = SignService();


      // testing my version;
      _signService.signv2( nuevo.firstName, nuevo.lastName, nuevo.numPhone, nuevo.email, nuevo.username, nuevo.password, nuevo.gender, nuevo.role);
      emit(state.copyWith(status: PageStatus.success));
  }
}
