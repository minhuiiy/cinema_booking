part of 'book_time_slot_bloc.dart';

abstract class BookTimeSlotEvent extends Equatable {
  const BookTimeSlotEvent();
}

class OpenScreen extends BookTimeSlotEvent {
  const OpenScreen();

  @override
  List<Object> get props => [];
}

class ClickIconSearch extends BookTimeSlotEvent {
  @override
  List<Object> get props => [];
}

class ClickCloseSearch extends BookTimeSlotEvent {
  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends BookTimeSlotEvent {
  final String keyword;

  const SearchQueryChanged({required this.keyword});

  @override
  List<Object> get props => [keyword];

  @override
  String toString() {
    return 'SearchQueryChanged{keyword: $keyword}';
  }
}

class ClickIconSort extends BookTimeSlotEvent {
  @override
  List<Object> get props => [DateTime.now().millisecond];
}

class SortByChanged extends BookTimeSlotEvent {
  final BookingTimeSlotSortBy sortBy;

  const SortByChanged({required this.sortBy});

  @override
  List<Object> get props => [sortBy];

  @override
  String toString() {
    return 'SortByChanged{sortBy: $sortBy}';
  }
}

class SelectTimeSlot extends BookTimeSlotEvent {
  TimeSlotEntity selectedTimeSlot;
  BookTimeSlotEntity bookTimeSlot;

  SelectTimeSlot({
    required this.selectedTimeSlot,
    required this.bookTimeSlot,
  });

  @override
  List<Object> get props => [selectedTimeSlot, bookTimeSlot];
}

class OpenedBookSeatTypeScreen extends BookTimeSlotEvent {
  @override
  List<Object> get props => [];
}
