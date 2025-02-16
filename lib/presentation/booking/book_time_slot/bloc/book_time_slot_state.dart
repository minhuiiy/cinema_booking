import 'package:cinema_booking/domain/entities/booking/booking_time_slot.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_time_slot_state.freezed.dart';

@freezed
abstract class BookTimeSlotState with _$BookTimeSlotState {
  const factory BookTimeSlotState({
    @Default(false) bool isLoading,
    @Default([]) List<BookTimeSlotEntity> list,
    String? msg,
    @Default(false) bool movieSearchField,
    @Default(false) bool isOpenBookSeatTypeScreen,
  }) = _BookTimeSlotState;
}
