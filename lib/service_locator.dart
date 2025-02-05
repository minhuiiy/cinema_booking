/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-15 10:16:59
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/data/repository/authentication/authentication_repository_impl.dart';
import 'package:cinema_booking/data/sources/Authentication/Authentication_service.dart';
import 'package:cinema_booking/domain/repository/Authentication/Authentication.dart';
import 'package:cinema_booking/domain/usecase/authentication/is_signedIn.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Authentication
  sl.registerSingleton<AuthenticationService>(
    AuthenticationServiceImpl(),
  );

  sl.registerSingleton<AuthenticationRepository>(
    AuthenticationRepositoryImpl(),
  );

  sl.registerSingleton<IsSignedInUsecase>(
    IsSignedInUsecase(),
  );
}
