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
    LogHelper.logDebug(tag: "AllMovieRepository", message: "getAllMovieData start ");

    try {
      LogHelper.logDebug(
          tag: "AllMovieRepository", message: "Making API request to fetch allMovies data");
      final client = RestClient(localDio);
      LogHelper.logDebug(
          tag: "AllMovieRepository", message: "Making API request to getAllMovieData");
      final AllMoviesModelResponse allMoviesData = await client.getAllMoviesByType();

      // Log the actual response for debugging
      LogHelper.logDebug(
        tag: "AllMovieRepository",
        message: "Received allMovies data: ${allMoviesData.toJson()}",
      );

      return right(allMoviesData);
    } catch (e, stackTrace) {
      LogHelper.logError(
        tag: "AllMovieRepository",
        message: "Error occurred while fetching allMovies data: $e",
      );
      LogHelper.logError(tag: "AllMovieRepository", message: "Stack trace: $stackTrace");
      return const Left('An error occurred, Please try again.');
    }
  }
}
