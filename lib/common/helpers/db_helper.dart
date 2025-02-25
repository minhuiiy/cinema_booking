/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2025-02-17 21:05:06
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

// ignore_for_file: non_constant_identifier_names

import 'package:cinema_booking/common/helpers/log_helpers.dart';
import 'package:cinema_booking/data/sources/ticket/ticket_service.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final TABLE_NAME = "tickets";
  static final COL_ID = "id";
  static final COL_SHOW_NAME = "movie_name";
  static final COL_SHOW_BANNER = "movie_banner";
  static final COL_SHOW_TIME_SLOT = "movie_time_slot";
  static final COL_BOOK_TIME = "book_time";
  static final COL_CINE_NAME = "cine_name";
  static final COL_SEAT = "seat";

  static late Database _db;

  static _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE "$TABLE_NAME" ( "$COL_ID" INTEGER PRIMARY KEY AUTOINCREMENT, '
      '"$COL_SHOW_NAME" TEXT,"$COL_SHOW_BANNER" TEXT, "$COL_SHOW_TIME_SLOT" TEXT, '
      '"$COL_BOOK_TIME" INTEGER, "$COL_CINE_NAME" TEXT, "$COL_SEAT" TEXT );',
    );

    LogHelper.debug(tag: "DbHelper", message: '_onCreate. version $version');
  }

  static Future init() async {
    _db = await openDatabase(
      'cinemabooking.db',
      version: 1,
      singleInstance: true,
      onCreate: _onCreate,
    );

    var result = await sl<AllTicketsService>().getAllTicketsData();
    LogHelper.debug(tag: "DbHelper", message: result.toString());
  }

  static Database get db => _db;
}
