import 'package:cinema_booking/common/widgets/snackbar/my_snackbar.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_cinema_timeslot.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_empty.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_loading.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_screen_message.dart';
import 'package:cinema_booking/presentation/booking_time_slot/widgets/widget_toolbar.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/data/models/seats/seat_type.dart';
import 'package:cinema_booking/domain/entities/booking/booking_time_slot.dart';
import 'package:cinema_booking/presentation/book_seat_slot/bloc/book_seat_slot_bloc.dart';
import 'package:cinema_booking/presentation/book_seat_slot/bloc/book_seat_slot_state.dart';
import 'package:cinema_booking/presentation/book_seat_slot/widget_cine_screen.dart';
import 'package:cinema_booking/presentation/book_seat_slot/widget_item_grid_seat_slot.dart';
import 'package:cinema_booking/presentation/booking_time_slot/book_time_slot_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenArguments {
  int seatCount;
  TypeSeat seatType;

  ScreenArguments({required this.seatCount, required this.seatType});

  @override
  String toString() {
    return 'ScreenArguments{seatCount: $seatCount, seatType: $seatType}';
  }
}

class BookSeatSlotScreen extends StatefulWidget {
  final ScreenArguments args;

  const BookSeatSlotScreen({super.key, required this.args});

  @override
  State<BookSeatSlotScreen> createState() => _BookSeatSlotScreenState();
}

class _BookSeatSlotScreenState extends State<BookSeatSlotScreen> {
  late ItemCineTimeSlot _itemCineTimeSlot;

  late BuildContext _blocContext;

  get bloc => BlocProvider.of<BookSeatSlotBloc>(_blocContext);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<BookSeatSlotBloc>(
          create:
              (context) => BookSeatSlotBloc(
                selectedSeatType: widget.args.seatType,
                seatCount: widget.args.seatCount,
              )..add(OpenScreen()),
          child: BlocConsumer<BookSeatSlotBloc, BookSeatSlotState>(
            listener: (context, state) {
              _handleBlocListener(context, state);
            },
            builder: (context, state) {
              _blocContext = context;

              if (state.movie != null &&
                  state.bookTimeSlot != null &&
                  state.itemGridSeatSlotVMs.isNotEmpty) {
                BookTimeSlotEntity bookTimeSlot = state.bookTimeSlot!;
                int selectedIndex = bookTimeSlot.timeSlots.indexOf(state.selectedTimeSlot!);
                String movieName = state.movie!.name;

                _itemCineTimeSlot = ItemCineTimeSlot.fromBookTimeSlot(bookTimeSlot: bookTimeSlot);

                String textSeat =
                    state.selectedSeatIds != null
                        ? '${state.selectedSeatIds.length} seats'
                        : '0 seat';

                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        WidgetToolbar(
                          title: movieName,
                          actions: Text(textSeat, style: AppFont.medium_white_12),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                WidgetCineTimeSlot.selected(
                                  item: _itemCineTimeSlot,
                                  selectedIndex: selectedIndex,
                                  movieCineName: false,
                                  movieCineDot: false,
                                ),
                                WidgetCineScreen(),
                                _buildListItemGridSeatSlot(state),
                                WidgetSpacer(height: 64),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildBtnPay(state),
                  ],
                );
              }

              if (state.isLoading) {
                return WidgetLoading();
              }

              if (state.msg != null) {
                return WidgetScreenMessage(msg: state.msg!);
              }

              return WidgetEmpty();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListItemGridSeatSlot(BookSeatSlotState state) {
    List<Widget> widgets = [];

    for (var itemGridSeatSlotVM in state.itemGridSeatSlotVMs) {
      widgets.add(WidgetItemGridSeatSlot(itemGridSeatSlotVM: itemGridSeatSlotVM));
      widgets.add(WidgetSpacer(height: 14));
    }

    return Column(mainAxisSize: MainAxisSize.min, children: widgets);
  }

  _buildBtnPay(BookSeatSlotState state) {
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
            children: <Widget>[
              Text(
                'Pay${state.totalPrice > 0 ? " \$ ${state.totalPrice}" : ""}',
                style: AppFont.medium_white_16,
              ),
            ],
          ),
          onPressed: () {
            bloc.add(ClickButtonPay());
          },
        ),
      ),
    );
  }

  void _handleBlocListener(BuildContext context, BookSeatSlotState state) {
    if (state.isReachedLimitSeatSlot) {
      CustomSnackBar.failure(context, msg: "You reached ${widget.args.seatCount} seats");
      bloc.add(DismissMessageReachedLimitSeatSlot());
    }

    if (state.isSelectWrongSeatType) {
      CustomSnackBar.failure(context, msg: "Please select seat ${widget.args.seatType.toText()}");
      bloc.add(DismissMessageWrongSeatType());
    }

    if (state.isOpenPaymentMethod) {
      bloc.add(OpenedPaymentMethodScreen());

      // movieModalBottomSheet(
      //   context: context,
      //   backgroundColor: Colors.transparent,
      //   isScrollControlled: true,
      //   builder: (context) {
      //     return PaymentMethodPickerScreen(
      //       state.selectedSeatIds,
      //       state.totalPrice,
      //       state.movie!,
      //       state.selectedTimeSlot!,
      //       state.bookTimeSlot!,
      //     );
      //   },
      // );
    }
  }
}
