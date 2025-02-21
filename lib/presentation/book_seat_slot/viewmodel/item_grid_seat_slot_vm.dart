// ignore: slash_for_doc_comments
import 'viewmodel.dart';
import 'package:equatable/equatable.dart';

// ignore: slash_for_doc_comments
/**
    ItemGridSeatSlotVM
    --------ItemSeatRowVM
    ----------ItemSeatSlotVM
 */
// ignore: must_be_immutable
class ItemGridSeatSlotVM extends Equatable {
  int maxColumn;
  String seatTypeName;

  List<ItemSeatRowVM> seatRowVMs;

  ItemGridSeatSlotVM({
    required this.maxColumn,
    required this.seatTypeName,
    required this.seatRowVMs,
  });

  @override
  List<Object> get props => [maxColumn, seatTypeName, seatRowVMs];
}
