/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-22 08:32:59
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/data/models/seats/seat_type.dart';
import 'package:equatable/equatable.dart';

class SeatTypeEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final TypeSeat type;

  const SeatTypeEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
  });

  @override
  List<Object> get props => [id, name, price, type];

  @override
  String toString() {
    return 'SeatType{name: $name}';
  }
}
