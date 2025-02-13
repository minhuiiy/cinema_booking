import 'package:cinema_booking/common/helpers/formatter_helpers.dart';
import 'package:cinema_booking/common/widgets/image/svg_image.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/domain/entities/response/home.dart';
import 'package:flutter/material.dart';

class WidgetMovieDesc extends StatelessWidget {
  final MovieDetailEntity movie;

  const WidgetMovieDesc({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: _buildMovieNameDate(),
              ),
              Expanded(
                flex: 1,
                child: _buildLikeVotes(),
              ),
            ],
          ),
          WidgetSpacer(height: 12),
          _buildTagList(),
          WidgetSpacer(height: 10),
          _buildExtraInfo(),
        ],
      ),
    );
  }

  _buildMovieNameDate() {
    final name = movie.detail.name;
    final textDate = movie.detail.releaseDate.MMM_dd_yyyy();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(name, style: AppFont.medium_black2_16),
        WidgetSpacer(height: 6),
        Text(textDate, style: AppFont.regular_gray4_12)
      ],
    );
  }

  _buildLikeVotes() {
    final textRating = "${movie.detail.rate}%";
    final textVotes = movie.detail.votes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                Icons.favorite,
                size: 20,
                color: AppColors.defaultColor,
              ),
            ),
            Text(textRating, style: AppFont.medium_black2_16)
          ],
        ),
        WidgetSpacer(height: 6),
        Text(textVotes, style: AppFont.regular_default_10)
      ],
    );
  }

  _buildTagList() {
    final List<Widget> itemTamis = [];
    itemTamis.add(Text('Tami', style: AppFont.regular_default_12));
    itemTamis.add(WidgetSpacer(width: 10));

    for (var tami in movie.format) {
      itemTamis.add(_buildTag(tami));
      itemTamis.add(WidgetSpacer(width: 6));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: itemTamis,
    );
  }

  _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      decoration: BoxDecoration(
          color: AppColors.white1,
          borderRadius: BorderRadius.circular(3),
          shape: BoxShape.rectangle),
      child: Center(
        child: Text(
          tag,
          style: AppFont.regular_default_12,
        ),
      ),
    );
  }

  _buildExtraInfo() {
    //'2h 59m'
    final textDuration = Duration(seconds: movie.detail.duration).formatHHmm();
    final textTag = movie.genres.join(", ").toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        MySvgImage(
          width: 10,
          height: 10,
          color: AppColors.gray1,
          path: 'assets/ic_clock_line.svg',
        ),
        WidgetSpacer(width: 6),
        Text(textDuration, style: AppFont.regular_gray1_10),
        WidgetSpacer(width: 9),
        MySvgImage(
          width: 10,
          height: 10,
          path: 'assets/ic_plays_line.svg',
          color: AppColors.gray1,
        ),
        WidgetSpacer(width: 6),
        Text(textTag, style: AppFont.regular_gray1_10),
      ],
    );
  }
}
