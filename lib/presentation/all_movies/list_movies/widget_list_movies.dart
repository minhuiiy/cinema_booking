import 'package:cinema_booking/common/widgets/image/shimmer_image.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/domain/entities/response/home.dart';
import 'package:cinema_booking/presentation/router.dart';
import 'package:flutter/material.dart';

class WidgetListMovie extends StatelessWidget {
  final List<ItemMovieVM> items;

  const WidgetListMovie(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 10,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shrinkWrap: true,
      childAspectRatio: 150 / 250,
      physics: BouncingScrollPhysics(),
      children: items.map(
        (item) {
          return _WidgetItemMovie(item: item);
        },
      ).toList(),
    );
  }
}

class _WidgetItemMovie extends StatelessWidget {
  final ItemMovieVM item;

  const _WidgetItemMovie({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openMovieDetails(item.movie, context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ShimmerImage(
                url: item.photo,
                aspectRatio: 150 / 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          WidgetSpacer(height: 6),
          Text(item.title,
              style: AppFont.regular_black2_14, maxLines: 1, overflow: TextOverflow.ellipsis),
          WidgetSpacer(height: 2),
          Row(
            children: <Widget>[
              Icon(
                Icons.favorite,
                color: AppColors.defaultColor,
                size: 16,
              ),
              WidgetSpacer(width: 6),
              Text('${item.likePercent}%', style: AppFont.regular_gray6_12)
            ],
          ),
        ],
      ),
    );
  }

  void openMovieDetails(MovieDetailEntity movie, BuildContext context) {
    Navigator.pushNamed(context, AppRouter.MOVIE, arguments: movie);
  }
}

class ItemMovieVM {
  late MovieDetailEntity movie;
  late String photo;
  late String title;
  late int likePercent;

  ItemMovieVM(this.photo, this.title, this.likePercent);

  ItemMovieVM.fromMovie(MovieDetailEntity movieDetail) {
    movie = movieDetail;
    photo = movie.detail.thumb;
    title = movie.detail.name;
    likePercent = movie.detail.rate;
  }
}
