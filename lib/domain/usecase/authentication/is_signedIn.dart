/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2025-02-05 10:43:54
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/core/usecase/usecase.dart';
import 'package:cinema_booking/domain/repository/Authentication/Authentication.dart';
import 'package:cinema_booking/service_locator.dart';

class IsSignedInUsecase implements UseCase<bool, String> {
  @override
  Future<bool> call({String? params}) async {
    return sl<AuthenticationRepository>().isSignedIn();
  }
}
