/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-25 08:39:35
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/core/api/rest_client.dart';
import 'package:cinema_booking/data/models/cinema/cinema.dart';
import 'package:cinema_booking/data/models/response/home_response.dart';
import 'package:cinema_booking/data/models/response/movie_by_genres_response.dart';
import 'package:cinema_booking/data/models/response/movie_detail_response.dart';
import 'package:cinema_booking/domain/entities/response/home.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:dartz/dartz.dart';

abstract class HomeService {
  Future<Either> getHomeData();
}

class HomeServiceImpl extends HomeService {
  @override
  Future<Either> getHomeData() async {
    try {
      final client = RestClient(localDio);
      final HomeModelResponse homeData = await client.getHomeData();

      // Ghi đè nearby_cinemas bằng mock TP.HCM
      final HomeEntity home = HomeEntity(
        banners: homeData.toBannersEntity(),
        genres: homeData.toGenresEntity(),
        recommendedMovies: homeData.recommendedMovies
                ?.map((movieModel) => movieModel.toEntity())
                .toList() ??
            [],
        nearbyCinemas: CinemaModel.mockData.toEntities(),
        movieByGenres:
            homeData.movieByGenres
                    ?.map((MovieByGenresResponse r) => r.toEntity())
                    .toList() ??
            [],
      );

      return right(home);
    } catch (e) {
      return const Left('An error occurred in getHomeData, Please try again.');
    }
  }
}
