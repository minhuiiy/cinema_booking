part of 'movie_details_bloc.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();
}

class InitialMovieDetailsState extends MovieDetailsState {
  @override
  List<Object> get props => [];
}

class OpenBookTimeSlotScreen extends MovieDetailsState {
  bool open = false;

  OpenBookTimeSlotScreen({
    required this.open,
  });

  @override
  List<Object> get props => [];
}
