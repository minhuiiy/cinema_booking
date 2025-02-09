/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-22 08:47:28
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/widgets/image/shimmer_image.dart';
import 'package:cinema_booking/common/widgets/image/svg_image.dart';
import 'package:cinema_booking/common/widgets/scroll_list/hoz_list_view.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/domain/entities/movies/movies.dart';
import 'package:flutter/material.dart';

class WidgetHomePosters extends StatelessWidget {
  final List<ItemPosterVM> items;
  final String label;
  final String iconPath;

  const WidgetHomePosters({
    super.key,
    required this.items,
    required this.label,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              MySvgImage(
                path: iconPath,
                width: 20,
                height: 20,
                color: AppColors.black,
              ),
              WidgetSpacer(width: 6),
              Expanded(
                child: Text(label.toUpperCase(), style: AppFont.medium_black2_14),
              ),
              Expanded(
                child:
                    Text('View all', style: AppFont.medium_default_10, textAlign: TextAlign.right),
              )
            ],
          ),
          WidgetSpacer(height: 14),
          _buildListPoster(),
        ],
      ),
    );
  }

  _buildListPoster() {
    return WrapContentHozListView(
      itemBuilder: (context, index) {
        var item = items[index];

        return WidgetItemPoster(item: item);
      },
      separatorBuilder: (context, index) {
        return WidgetSpacer(width: 14);
      },
      list: items,
    );
  }
}

class WidgetItemPoster extends StatelessWidget {
  final ItemPosterVM item;

  const WidgetItemPoster({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openMovieDetails(item.movie, context);
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
            Text(item.title,
                style: AppFont.regular_black2_12, maxLines: 2, overflow: TextOverflow.ellipsis),
            WidgetSpacer(height: 2),
            Text(item.subTitle, style: AppFont.regular_gray6_10),
          ],
        ),
      ),
    );
  }

  void openMovieDetails(MovieEntity movie, BuildContext context) {
    // TODO:
  }
}

class ItemPosterVM {
  late String title;
  late String subTitle;
  late String photo;
  late MovieEntity movie;

  ItemPosterVM(this.photo, this.title, this.subTitle);

  ItemPosterVM.fromMovie(this.movie) {
    title = movie.name;
    subTitle = movie.tags.join(" - ");
    photo = movie.thumb;
  }
}
