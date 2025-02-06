// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeatModel _$SeatModelFromJson(Map<String, dynamic> json) => SeatModel(
      json['name'] as String? ?? '',
      $enumDecode(_$SEAT_TYPEEnumMap, json['seat_type']),
      (json['seat_rows'] as List<dynamic>)
          .map((e) => SeatRowModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$SeatModelToJson(SeatModel instance) => <String, dynamic>{
      'name': instance.name,
      'seat_type': _$SEAT_TYPEEnumMap[instance.seatType]!,
      'seat_rows': instance.seatRows,
      'price': instance.price,
    };

const _$SEAT_TYPEEnumMap = {
  SEAT_TYPE.KING: 'king',
  SEAT_TYPE.QUEEN: 'queen',
  SEAT_TYPE.JACK: 'jack',
};
