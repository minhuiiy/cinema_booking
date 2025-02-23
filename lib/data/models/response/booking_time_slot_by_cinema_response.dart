import 'package:cinema_booking/data/models/cinema/cinema.dart';
import 'package:cinema_booking/data/models/show_time/time_slot.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_time_slot_by_cinema_response.g.dart';

@JsonSerializable()
class BookingTimeSlotByCinemaResponse {
  String id;
  CinemaModel cine;
  List<String> tami;

  @JsonKey(name: "time_slots")
  List<TimeSlotModel> timeSlots;

  BookingTimeSlotByCinemaResponse({
    required this.id,
    required this.cine,
    required this.tami,
    required this.timeSlots,
  });

  factory BookingTimeSlotByCinemaResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingTimeSlotByCinemaResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$BookingTimeSlotByCinemaResponseToJson(this);
}
