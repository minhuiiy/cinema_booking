/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2025-01-25 08:39:35
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'dart:convert';
import 'package:cinema_booking/core/local/db_helper.dart';
import 'package:cinema_booking/data/models/ticket/ticket.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AllTicketsService {
  Future<Either<String, List<Ticket>>> getAllTicketsData();
  Future<Either> createTicket(Ticket ticket);
}

class AllTicketsServiceImpl extends AllTicketsService {
  @override
  Future<Either<String, List<Ticket>>> getAllTicketsData() async {
    try {
      // On web, use SharedPreferences as a fallback storage
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final jsonStr = prefs.getString('CACHE_TICKETS');
        if (jsonStr == null || jsonStr.isEmpty) {
          return right(<Ticket>[]);
        }

        final List<dynamic> arr = jsonDecode(jsonStr);
        final list = arr
            .map((e) => Ticket.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        return right(list);
      }
      var listMap = await DbHelper.db.query(
        DbHelper.TABLE_NAME,
        orderBy: '${DbHelper.COL_BOOK_TIME} DESC',
      );

      return right(listMap.map((jsonRaw) => Ticket.fromJson(jsonRaw)).toList());
    } catch (e) {
      return const Left(
        'An error occurred in getAllTicketsData, Please try again.',
      );
    }
  }

  @override
  Future<Either> createTicket(Ticket ticket) async {
    try {
      // On web, persist into SharedPreferences as array of JSON
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final jsonStr = prefs.getString('CACHE_TICKETS');
        final List<dynamic> arr =
            (jsonStr != null && jsonStr.isNotEmpty) ? jsonDecode(jsonStr) : [];
        arr.add(ticket.toJson());
        await prefs.setString('CACHE_TICKETS', jsonEncode(arr));
        return right(true);
      }
      return right(DbHelper.db.insert(DbHelper.TABLE_NAME, ticket.toJson()));
    } catch (e) {
      return const Left('An error occurred in createTicket, Please try again.');
    }
  }
}
