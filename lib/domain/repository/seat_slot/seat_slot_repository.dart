import 'package:cinema_booking/core/api/rest_client.dart';
import 'package:cinema_booking/data/models/seats/seat_type.dart';
import 'package:cinema_booking/service_locator.dart';

abstract class SeatSlotRepository {
  Future<List<SeatTypesModel>> getListSeatSlotBySeatTypes();
}

class MockSeatSlotRepository extends SeatSlotRepository {
  @override
  Future<List<SeatTypesModel>> getListSeatSlotBySeatTypes() {
    return Future.value(SeatTypesModel.SAMPLE_DATA);
  }
}

class RemoteSeatSlotRepository extends SeatSlotRepository {
  @override
  Future<List<SeatTypesModel>> getListSeatSlotBySeatTypes() async {
    final client = RestClient(localDio);
    final response = await client.getListSeatSlotBySeatType();
    return response.data;
  }
}
