/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-21 11:23:13
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */
part of 'user_bloc.dart';

class UserInfoState {
  final UserEntity? userInfo;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isNameValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid =>
      isEmailValid && isPasswordValid && isConfirmPasswordValid && isNameValid;

  const UserInfoState({
    this.userInfo,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isConfirmPasswordValid,
    required this.isNameValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
  });

  /// Factory constructor for an initial empty state.
  /// All fields are marked as valid by default.
  factory UserInfoState.empty({UserEntity? userInfo}) {
    return UserInfoState(
      userInfo: userInfo,
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isNameValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  /// Factory constructor for a loading state.
  /// This is used when the registration process is in progress.
  factory UserInfoState.loading({UserEntity? userInfo}) {
    return UserInfoState(
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isNameValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  /// Factory constructor for a failure state.
  /// Used when the registration process fails.
  factory UserInfoState.failure({UserEntity? userInfo}) {
    return UserInfoState(
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isNameValid: true,
      isSuccess: false,
      isSubmitting: false,
      isFailure: true,
    );
  }

  /// Factory constructor for a success state.
  /// Used when the registration process is successfully completed.
  factory UserInfoState.success({UserEntity? userInfo}) {
    return UserInfoState(
      userInfo: userInfo,
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isNameValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  UserInfoState loadUserInfo({UserEntity? userInfo}) {
    return copyWith(userInfo: userInfo);
  }

  /// Updates the current state with new values.
  /// Only the provided fields are updated, and the rest remain unchanged.
  UserInfoState update({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isNameValid,
    bool? isConfirmPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid,
      isNameValid: isNameValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  /// Creates a copy of the current state with updated values.
  /// If a value is not provided, the existing value is retained.
  UserInfoState copyWith({
    UserEntity? userInfo,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isNameValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return UserInfoState(
      userInfo: userInfo ?? this.userInfo,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isNameValid: isNameValid ?? this.isNameValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return 'UserInfoState{ userInfo: $userInfo, isEmailValid: $isEmailValid, isPasswordValid: $isPasswordValid, isConfirmPasswordValid: $isConfirmPasswordValid, isNameValid: $isNameValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure}';
  }
}
