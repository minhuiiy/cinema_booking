/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-15 10:16:59
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/domain/entities/auth/user.dart';

class UserModel {
  String email;
  String fullName;
  String gender;
  int age;

  UserModel({
    required this.email,
    required this.fullName,
    required this.age,
    required this.gender,
  });

  UserModel.fromJson(Map<String, dynamic> data)
      : email = data['email'],
        fullName = data['full_Name'],
        gender = data['gender'],
        age = data['age'] ?? 10;
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      email: email,
      fullName: fullName,
      age: age,
      gender: gender,
    );
  }
}
