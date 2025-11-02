/*
 * Ticket Success Screen: shows congratulatory message and QR code
 */

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TicketSuccessArguments {
  final String qrBase64; // PNG base64
  final String movieName;
  final String cineName;
  final String timeSlot;
  final List<String> seatIds;
  final double amount;

  TicketSuccessArguments({
    required this.qrBase64,
    required this.movieName,
    required this.cineName,
    required this.timeSlot,
    required this.seatIds,
    required this.amount,
  });
}

class TicketSuccessScreen extends StatelessWidget {
  final TicketSuccessArguments args;
  const TicketSuccessScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final Uint8List? qrBytes = _decodeBase64Image(args.qrBase64);
    final seatText = args.seatIds.join(', ');

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🎉 Chúc mừng đặt vé thành công!', style: AppFont.semibold_white_18),
                WidgetSpacer(height: 8),
                Text(args.movieName, style: AppFont.medium_white_16),
                WidgetSpacer(height: 4),
                Text('${args.cineName} • ${args.timeSlot}', style: AppFont.regular_white_12),
                WidgetSpacer(height: 4),
                Text('Ghế: $seatText', style: AppFont.regular_white_12),
                WidgetSpacer(height: 10),
                Text('Số tiền: ${args.amount.toStringAsFixed(0)} VNĐ', style: AppFont.medium_white_14),
                WidgetSpacer(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: qrBytes != null
                      ? Image.memory(qrBytes, width: 220, height: 220)
                      : SizedBox(
                          width: 220,
                          height: 220,
                          child: Center(
                            child: Text(
                              'QR không khả dụng',
                              style: AppFont.medium_black2_16,
                            ),
                          ),
                        ),
                ),
                WidgetSpacer(height: 20),
                SizedBox(
                  width: 280,
                  child: ElevatedButton(
                    onPressed: () => context.go('/listTickets'),
                    child: const Text('Xem danh sách vé'),
                  ),
                ),
                WidgetSpacer(height: 8),
                SizedBox(
                  width: 280,
                  child: OutlinedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Về trang chủ'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Uint8List? _decodeBase64Image(String raw) {
  try {
    // Strip data URL prefix if present
    final String normalized = raw.contains(',') ? raw.split(',').last : raw;
    return base64Decode(normalized);
  } catch (_) {
    return null;
  }
}