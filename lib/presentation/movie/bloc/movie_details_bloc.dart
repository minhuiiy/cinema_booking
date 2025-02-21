import 'package:cinema_booking/domain/entities/movies/movies.dart';
import 'package:cinema_booking/domain/usecase/movie/cache_movie_info_data.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc() : super(InitialMovieDetailsState()) {
    on<OpenScreen>(_onOpenScreen);
    on<ClickBtnBook>(_onClickBtnBook);
    on<OpenedBookTimeSlotScreen>(_onOpenedBookTimeSlotScreen);
  }

  void _onOpenScreen(OpenScreen event, Emitter<MovieDetailsState> emit) {
    emit(InitialMovieDetailsState());
  }

  Future<void> _onClickBtnBook(
    ClickBtnBook event,
    Emitter<MovieDetailsState> emit,
  ) async {
    var response = await sl<CacheMovieInfoDataUseCase>().call(
      movie: event.movie,
    );

    response.fold(
      (l) {
        emit(OpenBookTimeSlotScreen(open: false));
      },
      (r) {
        emit(OpenBookTimeSlotScreen(open: true));
      },
    );
  }

  void _onOpenedBookTimeSlotScreen(
    OpenedBookTimeSlotScreen event,
    Emitter<MovieDetailsState> emit,
  ) {
    emit(OpenBookTimeSlotScreen(open: false));
    emit(InitialMovieDetailsState());
  }
}
