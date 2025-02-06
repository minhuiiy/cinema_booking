/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-14 15:42:03
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/data/models/auth/user.dart';

class CreateUserReq extends UserModel {
  CreateUserReq({
    required super.email,
    required super.password,
    required super.fullName,
    required super.gender,
    required super.age,
  });
}
