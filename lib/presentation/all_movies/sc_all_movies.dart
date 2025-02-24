import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
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
    LogHelper.debug(tag: "AllMoviesScreen", message: "Building AllMoviesScreen...");
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<AllMoviesBloc>(
          create: (context) => AllMoviesBloc()..add(OpenScreen()),
          child: Column(
            children: <Widget>[WidgetAllMoviesToolbar(), Expanded(child: _buildContent())],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    LogHelper.debug(tag: "AllMoviesScreen", message: "Building content for AllMoviesScreen...");
    return BlocConsumer<AllMoviesBloc, AllMoviesState>(
      listenWhen: (prev, current) {
        return current is OpenSortOption;
      },
      listener: (context, state) {
        if (state is OpenSortOption) {
          LogHelper.debug(tag: "AllMoviesScreen", message: "Sorting options opened");
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
            LogHelper.debug(tag: "AllMoviesScreen", message: "Loading data for display...");
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
          LogHelper.debug(tag: "AllMoviesScreen", message: "No relevant state to display.");
          return Container();
        }
      },
    );
  }

  Future<void> _openSortByOptions(BuildContext context, MovieSoftBy movieSortBy) async {
    LogHelper.debug(
      tag: "AllMoviesScreen",
      message: "Opening sort options dialog with current sortBy: $movieSortBy",
    );

    switch (await showDialog<MovieSoftBy>(
      context: context,
      barrierDismissible: true, // Allow tapping outside to close
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.black.withValues(alpha: 0.8), // Cinematic dark theme
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black87.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sort by',
                  style: AppFont.semibold_white_18.copyWith(fontSize: 22, letterSpacing: 1.2),
                ),
                const SizedBox(height: 10),
                _buildSortOption(context, '⭐ Rating', MovieSoftBy.ratting, movieSortBy),
                _buildSortOption(context, '🎬 Name', MovieSoftBy.name, movieSortBy),
              ],
            ),
          ),
        );
      },
    )) {
      case MovieSoftBy.name:
        LogHelper.debug(tag: "AllMoviesScreen", message: "Sorting by NAME selected");
        BlocProvider.of<AllMoviesBloc>(context).add(SortByChanged(MovieSoftBy.name));
        break;
      case MovieSoftBy.ratting:
        LogHelper.debug(tag: "AllMoviesScreen", message: "Sorting by RATING selected");
        BlocProvider.of<AllMoviesBloc>(context).add(SortByChanged(MovieSoftBy.ratting));
        break;
      case null:
        LogHelper.debug(tag: "AllMoviesScreen", message: "No sort option selected");
    }
  }

  // Helper function for a cinematic style
  Widget _buildSortOption(
    BuildContext context,
    String title,
    MovieSoftBy value,
    MovieSoftBy groupValue,
  ) {
    bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => Navigator.pop(context, value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.defaultColor.withValues(alpha: .6) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.defaultColor : Colors.grey.shade600,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.defaultColor.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                  : [],
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.defaultColor : Colors.white70,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppFont.regular_white_14.copyWith(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
