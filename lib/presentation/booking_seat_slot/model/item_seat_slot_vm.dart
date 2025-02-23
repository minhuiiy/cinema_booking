import 'package:cinema_booking/core/enum/type_seat.dart';
import 'package:equatable/equatable.dart';

class ItemSeatSlotVM extends Equatable {
  final String seatId;
  final bool isOff;
  final bool isBooked;
  final bool isSelected;
  final TypeSeat seatType;

  const ItemSeatSlotVM({
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
    return 'ItemSeatSlotVM{seatId: $seatId, isOff: $isOff, isBooked: $isBooked, isSelected: $isSelected, seatType: $seatType}';
  }
}
