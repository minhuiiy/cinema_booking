import 'package:equatable/equatable.dart';
import 'viewmodel.dart';

// ignore: must_be_immutable
class ItemSeatRowVM extends Equatable {
  String itemRowName;

  List<ItemSeatSlotVM> seatSlotVMs;

  ItemSeatRowVM({
    required this.itemRowName,
    required this.seatSlotVMs,
  });

  @override
  List<Object> get props => [itemRowName, seatSlotVMs];
}
