part of 'book_seat_type_bloc.dart';

abstract class BookSeatTypeEvent extends Equatable {
  const BookSeatTypeEvent();
}

class OpenScreen extends BookSeatTypeEvent {
  @override
  List<Object> get props => [];
}

class ClickHowManySeat extends BookSeatTypeEvent {
  final int seatCount;

  const ClickHowManySeat({required this.seatCount});

  @override
  List<Object> get props => [seatCount];
}

class ClickSelectSeatType extends BookSeatTypeEvent {
  final TypeSeat selectedSeatType;

  const ClickSelectSeatType({required this.selectedSeatType});

  @override
  List<Object> get props => [selectedSeatType];
}

class ClickSelectSeats extends BookSeatTypeEvent {
  @override
  List<Object> get props => [];
}

class OpenedBookSeatSlotScreen extends BookSeatTypeEvent {
  @override
  List<Object> get props => [];
}
