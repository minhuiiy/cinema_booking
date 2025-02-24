import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/core/enum/sort_movie.dart';
import 'package:cinema_booking/presentation/all_movies/bloc/all_movies_bloc.dart';
import 'package:cinema_booking/presentation/all_movies/widgets/widget_all_movies_toolbar.dart';
import 'package:cinema_booking/presentation/all_movies/widgets/widget_movie_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllMoviesScreen extends StatefulWidget {
  const AllMoviesScreen({super.key});

  @override
  State<AllMoviesScreen> createState() => _AllMoviesScreenState();
}

class _AllMoviesScreenState extends State<AllMoviesScreen> {
  // Khởi tạo LogHelper

  @override
  Widget build(BuildContext context) {
    LogHelper.debug(
      tag: "AllMoviesScreen",
      message: "Building AllMoviesScreen...",
    );
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<AllMoviesBloc>(
          create: (context) => AllMoviesBloc()..add(OpenScreen()),
          child: Column(
            children: <Widget>[
              WidgetAllMoviesToolbar(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    LogHelper.debug(
      tag: "AllMoviesScreen",
      message: "Building content for AllMoviesScreen...",
    );
    return BlocConsumer<AllMoviesBloc, AllMoviesState>(
      listenWhen: (prev, current) {
        return current is OpenSortOption;
      },
      listener: (context, state) {
        if (state is OpenSortOption) {
          LogHelper.debug(
            tag: "AllMoviesScreen",
            message: "Sorting options opened",
          );
          _openSortByOptions(context, state.movieSortBy);
        }
      },
      buildWhen: (prev, current) {
        return current is! UpdateToolbarState && current is! OpenSortOption;
      },
      builder: (context, state) {
        LogHelper.debug(tag: "AllMoviesScreen", message: "state: $state");
        if (state is DisplayListMovies) {
          if (state.loading) {
            LogHelper.debug(
              tag: "AllMoviesScreen",
              message: "Loading data for display...",
            );
            return Center(child: CircularProgressIndicator());
          }

          if (state.msg != null) {
            LogHelper.debug(
              tag: "AllMoviesScreen",
              message: "Displaying error message: ${state.msg}",
            );
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(state.msg!, style: AppFont.regular_gray4_14),
              ),
            );
          }

          if (state.meta != null) {
            LogHelper.debug(
              tag: "AllMoviesScreen",
              message: "Displaying movie gallery with meta data",
            );
            return WidgetMovieGallery(meta: state.meta!);
          }

          return Container();
        } else {
          LogHelper.debug(
            tag: "AllMoviesScreen",
            message: "No relevant state to display.",
          );
          return Container();
        }
      },
    );
  }

  Future<void> _openSortByOptions(
    BuildContext context,
    MovieSoftBy movieSortBy,
  ) async {
    LogHelper.debug(
      tag: "AllMoviesScreen",
      message: "Opening sort options dialog with current sortBy: $movieSortBy",
    );
    switch (await showDialog<MovieSoftBy>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Sort by'),
          children: <Widget>[
            SimpleDialogOption(
              child: RadioListTile(
                title: Text('Rating', style: AppFont.regular_black2_14),
                value: MovieSoftBy.ratting,
                groupValue: movieSortBy,
                onChanged: (value) {
                  LogHelper.debug(
                    tag: "AllMoviesScreen",
                    message: "Sorting by Rating",
                  );
                  Navigator.pop(context, value);
                },
              ),
            ),
            SimpleDialogOption(
              child: RadioListTile(
                title: Text('Name', style: AppFont.regular_black2_14),
                value: MovieSoftBy.name,
                groupValue: movieSortBy,
                onChanged: (value) {
                  LogHelper.debug(
                    tag: "AllMoviesScreen",
                    message: "Sorting by Name",
                  );
                  Navigator.pop(context, value);
                },
              ),
            ),
          ],
        );
      },
    )) {
      case MovieSoftBy.name:
        LogHelper.debug(
          tag: "AllMoviesScreen",
          message: "Sorting by NAME selected",
        );
        BlocProvider.of<AllMoviesBloc>(
          context,
        ).add(SortByChanged(MovieSoftBy.name));
        break;
      case MovieSoftBy.ratting:
        LogHelper.debug(
          tag: "AllMoviesScreen",
          message: "Sorting by RATING selected",
        );
        BlocProvider.of<AllMoviesBloc>(
          context,
        ).add(SortByChanged(MovieSoftBy.ratting));
        break;
      case null:
        LogHelper.debug(
          tag: "AllMoviesScreen",
          message: "No sort option selected",
        );
    }
  }
}
