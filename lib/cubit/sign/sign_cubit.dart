import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/login/page_status.dart';
import 'package:mr_jeff/cubit/sign/sign_state.dart';
import 'package:mr_jeff/service/sign_sevice.dart';

class SignCubit extends Cubit<SignState> {
  SignCubit() : super(const SignState());

  Future<void> sign(String firstName, String lastName, String numPhone,
      String username, String email, String password) async {
    emit(state.copyWith(status: PageStatus.loading));
    // convert to JSON firstName, lastName, email, username, password
    SignService _signService = SignService();
    _signService.sign(firstName, lastName, numPhone, email, username, password);
    emit(state.copyWith(status: PageStatus.success));
    // go to home_page
  }
}
