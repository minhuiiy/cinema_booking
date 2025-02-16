import 'package:cinema_booking/data/models/seats/seat_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_seat_slot_by_seat_type_response.g.dart';

@JsonSerializable()
class ListSeatModelResponse {
  List<SeatTypesModel> data;

  ListSeatModelResponse(this.data);

  factory ListSeatModelResponse.fromJson(Map<String, dynamic> json) =>
      _$ListSeatModelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListSeatModelResponseToJson(this);
}
