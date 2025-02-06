/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-17 20:15:13
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/helpers/is_valid.dart';
import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/data/models/auth/signin_user_req.dart';
import 'package:cinema_booking/domain/usecase/auth/signin.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.empty()) {
    on<LoginSubmitEmailPasswordEvent>(_onLoginSubmitEmailPasswordEvent);
    on<LoginEmailChanged>(_onLoginEmailChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
  }

  Future<void> _onLoginSubmitEmailPasswordEvent(
    LoginSubmitEmailPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    LogHelper.logDebug(tag: "LoginBloc", message: 'start _onLoginSubmitEmailPasswordEvent');
    try {
      emit(LoginState.loading());

      var isSignedIn = await sl<SigninUseCase>().call(
        params: SigninUserReq(
          email: event.email,
          password: event.password,
        ),
      );

      isSignedIn.fold(
        (l) {
          emit(LoginState.failure());
        },
        (r) {
          emit(LoginState.success());
        },
      );
    } catch (e) {
      LogHelper.logDebug(tag: "LoginBloc", message: 'error _onLoginSubmitEmailPasswordEvent: $e');
      emit(LoginState.failure());
    }
  }

  Future<void> _onLoginEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) async {
    await Future.delayed(Duration(milliseconds: 300));
    emit(state.update(isEmailValid: Validators.isValidEmail(event.email)));
  }

  Future<void> _onLoginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    await Future.delayed(Duration(milliseconds: 300)); // debounce
    emit(state.update(isPasswordValid: Validators.isValidPassword(event.password)));
  }
}
