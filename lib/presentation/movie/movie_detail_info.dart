import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/domain/entities/response/home.dart';
import 'package:cinema_booking/presentation/movie/bloc/movie_details_bloc.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_movie_casts.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_movie_desc.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_movie_review.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_offers.dart';
import 'package:cinema_booking/presentation/movie/widgets/widget_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieInfoScreen extends StatelessWidget {
  final MovieDetailEntity movie;

  const MovieInfoScreen({
    super.key,
    required this.movie,
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

  void openBookCineTimeSlot(BuildContext context) {
    // BlocProvider.of<MovieDetailsBloc>(context).add(OpenedBookTimeSlotScreen());
    // Navigator.pushNamed(context, AppRouter.BOOK_TIME_SLOT, arguments: movie);
  }
}

class CinematicBookTicketButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CinematicBookTicketButton({super.key, required this.onPressed});

  @override
  State<CinematicBookTicketButton> createState() => _CinematicBookTicketButtonState();
}

class _CinematicBookTicketButtonState extends State<CinematicBookTicketButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        height: isPressed ? 50 : 54, // Slightly shrink on press
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
