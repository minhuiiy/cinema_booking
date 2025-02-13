part of 'movie_details_bloc.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();
}

class InitialMovieDetailsState extends MovieDetailsState {
  @override
  List<Object> get props => [];
}

class OpenBookTimeSlotScreen extends MovieDetailsState {
  final bool open;

  const OpenBookTimeSlotScreen({
    this.open = false,
  });

  @override
  List<Object> get props => [open];
}
