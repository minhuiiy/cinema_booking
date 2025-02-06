/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-15 10:16:59
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/data/repository/auth/auth_repository_impl.dart';
import 'package:cinema_booking/data/repository/authentication/authentication_repository_impl.dart';
import 'package:cinema_booking/data/sources/Authentication/Authentication_service.dart';
import 'package:cinema_booking/data/sources/auth/auth_service.dart';
import 'package:cinema_booking/domain/repository/Authentication/Authentication.dart';
import 'package:cinema_booking/domain/repository/auth/auth.dart';
import 'package:cinema_booking/domain/usecase/auth/get_user.dart';
import 'package:cinema_booking/domain/usecase/auth/login_google.dart';
import 'package:cinema_booking/domain/usecase/auth/signin.dart';
import 'package:cinema_booking/domain/usecase/auth/signup.dart';
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

  // Login
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(),
  );

  sl.registerSingleton<AuthService>(
    AuthServiceImpl(),
  );

  sl.registerSingleton<SignupUseCase>(
    SignupUseCase(),
  );

  sl.registerSingleton<SigninUseCase>(
    SigninUseCase(),
  );

  sl.registerSingleton<LoginWithGoogleUsecase>(
    LoginWithGoogleUsecase(),
  );

  sl.registerSingleton<GetUserUseCase>(
    GetUserUseCase(),
  );
}
