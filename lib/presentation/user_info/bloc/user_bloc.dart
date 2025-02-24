/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-21 11:20:51
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/helpers/is_valid.dart';
import 'package:cinema_booking/data/models/auth/edit_user_req.dart';
import 'package:cinema_booking/domain/entities/auth/user.dart';
import 'package:cinema_booking/domain/usecase/user/edit_user_info.dart';
import 'package:cinema_booking/domain/usecase/user/get_user.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  /// Initializes the bloc with an empty state.
  UserInfoBloc() : super(UserInfoState.empty()) {
    on<LoadUserInfo>(_loadUserInfo);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<Submitted>(_onFormSubmitted);
  }

  /// Load UserInfo from FireBase
  Future<void> _loadUserInfo(
    LoadUserInfo event,
    Emitter<UserInfoState> emit,
  ) async {
    var response = await sl<GetUserUseCase>().call();

    response.fold(
      (l) {
        emit(UserInfoState.failure());
      },
      (r) {
        emit(state.loadUserInfo(userInfo: r));
      },
    );
  }

  /// Handles changes in password input.
  /// Validates the password strength and checks if it matches the confirmation password.
  void _onPasswordChanged(PasswordChanged event, Emitter<UserInfoState> emit) {
    final isPasswordValid = Validators.isValidPassword(event.password);
    final isMatched =
        event.confirmPassword.isEmpty ||
        event.password == event.confirmPassword;

    emit(
      state.update(
        isPasswordValid: isPasswordValid,
        isConfirmPasswordValid: isMatched,
      ),
    );
  }

  /// Handles changes in confirm password input.
  /// Ensures that it matches the original password.
  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<UserInfoState> emit,
  ) {
    final isConfirmPasswordValid = Validators.isValidPassword(
      event.confirmPassword,
    );
    final isMatched =
        event.password.isEmpty || event.password == event.confirmPassword;

    emit(
      state.update(isConfirmPasswordValid: isConfirmPasswordValid && isMatched),
    );
  }

  Future<void> _onFormSubmitted(
    Submitted event,
    Emitter<UserInfoState> emit,
  ) async {
    // Validate form inputs
    final isValidEmail = Validators.isValidEmail(event.email);
    final isValidName = Validators.isValidName(event.displayName);
    final bool hasPassword =
        event.password != null && event.password!.isNotEmpty;

    bool isValidPassword = true;
    bool isMatched = true;

    if (hasPassword) {
      isValidPassword = Validators.isValidPassword(event.password!);
      isMatched = event.password == event.confirmPassword;
    }

    // Update state with validation results
    final newState = state.update(
      isEmailValid: isValidEmail,
      isNameValid: isValidName,
      isPasswordValid: isValidPassword,
      isConfirmPasswordValid: isMatched,
    );

    emit(newState);

    // If form is invalid, stop execution
    if (!newState.isFormValid) return;

    emit(UserInfoState.loading());

    // Determine which use case to call (EditUserInfoUseCase if password exists, otherwise SignupUseCase)
    var result =
        await (hasPassword
            ? sl<EditUserInfoUseCase>().call(
              params: EditUserReq(
                email: event.email,
                fullName: event.displayName,
                password: event.password!,
                age: event.age,
                gender: event.gender,
              ),
            )
            : sl<EditUserInfoUseCase>().call(
              params: EditUserReq(
                email: event.email,
                fullName: event.displayName,
                age: event.age,
                gender: event.gender,
              ),
            ));

    result.fold(
      (l) => emit(UserInfoState.failure()),
      (r) => emit(UserInfoState.success()),
    );
  }
}
