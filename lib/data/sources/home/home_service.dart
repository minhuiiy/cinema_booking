/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-25 08:39:35
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/core/api/rest_client.dart';
import 'package:cinema_booking/data/models/response/home_response.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:dartz/dartz.dart';

abstract class HomeService {
  Future<Either> getHomeData();
}

class HomeServiceImpl extends HomeService {
  @override
  Future<Either> getHomeData() async {
    try {
      LogHelper.debug(tag: "HomeService", message: "Making API request to fetch home data");
      final client = RestClient(localDio);
      final HomeModelResponse homeData = await client.getHomeData();

      return right(homeData.toEntity());
    } catch (e) {
      LogHelper.error(tag: "HomeService", message: "Error occurred while fetching home data: $e");
      return const Left('An error occurred, Please try again.');
    }
  }
}
