import 'package:cinema_booking/data/models/seat/seat_row.dart';
import 'package:cinema_booking/domain/entities/seat/seat_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'seat_type.g.dart';

@JsonSerializable()
class SeatModel extends Equatable {
  @JsonKey(name: "name", defaultValue: "")
  String name;

  @JsonKey(name: "seat_type")
  SEAT_TYPE seatType;

  @JsonKey(name: "seat_rows")
  List<SeatRowModel> seatRows;

  @JsonKey(name: "price")
  double price;

  SeatModel(this.name, this.seatType, this.seatRows, this.price);

  factory SeatModel.fromJson(Map<String, dynamic> json) => _$SeatModelFromJson(json);

  Map<String, dynamic> toJson() => _$SeatModelToJson(this);

  @override
  List<Object> get props => [name, seatType, price];

  @override
  String toString() {
    return 'SeatType{name: $name}';
  }

  static final List<SeatModel> SAMPLE_DATA = [
    SeatModel('King', SEAT_TYPE.KING, SeatRowModel.SAMPLE_KING, 120.0),
    SeatModel('Queen', SEAT_TYPE.QUEEN, SeatRowModel.SAMPLE_QUEEN, 100.0),
    SeatModel('Jack', SEAT_TYPE.JACK, SeatRowModel.SAMPLE_JACK, 80.0),
  ];
}

//rename to SEAT_SLOT_TYPE
enum SEAT_TYPE {
  @JsonValue("king")
  KING,
  @JsonValue("queen")
  QUEEN,
  @JsonValue("jack")
  JACK,
}

extension SEAT_TYPE_toText on SEAT_TYPE {
  String toText() {
    switch (this) {
      case SEAT_TYPE.JACK:
        return "Jack";
      case SEAT_TYPE.QUEEN:
        return "Queen";
      case SEAT_TYPE.KING:
        return "King";
    }
  }
}

extension SeatModelMapper on SeatModel {
  /// Convert a SeatModel to SeatTypeEntity
  SeatTypeEntity toEntity() {
    return SeatTypeEntity(
      name: name,
      price: price,
      seatType: seatType,
      seatRows: seatRows.toEntities(), // Use SeatRowModel extension for conversion
    );
  }
}

extension SeatModelListMapper on List<SeatModel> {
  List<SeatTypeEntity> toEntities() {
    return map((model) => model.toEntity()).toList();
  }
}
