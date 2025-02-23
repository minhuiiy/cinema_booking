import 'package:cinema_booking/domain/entities/response/home.dart';

class AllMoviesEntity {
  List<MovieDetailEntity> nowMovieing;
  List<MovieDetailEntity> comingSoon;
  List<MovieDetailEntity> exclusive;

  AllMoviesEntity({
    required this.nowMovieing,
    required this.comingSoon,
    required this.exclusive,
  });

  @override
  String toString() {
    return 'AllMoviesByTypeResponse{nowMovieing: $nowMovieing, comingSoon: $comingSoon, exclusive: $exclusive}';
  }
}
