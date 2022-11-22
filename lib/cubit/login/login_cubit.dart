import 'package:mr_jeff/cubit/login/page_status.dart';
import 'package:mr_jeff/dto/login_response_dto.dart';
import 'package:mr_jeff/service/login_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> login(String username, String password) async {
    final storage = FlutterSecureStorage();

    emit(state.copyWith(status: PageStatus.loading));
    try {
      LoginResponseDto response = await LoginService.login(username, password);

      await storage.write(key: "TOKEN", value: response.token);
      await storage.write(key: "REFRESH", value: response.refresh);
      emit(state.copyWith(
          loginSuccess: true,
          status: PageStatus.success,
          token: response.token,
          refreshToken: response.refresh));
    } on Exception catch (ex) {
      emit(state.copyWith(
          loginSuccess: false,
          status: PageStatus.failure,
          errorMessage: ex.toString(),
          exception: ex));
    }
  }
}
