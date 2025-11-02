/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-22 08:30:45
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/domain/entities/cinema/cinema.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cinema.g.dart';

@JsonSerializable()
class CinemaModel {
  String? id;
  String? name;
  String? address;
  int? rating;
  double? distance;
  String? photo;
  double? lat;
  double? lng;

  CinemaModel({
    this.id,
    this.name,
    this.address,
    this.rating,
    this.distance,
    this.photo,
    this.lat,
    this.lng,
  });

  static List<CinemaModel> mockData = [
    CinemaModel(
      id: 'CGV Vincom Đồng Khởi',
      name: 'CGV Vincom Đồng Khởi',
      address: 'Tầng 3, Vincom Đồng Khởi, Q.1, TP.HCM',
      rating: 5,
      distance: 2.3,
      photo: 'images/cines/cine1.png',
      lat: 10.776605,
      lng: 106.702968,
    ),
    CinemaModel(
      id: 'CGV Crescent Mall',
      name: 'CGV Crescent Mall',
      address: '101 Tôn Dật Tiên, P.Tân Phú, Q.7, TP.HCM',
      rating: 5,
      distance: 5.8,
      photo: 'images/cines/cine2.png',
      lat: 10.730828,
      lng: 106.721997,
    ),
    CinemaModel(
      id: 'BHD Star Vincom 3/2',
      name: 'BHD Star Vincom 3/2',
      address: 'Tầng 4, Vincom Plaza 3/2, Q.10, TP.HCM',
      rating: 4,
      distance: 3.1,
      photo: 'images/cines/cine3.png',
      lat: 10.764516,
      lng: 106.667085,
    ),
    CinemaModel(
      id: 'Galaxy Nguyễn Du',
      name: 'Galaxy Nguyễn Du',
      address: '116 Nguyễn Du, P.Bến Thành, Q.1, TP.HCM',
      rating: 4,
      distance: 1.9,
      photo: 'images/cines/cine1.png',
      lat: 10.777802,
      lng: 106.695252,
    ),
    CinemaModel(
      id: 'Lotte Cinema Cantavil',
      name: 'Lotte Cinema Cantavil',
      address: 'Sàn 1, Cantavil Premier, Q.2, TP.HCM',
      rating: 4,
      distance: 6.7,
      photo: 'images/cines/cine1.png',
      lat: 10.802601,
      lng: 106.745381,
    ),
    CinemaModel(
      id: 'BHD Star Bitexco',
      name: 'BHD Star Bitexco',
      address: 'Tầng 3, Bitexco, 2 Hải Triều, Q.1, TP.HCM',
      rating: 5,
      distance: 2.6,
      photo: 'images/cines/cine3.png',
      lat: 10.770091,
      lng: 106.704644,
    ),
  ];

  factory CinemaModel.fromJson(Map<String, dynamic> json) =>
      _$CinemaModelFromJson(json);

  Map<String, dynamic> toJson() => _$CinemaModelToJson(this);

  @override
  String toString() {
    return 'Cine{id: $id, name: $name, address: $address, rating: $rating, distance: $distance, photo: $photo, lat: $lat, lng: $lng}';
  }
}

extension CinemaModelX on CinemaModel {
  CinemaEntity toEntity() {
    return CinemaEntity(
      id: id!,
      name: name!,
      address: address!,
      rating: rating!,
      distance: distance!,
      photo: photo!,
      lat: lat!,
      lng: lng!,
    );
  }
}

extension CinemaModelsListX on List<CinemaModel> {
  List<CinemaEntity> toEntities() {
    return map((model) => model.toEntity()).toList();
  }
}
