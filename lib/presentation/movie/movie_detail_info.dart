import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/domain/entities/response/home.dart';
import 'package:cinema_booking/presentation/movie/bloc/movie_details_bloc.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_movie_casts.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_movie_desc.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_movie_review.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_offers.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_video_player.dart';
import 'package:cinema_booking/presentation/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieInfoScreen extends StatelessWidget {
  final MovieDetailEntity movie;

  const MovieInfoScreen({super.key, required this.movie});

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
                      WidgetVideoPlayer(videoUrl: movie.detail.trailer),
                      WidgetMovieDesc(movie: movie),
                      WidgetSpacer(height: 14),
                      WidgetOffers(movie: movie),
                      WidgetSpacer(height: 14),
                      WidgetMovieReview(movie: movie),
                      WidgetSpacer(height: 14),
                      WidgetMovieCasts(casts: movie.casts),
                      WidgetSpacer(height: 70),
                    ],
                  ),
                  _buildBtnBookTicket(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _buildBtnBookTicket(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 14,
      left: 14,
      child: CinematicBookTicketButton(
        onPressed: () {
          BlocProvider.of<MovieDetailsBloc>(context).add(ClickBtnBook(movie.detail));
        },
      ),
    );
  }

  // _buildBtnBookTicket(BuildContext context) {
  //   return Positioned(
  //     bottom: 0,
  //     right: 0,
  //     left: 0,
  //     child: Container(
  //       height: 54,
  //       child: ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: AppColors.defaultColor,
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             MySvgImage(
  //               width: 18.25,
  //               height: 16.1,
  //               path: 'assets/vectors/ic_sofa.svg',
  //             ),
  //             WidgetSpacer(width: 5),
  //             Text('Book seats', style: AppFont.medium_white_16),
  //           ],
  //         ),
  //         onPressed: () {
  //           BlocProvider.of<MovieDetailsBloc>(context).add(ClickBtnBook(movie.detail));
  //         },
  //       ),
  //     ),
  //   );
  // }

  void openBookCineTimeSlot(BuildContext context) {
    LogHelper.logDebug(tag: "openBookCineTimeSlot", message: "start");
    // BlocProvider.of<MovieDetailsBloc>(context).add(OpenedBookTimeSlotScreen());
    LogHelper.logDebug(tag: "openBookCineTimeSlot", message: "BlocProvider Done");
    Navigator.pushNamed(context, AppRouter.BOOK_TIME_SLOT, arguments: movie.detail);
  }
}

class CinematicBookTicketButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CinematicBookTicketButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFFE91E63)], // Purple to Pink gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: -2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.event_seat, color: Colors.white, size: 22), // Sofa Icon
              SizedBox(width: 8),
              Text(
                'BOOK SEATS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
