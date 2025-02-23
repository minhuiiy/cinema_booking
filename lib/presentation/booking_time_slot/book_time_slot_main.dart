import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/domain/entities/booking/booking_time_slot.dart';
import 'package:cinema_booking/domain/entities/cinema/cinema.dart';
import 'package:cinema_booking/domain/entities/movies/movies.dart';
import 'package:cinema_booking/presentation/booking_time_slot/bloc/book_time_slot_bloc.dart';
import 'package:cinema_booking/presentation/booking_time_slot/bloc/book_time_slot_state.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_cinema_pick_date.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_search_sort_toolbar.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_cinema_timeslot.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_loading.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_screen_message.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_unknown_state.dart';
import 'package:cinema_booking/presentation/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookTimeSlotScreen extends StatelessWidget {
  final MovieEntity movie;

  const BookTimeSlotScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<BookTimeSlotBloc>(
          create: (context) => BookTimeSlotBloc()..add(OpenScreen()),
          child: Column(
            children: <Widget>[
              WidgetSearchSortToolbar(title: movie.name),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    _buildListCineTimeSlot(),
                    _buildBtnToday(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildListCineTimeSlot() {
    return BlocConsumer<BookTimeSlotBloc, BookTimeSlotState>(
      listener: (context, state) {
        if (state.isOpenBookSeatTypeScreen) {
          _openBookSeatTypeScreen(context);
        }
      },
      builder: (context, state) {
        if (state.list.isNotEmpty) {
          return ListView.separated(
            itemBuilder: (context, index) {
              if (index < state.list.length) {
                BookTimeSlotEntity bookTimeSlot = state.list[index];

                ItemCineTimeSlot item = ItemCineTimeSlot.fromBookTimeSlot(
                  bookTimeSlot: bookTimeSlot,
                );

                return WidgetCineTimeSlot(item);
              } else {
                return WidgetSpacer(height: 55);
              }
            },
            separatorBuilder: (context, index) {
              return WidgetSpacer(height: 14);
            },
            itemCount: state.list.length + 1,
            physics: BouncingScrollPhysics(),
          );
        }

        if (state.isLoading) {
          return WidgetLoading();
        }

        if (state.msg != null) {
          return WidgetScreenMessage(msg: state.msg!);
        }

        return WidgetUnknownState();
      },
    );
  }

  _buildBtnToday() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: CinematicBottomBar(
        dateText: "Today, 14 NOV",
        formatText: "Tamil, 3D",
        onDateTap: () {
          // openCineDatePicker();
        },
        onFormatTap: () {
          // openCineDatePicker();
        },
      ),

      //       Container(
      //         height: 56,
      //         padding: EdgeInsets.only(left: 20),
      // //        width: MediaQuery.of(_context).size.width,
      //         color: AppColors.blue,
      //         child: Row(
      //           children: <Widget>[
      //             Expanded(
      //               child: GestureDetector(
      //                 onTap: () {
      //                   // openCineDatePicker();
      //                 },
      //                 child: Row(
      //                   children: <Widget>[
      //                     Icon(Icons.calendar_today, color: AppColors.white, size: 14),
      //                     WidgetSpacer(width: 6),
      //                     Text('Today, 14 NOV', style: AppFont.regular_white_14),
      //                     WidgetSpacer(width: 4),
      //                     Icon(Icons.keyboard_arrow_down, color: AppColors.white, size: 12)
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             Expanded(
      //               child: Row(
      //                 children: <Widget>[
      //                   Text('Tamil, 3D', style: AppFont.regular_white_14),
      //                   WidgetSpacer(width: 4),
      //                   Icon(Icons.keyboard_arrow_down, color: AppColors.white, size: 10)
      //                 ],
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
    );
  }

  _openBookSeatTypeScreen(BuildContext context) {
    // TODO:
    BlocProvider.of<BookTimeSlotBloc>(context).add(OpenedBookSeatTypeScreen());
    Navigator.pushNamed(context, AppRouter.BOOK_SEAT_TYPE);
  }

  // void openCineDatePicker() {
  //   movieModalBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     context: _context,
  //     builder: (context) {
  //       return CineDatePickerScreen();
  //     },
  //   );
  // }
}

class ItemCineTimeSlot {
  late BookTimeSlotEntity bookTimeSlot;

  late String cineName;
  late CinemaEntity cine;
  late String textLocation;
  late String textDistance;
  late List<ItemTimeSlot> timeSlots;

  ItemCineTimeSlot({
    required this.cine,
    required this.textLocation,
    required this.textDistance,
    required this.timeSlots,
  }) : cineName = cine.name;

  ItemCineTimeSlot.fromBookTimeSlot({required this.bookTimeSlot}) {
    cine = bookTimeSlot.cine;
    timeSlots =
        bookTimeSlot.timeSlots
            .map((timeSlot) => ItemTimeSlot.fromTimeSlot(timeSlot: timeSlot))
            .toList();

    cineName = bookTimeSlot.cine.name;
    textLocation = bookTimeSlot.cine.address;
    textDistance = bookTimeSlot.cine.distance.toString();
  }
}
