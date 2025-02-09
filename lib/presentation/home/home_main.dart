/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-21 21:28:06
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/presentation/home/bloc/home_bloc.dart';
import 'package:cinema_booking/presentation/home/home_banner/bloc/home_banner_bloc.dart';
import 'package:cinema_booking/presentation/home/home_banner/widget_home_banner.dart';
import 'package:cinema_booking/presentation/home/home_genres/bloc/home_genres_bloc.dart';
import 'package:cinema_booking/presentation/home/home_genres/widget_home_categories.dart';
import 'package:cinema_booking/presentation/home/home_movies_genres/bloc/home_movies_genres_bloc.dart';
import 'package:cinema_booking/presentation/home/home_movies_genres/widget_home_movies_genres.dart';
import 'package:cinema_booking/presentation/home/recommended_movies/bloc/recommended_movies_bloc.dart';
import 'package:cinema_booking/presentation/home/recommended_movies/widget_recommended_movies.dart';
import 'package:cinema_booking/presentation/home/widgets/widget_home_toolbar.dart';
import 'package:cinema_booking/presentation/home/widgets/widget_home_top_trending.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadHome());
  }

  /// **Bottom Navigation Bar**
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: AppColors.darkBackground,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent, // Màu đỏ khi chọn
        unselectedItemColor: Colors.white60, // Màu xám khi chưa chọn
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0, // Loại bỏ bóng
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 28),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 28),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 28),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var homeBloc = BlocProvider.of<HomeBloc>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBannerBloc(homeBloc: homeBloc)),
        BlocProvider(create: (context) => HomeGenresBloc(homeBloc: homeBloc)),
        BlocProvider(create: (context) => RecommendedMoviesBloc(homeBloc: homeBloc)),
        BlocProvider(create: (context) => HomeMoviesGenresBloc(homeBloc: homeBloc)),
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                color: AppColors.darkBackground,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    WidgetHomeToolbar(),
                    _buildContent(state),
                  ],
                ),
              ),
              bottomNavigationBar: _buildBottomNavigationBar(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(HomeState state) {
    Movie movie = Movie(
        imageUrl:
            "https://designercomvn.s3.ap-southeast-1.amazonaws.com/wp-content/uploads/2017/07/26020212/poster-phim-hanh-dong.jpg",
        progress: 0.5,
        title: "chung");

    List<Movie> movies = [
      movie,
      movie,
      movie,
      movie,
    ];

    if (state is HomeLoaded) {
      LogHelper.logDebug(tag: "HomeScreen", message: "HomeLoaded");
      return Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<HomeBloc>(context).add(RefreshHome());
          },
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              WidgetHomeBanner(),
              WidgetSpacer(height: 30),
              WidgetHomeGenres(),
              WidgetSpacer(height: 30),
              WidgetContinueWatching(movies: movies),
              WidgetSpacer(height: 30),
              WidgetRecommendedMovies(),
              WidgetSpacer(height: 30),
              // WidgetNearbyCine(),
              WidgetSpacer(height: 30),
              WidgetHomeMoviesGenres(),
              WidgetSpacer(height: 30),
            ],
          ),
        ),
      );
    } else if (state is HomeLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state is HomeNotLoaded) {
      return Expanded(
        child: Center(
          child: Text('Cannot load data'),
        ),
      );
    } else {
      return Expanded(
        child: Center(
          child: Text('Unknown state'),
        ),
      );
    }
  }
}
