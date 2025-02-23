part of 'list_tickets_bloc.dart';

abstract class ListTicketsEvent extends Equatable {}

class OpenScreenListTicketsEvent extends ListTicketsEvent {
  @override
  List<Object> get props => [];
}
