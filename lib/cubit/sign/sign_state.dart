import 'package:equatable/equatable.dart';

import 'package:mr_jeff/cubit/login/page_status.dart';
import 'package:mr_jeff/model/newuser_model/newuser_model.dart';

class SignState extends Equatable {
  final PageStatus status;
  final bool loginSuccess;
  final String? errorMessage;
  final Exception? exception;
  final String? token;
  final String? refreshToken;
  final NewUser? newUser;

  const SignState({
    this.status = PageStatus.initial,
    this.loginSuccess = false,
    this.errorMessage,
    this.exception,
    this.token,
    this.refreshToken,
    this.newUser
  });

  SignState copyWith({
    PageStatus? status,
    bool? loginSuccess,
    String? errorMessage,
    Exception? exception,
    String? token,
    String? refreshToken,
    NewUser? newUser
  }) {
    return SignState(
      status: status ?? this.status,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      exception: exception ?? this.exception,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      newUser: newUser ?? this.newUser
    );
  }

  @override
  List<Object?> get props => [
        status,
        loginSuccess,
        errorMessage,
        exception,
        token,
        refreshToken,
        newUser,
      ];
}
