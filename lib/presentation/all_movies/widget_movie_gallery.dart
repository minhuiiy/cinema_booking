import 'package:cinema_booking/common/widgets/paint/rounded_rect_indicator.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/domain/entities/response/home.dart';
import 'package:cinema_booking/presentation/all_movies/bloc/all_movies_bloc.dart';
import 'package:cinema_booking/presentation/all_movies/list_movies/widget_list_movies.dart';
import 'package:flutter/material.dart';

class WidgetMovieGallery extends StatefulWidget {
  final Meta meta;

  const WidgetMovieGallery({super.key, required this.meta});

  @override
  State<WidgetMovieGallery> createState() => _WidgetMovieGalleryState();
}

class _WidgetMovieGalleryState extends State<WidgetMovieGallery>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int currentTabIndex = 0;

  @override
  void initState() {
    _controller = TabController(
      length: 3,
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {
        currentTabIndex = _controller.index;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildTabs(),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: <Widget>[
              _listMoviesToContent(widget.meta.nowMovieing),
              _listMoviesToContent(widget.meta.comingSoon),
              _listMoviesToContent(widget.meta.exclusive),
            ],
          ),
        )
      ],
    );
  }

  Widget _listMoviesToContent(List<MovieDetailEntity> movies) {
    if (movies.isNotEmpty) {
      return WidgetListMovie(movies.map((movie) => ItemMovieVM.fromMovie(movie)).toList());
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text('No data', style: AppFont.regular_gray4_14),
        ),
      );
    }
  }

  _buildTabs() {
    return DefaultTabController(
      length: 3,
      child: TabBar(
        controller: _controller,
        tabs: <Widget>[
          Tab(
            text: 'Now movieing',
          ),
          Tab(
            text: 'Coming soon',
          ),
          Tab(
            text: 'Exclusive',
          ),
        ],
        onTap: (index) {},
        labelColor: AppColors.defaultColor,
        labelStyle: AppFont.medium_default,
        unselectedLabelColor: AppColors.gray1.withValues(alpha: 0.7),
        unselectedLabelStyle: AppFont.regular_gray1_12,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: RoundedRectIndicator(
            color: AppColors.defaultColor, radius: 2, padding: 22, weight: 3.0),
      ),
    );
  }
}
