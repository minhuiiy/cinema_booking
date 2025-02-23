/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-17 21:30:56
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

// ignore_for_file: constant_identifier_names
import 'package:cinema_booking/domain/entities/movies/movies.dart';
import 'package:cinema_booking/domain/entities/response/home.dart';
import 'package:cinema_booking/presentation/all_movies/sc_all_movies.dart';
import 'package:cinema_booking/presentation/all_tickets/screen_all_tickets.dart';
import 'package:cinema_booking/presentation/booking_seat_slot/book_seat_slot_screen.dart';
import 'package:cinema_booking/presentation/booking_seat_type/book_seat_type_screen.dart';
import 'package:cinema_booking/presentation/booking_time_slot/book_time_slot_main.dart';
import 'package:cinema_booking/presentation/home/home_main.dart';
import 'package:cinema_booking/presentation/login/login.dart';
import 'package:cinema_booking/presentation/register/register.dart';
import 'package:cinema_booking/presentation/movie_detail/movie_detail_info.dart';
import 'package:cinema_booking/presentation/splash/splash.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String HOME = '/';
  static const String SPLASH = '/splash';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String MOVIE = '/movie';
  static const String BOOK_TIME_SLOT = '/bookTimeSlot';
  static const String ALL_MOVIES = '/allMovies';
  static const String BOOK_SEAT_TYPE = '/bookSeatType';
  static const String BOOK_SEAT_SLOT = '/bookSeatSlot';
  static const String LIST_TICKETS = '/listTickets';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HOME:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case SPLASH:
        return MaterialPageRoute(builder: (_) => SplashPage());

      case LOGIN:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case REGISTER:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case BOOK_TIME_SLOT:
        var movie = settings.arguments as MovieEntity;
        return MaterialPageRoute(builder: (_) => BookTimeSlotScreen(movie: movie));

      case MOVIE:
        var movieDetail = settings.arguments as MovieDetailEntity;
        return MaterialPageRoute(builder: (_) => MovieInfoScreen(movie: movieDetail));

      case ALL_MOVIES:
        return MaterialPageRoute(builder: (_) => AllMoviesScreen());

      case BOOK_SEAT_TYPE:
        return MaterialPageRoute(builder: (_) => BookSeatTypeScreen());

      case BOOK_SEAT_SLOT:
        final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(builder: (_) => BookSeatSlotScreen(args: args));

      case LIST_TICKETS:
        return MaterialPageRoute(builder: (_) => ListTicketsScreen());

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))),
        );
    }
  }
}
