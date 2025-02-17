import 'dart:async';
import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/data/models/cinema/cinema.dart';
import 'package:cinema_booking/data/models/response/booking_time_slot_by_cinema_response.dart';
import 'package:cinema_booking/data/models/show_time/time_slot.dart';
import 'package:cinema_booking/domain/entities/booking/booking_time_slot.dart';
import 'package:cinema_booking/domain/entities/show_time/time_slot.dart';
import 'package:cinema_booking/domain/usecase/booking_time/cache_book_time_slot.dart';
import 'package:cinema_booking/domain/usecase/booking_time/cache_selected_time_slot.dart';
import 'package:cinema_booking/domain/usecase/booking_time/get_all_shows_by_type.dart';
import 'package:cinema_booking/presentation/booking/bloc/book_time_slot_state.dart';
import 'package:cinema_booking/presentation/booking/bloc/sort_booking_time_slot.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_time_slot_event.dart';

class BookTimeSlotBloc extends Bloc<BookTimeSlotEvent, BookTimeSlotState> {
  // Must be passed via constructor
  String movieId = "";

  BookTimeSlotBloc() : super(const BookTimeSlotState(isLoading: true)) {
    // Định nghĩa các sự kiện
    on<OpenScreen>(_onOpenScreen);
    on<ClickIconSearch>(_onClickIconSearch);
    on<ClickCloseSearch>(_onClickCloseSearch);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SelectTimeSlot>(_onSelectTimeSlot);
    on<OpenedBookSeatTypeScreen>(_onOpenedBookSeatTypeScreen);
  }

  Future<void> _onOpenScreen(
    OpenScreen event,
    Emitter<BookTimeSlotState> emit,
  ) async {
    LogHelper.logDebug(tag: 'OpenScreen', message: 'movieId: $movieId');
    try {
      final response = await sl<GetAllMoviesByTypeUseCase>().call(movieId: movieId);

      response.fold(
        (error) {
          // emit(BookTimeSlotError(error));
          LogHelper.logError(tag: 'OpenScreen Error', message: "BookTimeSlotBloc $error");
        },
        (data) {
          final updatedState = state.copyWith(
            isLoading: false,
            list: _toBookTimeSlots(data),
          );
          emit(updatedState);
          LogHelper.logInfo(tag: 'OpenScreen Success', message: 'Data loaded successfully');
        },
      );
    } catch (e, stackTrace) {
      emit(state.copyWith(msg: e.toString()));
      LogHelper.logError(
          tag: 'OpenScreen Error', message: 'Failed to load movies: ' + e.toString());
    }
  }

  void _onClickIconSearch(
    ClickIconSearch event,
    Emitter<BookTimeSlotState> emit,
  ) {
    LogHelper.logDebug(tag: 'ClickIconSearch', message: 'Search icon clicked');
    final updatedState = state.copyWith(isLoading: false, movieSearchField: true);
    emit(updatedState);
    LogHelper.logInfo(tag: 'ClickIconSearch Success', message: 'Search field is movien');
  }

  void _onClickCloseSearch(
    ClickCloseSearch event,
    Emitter<BookTimeSlotState> emit,
  ) async {
    LogHelper.logDebug(tag: 'ClickCloseSearch', message: 'Closing search field');
    final updatedState = state.copyWith(movieSearchField: false);
    emit(updatedState);
    LogHelper.logInfo(tag: 'ClickCloseSearch Success', message: 'Search field closed');

    await _onSearchQueryChanged(SearchQueryChanged(keyword: ""), emit);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<BookTimeSlotState> emit,
  ) async {
    LogHelper.logDebug(tag: 'SearchQueryChanged', message: 'Keyword: ${event.keyword}');
    emit(state.copyWith(isLoading: true));

    try {
      final response = await sl<GetAllMoviesByTypeUseCase>().call(movieId: movieId);

      response.fold(
        (error) {
          // emit(BookTimeSlotError(error));
          LogHelper.logError(tag: 'OpenScreen Error', message: "_onSearchQueryChanged " + error);
        },
        (data) {
          final query = _filterFake(event.keyword);
          final result = data.where(query).toList();

          final updatedState = state.copyWith(
            isLoading: false,
            list: _toBookTimeSlots(result),
          );
          emit(updatedState);
          LogHelper.logInfo(tag: 'OpenScreen Success', message: 'Data loaded successfully');
        },
      );
    } catch (e) {
      emit(state.copyWith(msg: e.toString()));
      LogHelper.logError(
          tag: 'SearchQueryChanged Error', message: 'Failed to search for query: ' + e.toString());
    }
  }

  Future<void> _onSelectTimeSlot(
    SelectTimeSlot event,
    Emitter<BookTimeSlotState> emit,
  ) async {
    LogHelper.logDebug(
        tag: 'SelectTimeSlot', message: 'Selected timeSlot: ${event.selectedTimeSlot}');
    await sl<CacheSelectedTimeSlotUseCase>().call(timeSlot: event.selectedTimeSlot);
    await sl<CacheBookTimeSlotUseCase>().call(bookTimeSlot: event.bookTimeSlot);

    final updatedState = state.copyWith(isOpenBookSeatTypeScreen: true);
    emit(updatedState);

    LogHelper.logInfo(
        tag: 'SelectTimeSlot Success', message: 'Selected timeSlot cached, opening seat screen');
  }

  void _onOpenedBookSeatTypeScreen(
    OpenedBookSeatTypeScreen event,
    Emitter<BookTimeSlotState> emit,
  ) {
    LogHelper.logDebug(tag: 'OpenedBookSeatTypeScreen', message: 'Opening Book Seat Type screen');
    final updatedState = state.copyWith(isOpenBookSeatTypeScreen: false);
    emit(updatedState);
    LogHelper.logInfo(
        tag: 'OpenedBookSeatTypeScreen Success', message: 'Book Seat Type screen closed');
  }

// Filtering logic for BookTimeSlotEntity data
  // Filtering logic for local data
  static bool Function(BookingTimeSlotByCinemaResponse response) _filterFake(String keyword) {
    return (BookingTimeSlotByCinemaResponse response) =>
        keyword.isEmpty || response.cine.name!.toLowerCase().contains(keyword.toLowerCase());
  }

  // Convert API response to a list of domain objects
  static List<BookTimeSlotEntity> _toBookTimeSlots(
      List<BookingTimeSlotByCinemaResponse> responses) {
    return responses
        .map((response) => BookTimeSlotEntity(
              cine: response.cine.toEntity(),
              tami: response.tami,
              timeSlots: response.timeSlots.toEntities(),
            ))
        .toList();
  }
}
