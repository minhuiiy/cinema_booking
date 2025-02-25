import 'package:cinema_booking/common/helpers/db_helper.dart';
import 'package:cinema_booking/data/models/ticket/ticket.dart';
import 'package:dartz/dartz.dart';

abstract class AllTicketsService {
  Future<Either<String, List<Ticket>>> getAllTicketsData();
  Future<Either> createTicket(Ticket ticket);
}

class AllTicketsServiceImpl extends AllTicketsService {
  @override
  Future<Either<String, List<Ticket>>> getAllTicketsData() async {
    try {
      var listMap = await DbHelper.db.query(
        DbHelper.TABLE_NAME,
        orderBy: '$DbHelper.COL_BOOK_TIME DESC',
      );

      return right(listMap.map((jsonRaw) => Ticket.fromJson(jsonRaw)).toList());
    } catch (e) {
      return const Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either> createTicket(Ticket ticket) async {
    try {
      return right(DbHelper.db.insert(DbHelper.TABLE_NAME, ticket.toJson()));
    } catch (e) {
      return const Left('An error occurred, Please try again.');
    }
  }
}
