/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2025-01-25 08:39:35
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/core/api/rest_client.dart';
import 'package:cinema_booking/data/models/response/all_movie_by_type_response.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:dartz/dartz.dart';

abstract class AllMoviesService {
  Future<Either> getAllMoviesData();
}

class AllMoviesServiceImpl extends AllMoviesService {
  @override
  Future<Either> getAllMoviesData() async {
    LogHelper.debug(tag: "AllMovieRepository", message: "getAllMovieData start ");

    try {
      LogHelper.debug(
        tag: "AllMovieRepository",
        message: "Making API request to fetch allMovies data",
      );
      final client = RestClient(localDio);
      LogHelper.debug(tag: "AllMovieRepository", message: "Making API request to getAllMovieData");
      final AllMoviesModelResponse allMoviesData = await client.getAllMoviesByType();

      // Log the actual response for debugging
      LogHelper.debug(
        tag: "AllMovieRepository",
        message: "Received allMovies data: ${allMoviesData.toEntity().toString()}",
      );

      return right(allMoviesData.toEntity());
    } catch (e, stackTrace) {
      LogHelper.error(
        tag: "AllMovieRepository",
        message: "Error occurred while fetching allMovies data: $e",
      );
      LogHelper.error(tag: "AllMovieRepository", message: "Stack trace: $stackTrace");
      return const Left('An error occurred, Please try again.');
    }
  }
}
