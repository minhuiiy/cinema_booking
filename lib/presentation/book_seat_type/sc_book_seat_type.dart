import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/domain/entities/booking/booking_time_slot.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_cinema_timeslot.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_empty.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_toolbar.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/presentation/book_seat_slot/sc_book_seat_slot.dart';
import 'package:cinema_booking/presentation/book_seat_type/bloc/book_seat_type_bloc.dart';
import 'package:cinema_booking/presentation/book_seat_type/bloc/book_seat_type_state.dart';
import 'package:cinema_booking/presentation/book_seat_type/widgets/widget_how_many_seats.dart';
import 'package:cinema_booking/presentation/booking_time_slot/book_time_slot_main.dart';
import 'package:cinema_booking/presentation/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookSeatTypeScreen extends StatefulWidget {
  const BookSeatTypeScreen({super.key});

  @override
  State<BookSeatTypeScreen> createState() => _BookSeatTypeScreenState();
}

class _BookSeatTypeScreenState extends State<BookSeatTypeScreen> {
  late BuildContext _blocContext;

  late ItemCineTimeSlot _itemCineTimeSlot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<BookSeatTypeBloc>(
        create: (context) => BookSeatTypeBloc()..add(OpenScreen()),
        child: BlocConsumer<BookSeatTypeBloc, BookSeatTypeState>(
          listener: (context, state) {
            if (state.isOpenBookSeatSlotScreen) {
              _openBookSeatSlotScreen(state);
            }
          },
          builder: (context, state) {
            _blocContext = context;

            if (state.movie != null && state.bookTimeSlot != null) {
              BookTimeSlotEntity bookTimeSlot = state.bookTimeSlot!;
              int selectedIndex = bookTimeSlot.timeSlots.indexOf(state.selectedTimeSlot!);
              String movieName = state.movie!.name;

              _itemCineTimeSlot = ItemCineTimeSlot.fromBookTimeSlot(bookTimeSlot: bookTimeSlot);

              return Scaffold(
                body: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        WidgetToolbar(title: movieName, actions: Container()),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                WidgetCineTimeSlot.selected(
                                  item: _itemCineTimeSlot,
                                  selectedIndex: selectedIndex,
                                  movieCineName: true,
                                  movieCineDot: false,
                                ),
                                WidgetSpacer(height: 14),
                                WidgetHowManySeats(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildBtnSelectSeat(),
                  ],
                ),
              );
            }

            return WidgetEmpty();
          },
        ),
      ),
    );
  }

  _buildBtnSelectSeat() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SizedBox(
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.defaultColor, // Màu nền của nút
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Nếu bạn muốn làm tròn các góc của nút
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('Select seats', style: AppFont.medium_white_16)],
          ),
          onPressed: () {
            BlocProvider.of<BookSeatTypeBloc>(_blocContext).add(ClickSelectSeats());
          },
        ),
      ),
    );
  }

  _openBookSeatSlotScreen(BookSeatTypeState state) {
    Navigator.pushNamed(
      context,
      AppRouter.BOOK_SEAT_SLOT,
      arguments: ScreenArguments(seatCount: state.seatCount, seatType: state.selectedSeatType),
    );
    BlocProvider.of<BookSeatTypeBloc>(_blocContext).add(OpenedBookSeatSlotScreen());
  }
}
