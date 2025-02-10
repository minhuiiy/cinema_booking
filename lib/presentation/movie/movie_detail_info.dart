import 'package:cinema_booking/common/widgets/image/svg_image.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/domain/entities/cast/movie_cast.dart';
import 'package:cinema_booking/domain/entities/movies/movies.dart';
// import 'package:cinema_booking/presentation/router.dart';
import 'package:cinema_booking/presentation/movie/bloc/movie_details_bloc.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_offers.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_movie_casts.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_movie_desc.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_movie_review.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_video_player.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class MovieInfoScreen extends StatelessWidget {
  final MovieEntity movie;
  final List<MovieCastEntity> casts;

  const MovieInfoScreen({
    super.key,
    required this.movie,
    required this.casts,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<MovieDetailsBloc>(
        create: (context) => MovieDetailsBloc(),
        child: BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
          buildWhen: (prev, current) {
            return current is InitialMovieDetailsState;
          },
          listenWhen: (prev, current) {
            return current is OpenBookTimeSlotScreen;
          },
          listener: (context, state) {
            openBookCineTimeSlot(context);
          },
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  ListView(
                    children: <Widget>[
                      WidgetVideoPlayer(videoUrl: movie.trailer),
                      WidgetMovieDesc(movie: movie),
                      WidgetSpacer(height: 14),
                      WidgetOffers(movie: movie),
                      WidgetSpacer(height: 14),
                      WidgetMovieReview(movie: movie),
                      WidgetSpacer(height: 14),
                      WidgetMovieCasts(casts: casts),
                      WidgetSpacer(height: 70),
                    ],
                  ),
                  _buildBtnBookSeat(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _buildBtnBookSeat(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: SizedBox(
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.defaultColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MySvgImage(
                width: 18.25,
                height: 16.1,
                path: 'assets/ic_sofa.svg',
              ),
              WidgetSpacer(width: 5),
              Text('Book seats', style: AppFont.medium_white_16),
            ],
          ),
          onPressed: () {
            BlocProvider.of<MovieDetailsBloc>(context).add(ClickBtnBook(movie));
          },
        ),
      ),
    );
  }

  void openBookCineTimeSlot(BuildContext context) {
    // BlocProvider.of<MovieDetailsBloc>(context).add(OpenedBookTimeSlotScreen());
    // Navigator.pushNamed(context, AppRouter.BOOK_TIME_SLOT, arguments: movie);
  }
}
