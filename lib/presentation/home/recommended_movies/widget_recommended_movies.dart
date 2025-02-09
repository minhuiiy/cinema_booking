/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-21 21:28:06
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/widgets/image/shimmer_image.dart';
import 'package:cinema_booking/common/widgets/scroll_list/hoz_list_view.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/domain/entities/movies/movies.dart';
import 'package:cinema_booking/presentation/home/recommended_movies/bloc/recommended_movies_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetRecommendedMovies extends StatefulWidget {
  const WidgetRecommendedMovies({super.key});

  @override
  State<WidgetRecommendedMovies> createState() => _WidgetRecommendedMoviesState();
}

class _WidgetRecommendedMoviesState extends State<WidgetRecommendedMovies> {
  late List<ItemRecommendedSeatVM> items;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendedMoviesBloc, RecommendedMoviesState>(
      builder: (context, state) {
        if (state is RecommendedMoviesLoaded) {
          items = state.movies.map((movie) => ItemRecommendedSeatVM.fromShow(movie)).toList();

          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Recommended Movies'.toUpperCase(), style: AppFont.medium_black2_14),
                WidgetSpacer(height: 14),
                _buildListRecommendedMovies(),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildListRecommendedMovies() {
    return WrapContentHozListView(
      list: items,
      itemBuilder: (context, index) {
        var item = items[index];

        return _WidgetItemRecommendedSeat(item);
      },
      separatorBuilder: (context, index) {
        return WidgetSpacer(width: 14);
      },
    );
  }
}

class _WidgetItemRecommendedSeat extends StatelessWidget {
  final ItemRecommendedSeatVM item;

  const _WidgetItemRecommendedSeat(this.item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openShowDetails(context);
      },
      child: SizedBox(
        width: 93,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ShimmerImage(
                url: item.photo,
                width: 93,
                height: 124,
                fit: BoxFit.cover,
              ),
            ),
            WidgetSpacer(height: 4),
            Text(
              item.title,
              style: AppFont.regular_black2_12,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            WidgetSpacer(height: 2),
            Row(
              children: <Widget>[
                Icon(
                  Icons.favorite,
                  color: AppColors.defaultColor,
                  size: 14,
                ),
                WidgetSpacer(width: 6),
                Text('${item.likePercent}%', style: AppFont.regular_gray6_10)
              ],
            ),
          ],
        ),
      ),
    );
  }

  void openShowDetails(BuildContext context) {
    // TODO:
  }
}

class ItemRecommendedSeatVM {
  late String photo;
  late String title;
  late int likePercent;
  MovieEntity movie;

  ItemRecommendedSeatVM.fromShow(this.movie) {
    photo = movie.thumb;
    title = movie.name;
    likePercent = movie.rate;
  }
}
