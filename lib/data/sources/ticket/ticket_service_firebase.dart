/*
 * @ Author: Cinema Booking
 * @ Message: Firestore-backed ticket service with local fallback
 */

import 'dart:convert';
import 'package:cinema_booking/core/local/db_helper.dart';
import 'package:cinema_booking/data/models/ticket/ticket.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ticket_service.dart';

class AllTicketsServiceFirebaseImpl extends AllTicketsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userTicketsRef(String uid) {
    return _fs.collection('users').doc(uid).collection('tickets');
  }

  @override
  Future<Either<String, List<Ticket>>> getAllTicketsData() async {
    try {
      final current = _auth.currentUser;
      debugPrint('[TicketsFS] getAllTicketsData signedIn=${current != null} uid=${current?.uid}');
      if (current != null) {
        QuerySnapshot<Map<String, dynamic>> snap;
        try {
          snap = await _userTicketsRef(current.uid)
              .orderBy('book_time', descending: true)
              .get();
        } on FirebaseException catch (fe) {
          // Fallback when ordering by 'book_time' is not available (e.g., missing field/index)
          debugPrint('[TicketsFS] getAllTicketsData fallback query without orderBy due to: ${fe.code} ${fe.message ?? ''}');
          snap = await _userTicketsRef(current.uid).get();
        }
        debugPrint('[TicketsFS] getAllTicketsData docs=${snap.size}');
        final list = snap.docs
            .map((d) => Ticket.fromJson(Map<String, dynamic>.from(d.data())))
            .toList();
        return right(list);
      }

      // Fallback when not signed in
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
      return Left('Failed to get tickets: ${e.toString()}');
    }
  }

  @override
  Future<Either> createTicket(Ticket ticket) async {
    try {
      final current = _auth.currentUser;
      debugPrint('[TicketsFS] createTicket signedIn=${current != null} uid=${current?.uid} ticketId=${ticket.id}');
      if (current != null) {
        final data = ticket.toJson();
        data['createdAt'] = FieldValue.serverTimestamp();
        final ref = await _userTicketsRef(current.uid).add(data);
        debugPrint('[TicketsFS] createTicket saved docId=${ref.id}');
        return right(true);
      }

      // Fallback when not signed in
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
    } on FirebaseException catch (e) {
      debugPrint('[TicketsFS] createTicket error code=${e.code} message=${e.message ?? ''}');
      return Left('Failed to create ticket: ${e.code} ${e.message ?? ''}');
    } catch (e) {
      return Left('Failed to create ticket: ${e.toString()}');
    }
  }
}