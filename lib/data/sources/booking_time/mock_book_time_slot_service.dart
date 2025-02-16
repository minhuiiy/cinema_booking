import 'package:cinema_booking/data/models/cinema/cinema.dart';
import 'package:cinema_booking/data/models/response/booking_time_slot_by_cinema_response.dart';
import 'package:dartz/dartz.dart';

abstract class MockBookTimeSlotService {
  Future<Either> getAllMoviesByType(String showId);
}

class MockBookTimeSlotServiceImpl extends MockBookTimeSlotService {
  @override
  Future<Either> getAllMoviesByType(String showId) async {
    return right(Future.value(getMockData()));
  }

  static List<BookingTimeSlotByCinemaResponse> getMockData() {
    final response1 = BookingTimeSlotByCinemaResponse(
      id: "1",
      cine: CinemaModel.SAMPLE_DATA[0],
      timeSlots: [],
      tami: ['3D', '2D'],
    );

    final response2 = BookingTimeSlotByCinemaResponse(
      id: "2",
      cine: CinemaModel.SAMPLE_DATA[1],
      timeSlots: [],
      tami: ['3D'],
    );

    final response3 = BookingTimeSlotByCinemaResponse(
      id: "3",
      cine: CinemaModel.SAMPLE_DATA[2],
      timeSlots: [],
      tami: ['2D'],
    );

    return [response1, response2, response3];
  }
}
