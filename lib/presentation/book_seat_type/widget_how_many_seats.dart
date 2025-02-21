import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/data/models/seats/seat_type.dart';
import 'package:cinema_booking/domain/entities/seats/seat_type.dart';
import 'package:cinema_booking/presentation/book_seat_type/bloc/book_seat_type_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetHowManySeats extends StatefulWidget {
  const WidgetHowManySeats({super.key});

  @override
  State<WidgetHowManySeats> createState() => _WidgetHowManySeatsState();
}

class _WidgetHowManySeatsState extends State<WidgetHowManySeats> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          WidgetSpacer(height: 34),
          Text('How many seats ?', style: AppFont.regular_blue_16),
          WidgetSpacer(height: 37),
          Image.asset("assets/images/motor.png", height: 90.57),
          WidgetSpacer(height: 30),
          WidgetNumberSeatPicker(),
          WidgetSeatTypePicker(),
          WidgetSpacer(height: 54),
        ],
      ),
    );
  }
}

/// WidgetSeatTypePicker
class WidgetSeatTypePicker extends StatefulWidget {
  final List<SeatTypeEntity> seatTypes = SeatTypesModel.SAMPLE_DATA.toEntities();

  WidgetSeatTypePicker({super.key});

  @override
  State<WidgetSeatTypePicker> createState() => _WidgetSeatTypePickerState();
}

class _WidgetSeatTypePickerState extends State<WidgetSeatTypePicker> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 19, vertical: 40),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 137, maxHeight: 237),
        child: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: widget.seatTypes.length,
          scrollDirection: Axis.vertical,
          childAspectRatio: 94 / 137,
          crossAxisSpacing: 19,
          children: <Widget>[for (final seatType in widget.seatTypes) _buildItemSeatType(seatType)],
        ),
      ),
    );
  }

  _buildItemSeatType(SeatTypeEntity seatType) {
    var index = widget.seatTypes.indexOf(seatType);
    var isSelected = index == _selectedIndex;

    String textStatus = index == 0 ? 'Filling fast' : 'Available';
    var itemBg = isSelected ? AppColors.green : AppColors.timeSlotBg;
    var itemBorder = isSelected ? Colors.transparent : AppColors.timeSlotBorder;
    var nameColor =
        isSelected
            ? AppColors.white.withValues(alpha: 0.5)
            : AppColors.gray1.withValues(alpha: 0.7);
    var priceColor = isSelected ? AppColors.white : AppColors.blue;
    var statusColor = priceColor;

    return GestureDetector(
      onTap: () {
        _clickSelectSeatType(index);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: itemBg,
          border: Border.all(color: itemBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(seatType.name, style: AppFont.regular_white_12.copyWith(color: nameColor)),
            Text(
              '\$ ${seatType.price}',
              style: AppFont.regular_white_14.copyWith(color: priceColor),
            ),
            WidgetSpacer(height: 32),
            Text(textStatus, style: AppFont.regular_white_12.copyWith(color: statusColor)),
          ],
        ),
      ),
    );
  }

  _clickSelectSeatType(int index) {
    setState(() {
      _selectedIndex = index;
    });

    BlocProvider.of<BookSeatTypeBloc>(
      context,
    ).add(ClickSelectSeatType(selectedSeatType: widget.seatTypes[index].type));
  }
}

/// WidgetNumberSeatPicker
class WidgetNumberSeatPicker extends StatefulWidget {
  const WidgetNumberSeatPicker({super.key});

  @override
  State<WidgetNumberSeatPicker> createState() => _WidgetNumberSeatPickerState();
}

class _WidgetNumberSeatPickerState extends State<WidgetNumberSeatPicker> {
  List<int> seats = List<int>.generate(10, (index) => index + 1);

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var isSelected = _selectedIndex == index;
          var boxColor = isSelected ? AppColors.green : Colors.transparent;
          var textColor = isSelected ? AppColors.white : AppColors.gray4;

          return GestureDetector(
            onTap: () {
              _clickSelectSeat(index);
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: Text(
                  seats[index].toString(),
                  style: AppFont.medium_white_14.copyWith(color: textColor),
                ),
              ),
            ),
          );
        },
        itemCount: seats.length,
      ),
    );
  }

  _clickSelectSeat(int index) {
    setState(() {
      _selectedIndex = index;
    });

    BlocProvider.of<BookSeatTypeBloc>(context).add(ClickHowManySeat(seatCount: index + 1));
  }
}
