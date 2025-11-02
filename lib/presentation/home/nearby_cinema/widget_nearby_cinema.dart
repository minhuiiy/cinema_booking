/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2025-02-21 21:28:06
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'dart:async';

import 'package:cinema_booking/core/configs/assets/app_images.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/domain/entities/cinema/cinema.dart';
import 'package:cinema_booking/presentation/home/bloc/home_bloc.dart';
import 'package:cinema_booking/presentation/home/nearby_cinema/bloc/nearby_cinema_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';

class WidgetNearbyCine extends StatefulWidget {
  const WidgetNearbyCine({super.key});

  @override
  State<WidgetNearbyCine> createState() => _WidgetNearbyCineState();
}

class _WidgetNearbyCineState extends State<WidgetNearbyCine> {
  List<CinemaEntity> cines = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NearbyCineBloc>(
      create:
          (context) =>
              NearbyCineBloc(homeBloc: BlocProvider.of<HomeBloc>(context)),
      child: BlocBuilder<NearbyCineBloc, NearbyCineState>(
        builder: (context, state) {
          if (state is NearbyCineLoaded) {
            cines.clear();
            cines.addAll(state.cines);

            return Column(
              children: <Widget>[_buildHeader(), _buildGoogleMap()],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Text("Rạp gần bạn".toUpperCase(), style: AppFont.medium_white_14),
          Spacer(),
          TextButton(
            onPressed: () {
              _openAllCine();
            },
            child: Text(
              "Xem tất cả",
              style: AppFont.medium_white_12.copyWith(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }

  _openAllCine() {
    // TODO: Open all cinema Screen
  }

  final Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static final CameraPosition _kGooglePlex = CameraPosition(
    // Trung tâm Quận 1, TP.HCM
    target: LatLng(10.776605, 106.700000),
    zoom: 14.0,
  );

  _buildGoogleMap() {
    // Avoid crashes/asserts on web when Google Maps JS API isn't configured
    if (kIsWeb) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 200,
            color: AppColors.darkBackground,
            alignment: Alignment.center,
            child: Text(
              'Bản đồ tạm ẩn trên web (chưa cấu hình Google Maps)',
              style: AppFont.medium_white_12,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 200,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(markers.values),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              // Phạm vi hiển thị khu vực trung tâm TP.HCM
              LatLng southwest = LatLng(10.735000, 106.635000);
              LatLng northeast = LatLng(10.815000, 106.750000);

              Future.delayed(Duration(seconds: 1), () {
                controller.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    LatLngBounds(southwest: southwest, northeast: northeast),
                    0,
                  ),
                );
              });

              _createMarker(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _createMarker(BuildContext context) async {
    final icon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(18, 18)),
      AppImages.cinemas,
    );

    markers.clear();
    for (var cine in cines) {
      final markerIdVal = cine.id;
      final latLng = LatLng(cine.lat, cine.lng);

      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = Marker(
        markerId: markerId,
        icon: icon,
        position: latLng,
        infoWindow: InfoWindow(title: cine.name, snippet: cine.address),
        onTap: () {},
      );

      markers[markerId] = marker;
    }

    setState(() {
      markers.length;
    });
  }
}
