import 'package:cinema_booking/presentation/booking_seat_slot/model/item_seat_slot_vm.dart';
import 'package:equatable/equatable.dart';

class ItemSeatRowVM extends Equatable {
  final String itemRowName;

  final List<ItemSeatSlotVM> seatSlotVMs;

  const ItemSeatRowVM({required this.itemRowName, required this.seatSlotVMs});

  @override
  List<Object> get props => [itemRowName, seatSlotVMs];
}
