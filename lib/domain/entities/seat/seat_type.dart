import 'package:cinema_booking/data/models/seat/seat_type.dart';
import 'package:cinema_booking/domain/entities/seat/seat_row.dart';

class SeatTypeEntity {
  String name;
  double price;
  SEAT_TYPE seatType;
  List<SeatRowEntity> seatRows;

  SeatTypeEntity(
      {required this.name, required this.price, required this.seatType, required this.seatRows});

  @override
  String toString() {
    return 'SeatType{name: $name}';
  }
}
