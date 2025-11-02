/*
 * Screen: Hiển thị mã QR của vé khi người dùng nhấn vào vé
 */

import 'dart:convert';
import 'dart:typed_data';

import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/core/local/pref.dart';
import 'package:cinema_booking/data/models/ticket/ticket.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TicketQrArguments {
  final Ticket ticket;
  TicketQrArguments({required this.ticket});
}

class TicketQrScreen extends StatefulWidget {
  final TicketQrArguments args;
  const TicketQrScreen({super.key, required this.args});

  @override
  State<TicketQrScreen> createState() => _TicketQrScreenState();
}

class _TicketQrScreenState extends State<TicketQrScreen> {
  Uint8List? _qrBytes;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQr();
  }

  Future<void> _loadQr() async {
    try {
      final raw = await LocalPref().getString('TICKET_QR_${widget.args.ticket.id}');
      final decoded = _decodeBase64Image(raw);
      if (mounted) {
        setState(() {
          _qrBytes = decoded;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Uint8List? _decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    try {
      final cleaned = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;
      return base64Decode(cleaned);
    } catch (e) {
      if (kDebugMode) {
        print('Decode QR failed: $e');
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.args.ticket;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mã QR vé'),
          backgroundColor: AppColors.darkBackground,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.movieName, style: AppFont.semibold_white_18),
              WidgetSpacer(height: 4),
              Text('${t.cineName} • ${t.movieTimeSlot}', style: AppFont.regular_white_12),
              WidgetSpacer(height: 4),
              Text('Ghế: ${t.seat.replaceAll(';', ', ')}', style: AppFont.regular_white_12),
              WidgetSpacer(height: 16),
              Expanded(
                child: Center(
                  child: _loading
                      ? const CircularProgressIndicator()
                      : (_qrBytes != null
                          ? Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.greyLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.memory(
                                _qrBytes!,
                                width: 280,
                                height: 280,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Text('QR không khả dụng', style: AppFont.regular_white_14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}