part of 'all_movies_bloc.dart';

class AllMoviesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OpenScreen extends AllMoviesEvent {}

class ClickIconSearch extends AllMoviesEvent {}

class ClickCloseSearch extends AllMoviesEvent {}

class SearchQueryChanged extends AllMoviesEvent {
  final String keyword;

  SearchQueryChanged({required this.keyword});

  @override
  List<Object> get props => [keyword];

  @override
  String toString() {
    return 'SearchQueryChanged{keyword: $keyword}';
  }
}

class ClickIconSort extends AllMoviesEvent {
  @override
  List<Object> get props => [DateTime.now().millisecond];
}

class SortByChanged extends AllMoviesEvent {
  MovieSoftBy movieSortBy;

  SortByChanged(this.movieSortBy);

  @override
  List<Object> get props => [movieSortBy];

  @override
  String toString() {
    return 'SortByChanged{movieSortBy: $movieSortBy}';
  }
}
