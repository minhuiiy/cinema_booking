/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-21 21:28:06
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/widgets/image/svg_image.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/assets/app_vectors.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/domain/entities/genres/genres.dart';
import 'package:cinema_booking/presentation/home/home_genres/bloc/home_genres_bloc.dart';
import 'package:cinema_booking/presentation/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetHomeGenres extends StatefulWidget {
  const WidgetHomeGenres({super.key});

  @override
  State<WidgetHomeGenres> createState() => _WidgetHomeGenresState();
}

class _WidgetHomeGenresState extends State<WidgetHomeGenres> {
  List<ItemGenresVM> items = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeGenresBloc, HomeGenresState>(
      builder: (context, state) {
        if (state is HomeGenresLoaded) {
          items = state.genres.map((genres) => ItemGenresVM.fromGenres(genres)).toList();

          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Movie Genres'.toUpperCase(),
                  style: AppFont.medium_black2_18.copyWith(fontSize: 14),
                ),
                WidgetSpacer(height: 14),
                _buildListgenres(),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildListgenres() {
    return SizedBox(
      height: 58,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var item = items[index];

            return WidgetItemGenres(item: item);
          },
          separatorBuilder: (context, index) {
            return WidgetSpacer(width: 30);
          },
          physics: BouncingScrollPhysics(),
          itemCount: items.length,
        ),
      ),
    );
  }
}

class WidgetItemGenres extends StatelessWidget {
  final ItemGenresVM item;

  const WidgetItemGenres({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openAllMovies(context);
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 34,
            height: 34,
            child: Center(
              child: MySvgImage(path: item.image, width: 28, height: 28, applyColorFilter: false),
            ),
          ),
          WidgetSpacer(height: 4),
          Text(item.title, style: AppFont.regular_gray1_14.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  void openAllMovies(BuildContext context) {
    Navigator.pushNamed(context, AppRouter.ALL_MOVIES);
  }
}

class ItemGenresVM {
  GenresEntity genres;
  late String image;
  late String title;

  ItemGenresVM.fromGenres(this.genres) {
    image = AppVectors.basePath + genres.icon.toString();
    title = genres.name;
  }
}
