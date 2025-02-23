import 'dart:collection';
import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/core/enum/type_seat.dart';
import 'package:cinema_booking/data/models/seats/seat_type.dart';
import 'package:cinema_booking/domain/entities/booking/booking_time_slot.dart';
import 'package:cinema_booking/domain/entities/movies/movies.dart';
import 'package:cinema_booking/domain/entities/seats/seat_row.dart';
import 'package:cinema_booking/domain/entities/seats/seat_type.dart';
import 'package:cinema_booking/domain/entities/show_time/time_slot.dart';
import 'package:cinema_booking/domain/repository/seat_slot/seat_slot_repository.dart';
import 'package:cinema_booking/domain/usecase/booking_time/get_cached_book_time_slot.dart';
import 'package:cinema_booking/domain/usecase/booking_time/get_cached_selected_time_slot.dart';
import 'package:cinema_booking/domain/usecase/booking_time/get_cached_show.dart';
import 'package:cinema_booking/presentation/booking_seat_slot/bloc/book_seat_slot_state.dart';
import 'package:cinema_booking/presentation/booking_seat_slot/model/item_grid_seat_slot_vm.dart';
import 'package:cinema_booking/presentation/booking_seat_slot/model/item_seat_row_vm.dart';
import 'package:cinema_booking/presentation/booking_seat_slot/model/item_seat_slot_vm.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_seat_slot_event.dart';

class BookSeatSlotBloc extends Bloc<BookSeatSlotEvent, BookSeatSlotState> {
  final int seatCount;
  final TypeSeat selectedSeatType;

  HashMap<String, bool> selectedSeats = HashMap();
  List<SeatTypeEntity> seatSlotByTypes = [];

  BookSeatSlotBloc({required this.seatCount, required this.selectedSeatType})
    : super(const BookSeatSlotState(isLoading: true)) {
    on<OpenScreen>(_onOpenScreen);
    on<ClickSelectSeatSlot>(_onClickSelectSeatSlot);
    on<DismissMessageWrongSeatType>(_onDismissMessageWrongSeatType);
    on<DismissMessageReachedLimitSeatSlot>(_onDismissMessageReachedLimitSeatSlot);
    on<ClickButtonPay>(_onClickButtonPay);
    on<OpenedPaymentMethodScreen>(_onOpenedPaymentMethodScreen);
  }

  Future<void> _onOpenScreen(OpenScreen event, Emitter<BookSeatSlotState> emit) async {
    LogHelper.logInfo(tag: 'BookSeatSlotBloc', message: 'Opening screen...');

    MovieEntity? movie;
    TimeSlotEntity? selectedTimeSlot;
    BookTimeSlotEntity? bookTimeSlot;

    final movieData = await sl<GetCachedMovieUseCase>().call();
    final selectedTimeSlotData = await sl<GetCachedSelectedTimeSlotUseCase>().call();
    final bookTimeSlotData = await sl<GetCachedBookTimeSlotUseCase>().call();

    LogHelper.logDebug(tag: 'BookSeatSlotBloc', message: 'Data loaded movieData: $movieData');

    LogHelper.logDebug(
      tag: 'BookSeatSlotBloc',
      message: 'Data loaded selectedTimeSlotData: $selectedTimeSlotData',
    );

    LogHelper.logDebug(
      tag: 'BookSeatSlotBloc',
      message: 'Data loaded bookTimeSlotData: $bookTimeSlotData',
    );

    movieData.fold(
      (error) {
        LogHelper.logError(tag: 'OpenScreen Error', message: "BookSeatSlotBloc movieData $error");
      },
      (data) {
        movie = data;
      },
    );
    selectedTimeSlotData.fold(
      (error) {
        LogHelper.logError(
          tag: 'OpenScreen Error',
          message: "BookSeatSlotBloc selectedTimeSlotData $error",
        );
      },
      (data) {
        selectedTimeSlot = data;
      },
    );
    bookTimeSlotData.fold(
      (error) {
        LogHelper.logError(
          tag: 'OpenScreen Error',
          message: "BookSeatSlotBloc bookTimeSlotData $error",
        );
      },
      (data) {
        bookTimeSlot = data;
      },
    );
    try {
      List<SeatTypesModel> seatSlotModelByTypes =
          await sl<SeatSlotRepository>().getListSeatSlotBySeatTypes();

      LogHelper.logDebug(
        tag: 'BookSeatSlotBloc',
        message: 'Data loaded seatSlotModelByTypes: $seatSlotModelByTypes',
      );
      seatSlotByTypes = seatSlotModelByTypes.toEntities();
      LogHelper.logDebug(
        tag: 'BookSeatSlotBloc',
        message: 'Data loaded successfully seatSlotByTypes $seatSlotByTypes',
      );
      emit(
        state.copyWith(
          isLoading: false,
          movie: movie,
          selectedTimeSlot: selectedTimeSlot,
          bookTimeSlot: bookTimeSlot,
          itemGridSeatSlotVMs: toItemGridSeatSlotVMs(seatSlotByTypes),
        ),
      );
    } catch (e) {
      LogHelper.logError(tag: 'BookSeatSlotBloc', message: 'Failed to open screen $e');
      emit(state.copyWith(isLoading: false, msg: e.toString()));
    }
  }

  Future<void> _onClickSelectSeatSlot(
    ClickSelectSeatSlot event,
    Emitter<BookSeatSlotState> emit,
  ) async {
    final item = event.itemSeatSlotVM;
    LogHelper.logDebug(tag: 'BookSeatSlotBloc', message: 'Click seat slot: ${item.seatId}');

    if (item.seatType == selectedSeatType) {
      if (!selectedSeats.containsKey(item.seatId)) {
        if (!isReachedLimitSlot()) {
          selectedSeats[item.seatId] = true;
          LogHelper.logInfo(tag: 'BookSeatSlotBloc', message: 'Seat selected: ${item.seatId}');
          emit(
            state.copyWith(
              itemGridSeatSlotVMs: toItemGridSeatSlotVMs(seatSlotByTypes),
              selectedSeatIds: getSelectedSeatSlotId(),
              totalPrice: calculateTotalPrice(),
            ),
          );
        } else {
          LogHelper.logWarning(tag: 'BookSeatSlotBloc', message: 'Seat limit reached');
          emit(state.copyWith(isReachedLimitSeatSlot: true));
        }
      } else {
        final isSelected = !selectedSeats[item.seatId]!;
        if ((isSelected && !isReachedLimitSlot()) || !isSelected) {
          selectedSeats[item.seatId] = isSelected;
          LogHelper.logInfo(
            tag: 'BookSeatSlotBloc',
            message: 'Seat ${isSelected ? "selected" : "deselected"}: ${item.seatId}',
          );
          emit(
            state.copyWith(
              itemGridSeatSlotVMs: toItemGridSeatSlotVMs(seatSlotByTypes),
              selectedSeatIds: getSelectedSeatSlotId(),
              totalPrice: calculateTotalPrice(),
            ),
          );
        } else {
          LogHelper.logWarning(tag: 'BookSeatSlotBloc', message: 'Seat limit reached');
          emit(state.copyWith(isReachedLimitSeatSlot: true));
        }
      }
    } else {
      LogHelper.logWarning(tag: 'BookSeatSlotBloc', message: 'Wrong seat type selected');
      emit(state.copyWith(isSelectWrongSeatType: true));
    }
  }

  void _onDismissMessageWrongSeatType(
    DismissMessageWrongSeatType event,
    Emitter<BookSeatSlotState> emit,
  ) {
    LogHelper.logDebug(tag: 'BookSeatSlotBloc', message: 'Dismissing wrong seat type message');
    emit(state.copyWith(isSelectWrongSeatType: false));
  }

  void _onDismissMessageReachedLimitSeatSlot(
    DismissMessageReachedLimitSeatSlot event,
    Emitter<BookSeatSlotState> emit,
  ) {
    LogHelper.logDebug(tag: 'BookSeatSlotBloc', message: 'Dismissing seat limit reached message');
    emit(state.copyWith(isReachedLimitSeatSlot: false));
  }

  void _onClickButtonPay(ClickButtonPay event, Emitter<BookSeatSlotState> emit) {
    LogHelper.logInfo(tag: 'BookSeatSlotBloc', message: 'Button Pay clicked');
    emit(state.copyWith(isOpenPaymentMethod: true));
  }

  void _onOpenedPaymentMethodScreen(
    OpenedPaymentMethodScreen event,
    Emitter<BookSeatSlotState> emit,
  ) {
    LogHelper.logDebug(tag: 'BookSeatSlotBloc', message: 'Payment method screen opened');
    emit(state.copyWith(isOpenPaymentMethod: false));
  }

  bool isReachedLimitSlot() {
    final isReached = getSelectedSeatSlotId().length == seatCount;
    LogHelper.logDebug(tag: 'BookSeatSlotBloc', message: 'Is seat limit reached: $isReached');
    return isReached;
  }

  List<String> getSelectedSeatSlotId() {
    final selectedIds = selectedSeats.keys.where((key) => selectedSeats[key]!).toList();
    LogHelper.logDebug(tag: 'BookSeatSlotBloc', message: 'Selected seat IDs: $selectedIds');
    return selectedIds;
  }

  double calculateTotalPrice() {
    final totalPrice =
        SeatTypesModel.SAMPLE_DATA.firstWhere((type) => type.type == selectedSeatType).price! *
        getSelectedSeatSlotId().length;
    LogHelper.logInfo(tag: 'BookSeatSlotBloc', message: 'Total price calculated: $totalPrice');
    return totalPrice;
  }

  List<ItemGridSeatSlotVM> toItemGridSeatSlotVMs(List<SeatTypeEntity> seatSlotByTypes) {
    LogHelper.logDebug(tag: 'BookSeatSlotBloc', message: 'toItemGridSeatSlotVMs: $seatSlotByTypes');
    return seatSlotByTypes.map((seatSlotType) {
      final seatTypeName = '\$ ${seatSlotType.price} ${seatSlotType.type.toText().toUpperCase()}';
      final maxColumn = seatSlotType.seatRows![0].count + 1;

      LogHelper.logError(
        tag: 'BookSeatSlotBloc',
        message: 'Invalid seatTypeName: $seatTypeName ; SeatTypeModel: $seatSlotType',
      );

      return ItemGridSeatSlotVM(
        seatTypeName: seatTypeName,
        maxColumn: maxColumn,
        seatRowVMs: _toItemSeatRowVMs(seatSlotType.seatRows, seatSlotType.type),
      );
    }).toList();
  }

  List<ItemSeatRowVM> _toItemSeatRowVMs(List<SeatRowEntity>? seatRows, TypeSeat seatType) {
    return seatRows!.map((seatRow) {
      final itemRowName = seatRow.rowId;
      return ItemSeatRowVM(
        itemRowName: itemRowName,
        seatSlotVMs: _toItemSeatSlotVMs(seatRow, seatRow.count, seatType),
      );
    }).toList();
  }

  List<ItemSeatSlotVM> _toItemSeatSlotVMs(SeatRowEntity seatRow, int count, TypeSeat seatType) {
    return Iterable<int>.generate(count).map((i) {
      final seatId = "${seatRow.rowId}$i";
      final isOff = seatRow.offs.contains(i);
      final isBooked = seatRow.booked.contains(i);
      final isSelected = selectedSeats[seatId] ?? false;

      return ItemSeatSlotVM(
        seatId: seatId,
        isBooked: isBooked,
        isOff: isOff,
        isSelected: isSelected,
        seatType: seatType,
      );
    }).toList();
  }
}
