import 'package:cinema_booking/common/helpers/db_helper.dart';
import 'package:cinema_booking/data/models/ticket/ticket.dart';
import 'package:dartz/dartz.dart';

abstract class AllTicketsService {
  Future<Either<String, List<Ticket>>> getAllTicketsData();
  Future<Either> createTicket(Ticket ticket);
}

class AllTicketsServiceImpl extends AllTicketsService {
  static final TABLE_NAME = "my_ticket";

  static final COL_ID = "id";
  static final COL_SHOW_NAME = "show_name";
  static final COL_SHOW_BANNER = "show_banner";
  static final COL_SHOW_TIME_SLOT = "show_time_slot";
  static final COL_BOOK_TIME = "book_time";
  static final COL_CINE_NAME = "cine_name";
  static final COL_SEAT = "seat";
  @override
  Future<Either<String, List<Ticket>>> getAllTicketsData() async {
    try {
      var listMap = await DbHelper.db.query(TABLE_NAME, orderBy: '$COL_BOOK_TIME DESC');

      return right(listMap.map((jsonRaw) => Ticket.fromJson(jsonRaw)).toList());
    } catch (e) {
      return const Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either> createTicket(Ticket ticket) async {
    try {
      return right(DbHelper.db.insert(TABLE_NAME, ticket.toJson()));
    } catch (e) {
      return const Left('An error occurred, Please try again.');
    }
  }
}
