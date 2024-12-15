import 'package:dartz/dartz.dart';
import 'package:cinema_booking/core/usecase/usecase.dart';
import 'package:cinema_booking/domain/repository/auth/auth.dart';
import 'package:cinema_booking/service_locator.dart';

class GetUserUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<AuthRepository>().getUser();
  }
}
