/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-21 21:28:06
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/bloc/authentication/authentication_bloc.dart';
import 'package:cinema_booking/common/widgets/image/svg_image.dart';
import 'package:cinema_booking/core/configs/assets/app_images.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetHomeToolbar extends StatefulWidget {
  const WidgetHomeToolbar({super.key});

  @override
  State<WidgetHomeToolbar> createState() => _WidgetHomeToolbarState();
}

class _WidgetHomeToolbarState extends State<WidgetHomeToolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blue,
      height: 70,
      child: Row(
        children: <Widget>[
          _buildAvatar(),
          _buildNames(),
          _buildActions(),
        ],
      ),
    );
  }

  _buildActions() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // TODO:
            },
            child: MySvgImage(
              path: "assets/ic_ticket.svg",
              width: 20,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }

  _buildNames() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Chung Nguyen Thanh', style: AppFont.kNormalTextStyleWhite.copyWith(fontSize: 14)),
          GestureDetector(
            onTap: () {
              _clickSignOut();
            },
            child: Opacity(
              opacity: 0.5,
              child: Row(
                children: <Widget>[
                  Text('Vietnam', style: AppFont.kNormalTextStyleWhite.copyWith(fontSize: 14)),
                  Icon(Icons.keyboard_arrow_down, color: AppColors.white)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildAvatar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(22)),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
          image: DecorationImage(image: AssetImage(AppImages.avatar)),
        ),
      ),
    );
  }

  _clickSignOut() {
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }
}
