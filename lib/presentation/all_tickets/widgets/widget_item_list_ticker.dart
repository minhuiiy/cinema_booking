/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2025-02-22 08:39:35
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/helpers/formatter_helpers.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/data/models/ticket/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_booking/presentation/all_tickets/ticket_qr_screen.dart';
import 'package:cinema_booking/common/widgets/image/shimmer_image.dart';

class WidgetItemListTicker extends StatelessWidget {
  final double itemHeight = 148;

  final Ticket ticket;

  const WidgetItemListTicker(this.ticket, {super.key});

  @override
  Widget build(BuildContext context) {
    String banner = ticket.movieBanner;
    String movieName = ticket.movieName;
    String timeSlot = ticket.movieTimeSlot;
    (ticket.bookTime ~/ 1000).MMM_dd_yyyy();
    String cineName = ticket.cineName;

    //
    List<String> seatSlots = ticket.seat.split(";");
    String strSeatSlot = seatSlots[0];
    seatSlots.skip(1).forEach((element) {
      int index = seatSlots.indexOf(element);
      if (index % 2 == 0) {
        strSeatSlot = "$strSeatSlot\n$element";
      } else {
        strSeatSlot = "$strSeatSlot, $element";
      }
    });

    return InkWell(
      onTap: () {
        final args = TicketQrArguments(ticket: ticket);
        if (kIsWeb) {
          GoRouter.of(context).push('/ticketQr', extra: args);
        } else {
          context.push('/ticketQr', extra: args);
        }
      },
      child: Container(
        color: AppColors.darkBackground,
        height: itemHeight,
        child: Row(
          children: [
            _PosterImage(url: banner, width: 108, height: itemHeight),
            WidgetSpacer(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movieName,
                    style: AppFont.medium_black2_16.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  WidgetSpacer(height: 2),
                  Text(
                    timeSlot,
                    style: AppFont.medium.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  WidgetSpacer(height: 2),
                  Text(
                    cineName,
                    style: AppFont.medium.copyWith(
                      color: AppColors.gray6,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 4),
              child: Container(width: 2, color: AppColors.lightBackground),
            ),
            SizedBox(
              width: 76,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ghế", style: AppFont.regular_black2_12),
                  WidgetSpacer(height: 4),
                  Text(
                    strSeatSlot,
                    style: AppFont.oswald_regular.copyWith(
                      color: AppColors.defaultColor,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  const _PosterImage({required this.url, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final placeholder = 'assets/images/ticket.png';
    if (url.isEmpty) {
      return Image.asset(placeholder, width: width, height: height, fit: BoxFit.cover);
    }
    // Use ShimmerImage which proxies on web to avoid CORS/SSL errors and shows a graceful placeholder while loading.
    return ShimmerImage(
      url: url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      iconHolderSize: 28,
    );
  }
}
