import 'package:cinema_booking/data/models/seats/seat_type.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ItemSeatSlotVM extends Equatable {
  String seatId;
  bool isOff;
  bool isBooked;
  bool isSelected;
  TypeSeat seatType;

  ItemSeatSlotVM({
    required this.seatId,
    required this.isOff,
    required this.isBooked,
    required this.isSelected,
    required this.seatType,
  });

  @override
  List<Object> get props => [seatId, isSelected, seatType];

  @override
  String toString() {
    return 'ItemSeatSlotVM{seatId: $seatId}';
  }
}
