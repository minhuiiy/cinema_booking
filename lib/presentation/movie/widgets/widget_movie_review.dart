import 'package:cinema_booking/common/helpers/formatter_helpers.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/domain/entities/movies/movies.dart';
import 'package:flutter/material.dart';

class WidgetMovieReview extends StatelessWidget {
  MovieEntity movie;

  WidgetMovieReview({required this.movie});

  @override
  Widget build(BuildContext context) {
    String textReviews = "${movie.totalReviews.formatDecimalThousand()} reviews";
    String authorAvatar = movie.latestReviews.avatar;
    String authorName = movie.latestReviews.author;
    String content = movie.latestReviews.content;
    String textDate = movie.latestReviews.created.MMM_dd_yyyy();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(color: AppColors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                textReviews,
                style: AppFont.medium_black2_14,
              )),
              Expanded(
                  child: Text('Write yours >',
                      style: AppFont.regular_default_10, textAlign: TextAlign.right)),
            ],
          ),
          WidgetSpacer(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    authorAvatar,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              WidgetSpacer(width: 8),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(authorName, style: AppFont.medium_gray4_10),
                        WidgetSpacer(width: 6),
                        Text(textDate, style: AppFont.regular_gray1_50_9),
                      ],
                    ),
                    Text(content, style: AppFont.regular_gray4_10)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
