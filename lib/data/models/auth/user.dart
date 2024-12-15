/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-15 10:16:59
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/domain/entities/auth/user.dart';

class UserModel {
  String? email;
  String? fullName;
  String? imageURL;

  UserModel({
    this.email,
    this.fullName,
    this.imageURL,
  });

  UserModel.fromJson(Map<String, dynamic> data) {
    email = data['email'];
    fullName = data['name'];
    imageURL = data['imageURL'];
  }
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      email: email!,
      fullName: fullName!,
      imageURL: imageURL!,
    );
  }
}
