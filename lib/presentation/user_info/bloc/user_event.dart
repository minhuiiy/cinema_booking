/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-21 11:20:52
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

part of 'user_bloc.dart';

abstract class UserInfoEvent extends Equatable {
  const UserInfoEvent();

  @override
  List<Object> get props => [];
}

class LoadUserInfo extends UserInfoEvent {
  const LoadUserInfo();

  @override
  List<Object> get props => [];
}

class PasswordChanged extends UserInfoEvent {
  final String password;
  final String confirmPassword;

  const PasswordChanged({
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'PasswordChanged{password: $password, confirmPassword: $confirmPassword}';
  }
}

class ConfirmPasswordChanged extends UserInfoEvent {
  final String password;
  final String confirmPassword;

  const ConfirmPasswordChanged({
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'ConfirmPasswordChanged{password: $password, confirmPassword: $confirmPassword}';
  }
}

class Submitted extends UserInfoEvent {
  final String email;
  final String? password;
  final String? confirmPassword;
  final String displayName;
  final int age;
  final String gender;

  const Submitted({
    required this.email,
    this.password,
    this.confirmPassword,
    required this.displayName,
    required this.age,
    required this.gender,
  });

  @override
  List<Object> get props => [email, displayName, age, gender];

  @override
  String toString() {
    return 'Submitted{email: $email, password: $password, confirmPassword: $confirmPassword, displayName: $displayName, age: $age, gender: $gender}';
  }
}
