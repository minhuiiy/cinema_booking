import 'package:cinema_booking/common/widgets/scroll_list/hoz_list_view.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/domain/entities/cast/movie_cast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetMovieCasts extends StatelessWidget {
  final List<MovieCastEntity> casts;

  const WidgetMovieCasts({
    super.key,
    required this.casts,
  });

  @override
  Widget build(BuildContext context) {
    List<ItemCast> items = casts.map((cast) => ItemCast.fromCast(cast)).toList();
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text('Crews & Casts', style: AppFont.medium_black2_14)),
              Expanded(
                  child: Text('View all >',
                      style: AppFont.regular_default_10, textAlign: TextAlign.right)),
            ],
          ),
          WidgetSpacer(height: 14),
          WrapContentHozListView(
            separatorBuilder: (context, index) {
              return WidgetSpacer(width: 14);
            },
            itemBuilder: (context, index) {
              var item = items[index];
              return WidgetItemCast(item: item);
            },
            list: items,
          ),
        ],
      ),
    );
  }
}

class WidgetItemCast extends StatelessWidget {
  final ItemCast item;

  const WidgetItemCast({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
//      height: 130,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: AspectRatio(
              aspectRatio: 85 / 117,
              child: Image.network(
                item.photo,
                fit: BoxFit.cover,
              ),
            ),
          ),
          WidgetSpacer(height: 5),
          Text(
            item.name,
            style: AppFont.regular_gray4_12,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class ItemCast {
  late String name;
  late String photo;

  ItemCast(this.name, this.photo);

  ItemCast.fromCast(MovieCastEntity cast) {
    name = cast.name;
    photo = cast.photo;
  }
}
