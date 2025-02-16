// ignore_for_file: must_be_immutable

import 'package:cinema_booking/common/widgets/image/svg_image.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/domain/entities/show_time/time_slot.dart';
import 'package:cinema_booking/presentation/booking/book_time_slot/bloc/book_time_slot_bloc.dart';
import 'package:cinema_booking/presentation/booking/book_time_slot/sc_book_time_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetCineTimeSlot extends StatelessWidget {
  final ItemCineTimeSlot item;
  int selectedIndex = -1;
  bool movieCineName = true;
  bool movieCineDot = true;

  WidgetCineTimeSlot(this.item, {super.key});

  WidgetCineTimeSlot.selected({
    super.key,
    required this.item,
    required this.selectedIndex,
    required this.movieCineName,
    required this.movieCineDot,
  });

  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 7),
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          movieCineName
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(item.cineName, style: AppFont.medium_blue_14),
                    ),
                    GestureDetector(
                      onTap: () {
                        _openCineLocation();
                      },
                      child:
                          Icon(Icons.info_outline, color: AppColors.gray1.withValues(alpha: 0.50)),
                    ),
                  ],
                )
              : Container(),
          WidgetSpacer(height: 4),
          Row(
            children: <Widget>[
              movieCineDot
                  ? MySvgImage(
                      path: 'assets/ic_cine_dot.svg',
                      width: 9.94,
                      height: 12,
                      color: AppColors.gray1,
                    )
                  : Container(),
              WidgetSpacer(width: movieCineDot ? 7 : 0),
              Expanded(
                child: Text(
                  item.textLocation,
                  style: AppFont.regular_gray1_12,
                  maxLines: 2,
                ),
              ),
              WidgetSpacer(width: 11),
              Text("${item.textDistance} miles away", style: AppFont.regular_black2_10),
            ],
          ),
          WidgetSpacer(height: 16),
          Wrap(
            children: <Widget>[
              for (final timeSlot in item.timeSlots)
                _WidgetTimeSlot(
                  timeSlot,
                  item.timeSlots.indexOf(timeSlot) == selectedIndex,
                  selectedIndex != -1,
                  (selectedTimeSlot) {
                    BlocProvider.of<BookTimeSlotBloc>(_context).add(
                      SelectTimeSlot(
                        selectedTimeSlot: selectedTimeSlot,
                        bookTimeSlot: item.bookTimeSlot,
                      ),
                    );
                  },
                )
            ],
          )
        ],
      ),
    );
  }

  _openCineLocation() {
    // movieModalBottomSheet(
    //   context: _context,
    //   backgroundColor: Colors.transparent,
    //   isScrollControlled: true,
    //   builder: (context) {
    //     return CineLocationScreen();
    //   },
    // );
  }
}

class _WidgetTimeSlot extends StatelessWidget {
  ItemTimeSlot item;
  bool isSelected;
  bool isSmallMode;

  Function(TimeSlotEntity) itemClick;

  _WidgetTimeSlot(
    this.item,
    this.isSelected,
    this.isSmallMode,
    this.itemClick,
  );

  @override
  Widget build(BuildContext context) {
    var itemWidth = 99.0;
    var fontSize = 14.0;
    var textPaddingHoz = 10.0;

    var textStyle = AppFont.regular_black2_14;
    var timeColor = item.hour % 2 == 0 ? AppColors.green : AppColors.orange;
    if (!item.active) {
      timeColor = AppColors.timeSlotBorder;
    }

    var itemBg = isSelected ? AppColors.green : AppColors.timeSlotBg;
    var itemBorder = isSelected ? Colors.transparent : AppColors.timeSlotBorder;

    if (isSelected) {
      timeColor = AppColors.white;
      textStyle = AppFont.medium_white_14;
    }

    if (isSmallMode) {
      itemWidth = 84.0;
      fontSize = 12.0;
    }

    return GestureDetector(
      onTap: () {
        if (!isSmallMode) {
          itemClick(item.timeSlot);
        }
      },
      child: Container(
        width: itemWidth,
        padding: EdgeInsets.symmetric(vertical: textPaddingHoz),
        margin: EdgeInsets.only(right: 13, bottom: 13),
        decoration: BoxDecoration(
            border: Border.all(
              color: itemBorder,
              width: 0.5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: itemBg),
        child: Center(
          child: Text(
            item.time,
            style: textStyle.copyWith(color: timeColor, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}

class ItemTimeSlot {
  String time;
  int hour;
  bool active = false;
  bool selected = false;

  late TimeSlotEntity timeSlot;

  ItemTimeSlot({
    required this.time,
    required this.hour,
    required this.active,
  });

  ItemTimeSlot.fromTimeSlot({required this.timeSlot})
      : time = timeSlot.time,
        hour = timeSlot.hour,
        active = timeSlot.active;
}
