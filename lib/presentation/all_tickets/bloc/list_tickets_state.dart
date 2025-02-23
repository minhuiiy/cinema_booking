import 'package:cinema_booking/data/models/ticket/ticket.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'list_tickets_state.freezed.dart';

@freezed
abstract class ListTicketsState with _$ListTicketsState {
  const factory ListTicketsState({
    @Default(true) bool isLoading,
    @Default([]) List<Ticket> data,
    String? msg,
  }) = _ListTicketsState;
}
