part of 'movie_details_bloc.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();
}

class OpenScreen extends MovieDetailsEvent {
  @override
  List<Object> get props => [];
}

class ClickBtnBook extends MovieDetailsEvent {
  MovieEntity movie;

  ClickBtnBook(this.movie);

  @override
  List<Object> get props => [movie];
}

class OpenedBookTimeSlotScreen extends MovieDetailsEvent {
  @override
  List<Object> get props => [];
}
