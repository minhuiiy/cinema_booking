import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/core/api/rest_client.dart';
import 'package:cinema_booking/data/models/responce/home_responce.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:dartz/dartz.dart';

abstract class HomeService {
  Future<Either> getHomeData();
}

class HomeServiceImpl extends HomeService {
  @override
  Future<Either> getHomeData() async {
    try {
      LogHelper.logDebug(tag: "HomeService", message: "Making API request to fetch home data");
      final client = RestClient(dio);
      final HomeModelResponse homeData = await client.getHomeData();

      return right(homeData.toEntity());
    } catch (e) {
      LogHelper.logError(
        tag: "HomeService",
        message: "Error occurred while fetching home data: $e",
      );
      return const Left('An error occurred, Please try again.');
    }
  }
}
