import 'dart:async';
import 'package:cinema_booking/common/bloc/authentication/authentication_bloc.dart';
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

class _WidgetHomeToolbarState extends State<WidgetHomeToolbar> with TickerProviderStateMixin {
  int _textIndex = 0;
  late Timer _timer;
  late AnimationController _avatarController;
  late AnimationController _notificationController;
  late Animation<double> _avatarGlow;
  late Animation<double> _notificationShake;
  final List<Widget> _textWidgets = [];

  @override
  void initState() {
    super.initState();
    _initTextWidgets();
    _setupAnimations();
    _startTextSwitcher();
  }

  /// Khởi tạo danh sách các Widget để chuyển đổi
  void _initTextWidgets() {
    _textWidgets.add(_buildUserInfo());
    _textWidgets.add(_buildAlternateText("Hello Have a nice day"));
    _textWidgets.add(_buildAlternateText("Cinema booking yêu bạn"));
  }

  /// Thiết lập animation cho Avatar và Icon chuông
  void _setupAnimations() {
    _avatarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _avatarGlow = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.easeInOut),
    );

    _notificationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _notificationShake = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(parent: _notificationController, curve: Curves.elasticIn),
    );
  }

  /// Bắt đầu hiệu ứng shake khi có thông báo mới
  void _triggerNotificationShake() {
    _notificationController.forward(from: 0.0);
  }

  /// Chạy hiệu ứng chuyển đổi text
  void _startTextSwitcher() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _textIndex = (_textIndex + 1) % _textWidgets.length;
      });
      _triggerNotificationShake();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _avatarController.dispose();
    _notificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.darkBackground,
      height: 70,
      child: Row(
        children: <Widget>[
          _buildAvatarAndName(),
          _buildNotificationIcon(),
        ],
      ),
    );
  }

  /// Gộp Avatar và phần tên vào một hàng
  Widget _buildAvatarAndName() {
    return Expanded(
      child: Row(
        children: [
          _buildAnimatedAvatar(),
          const SizedBox(width: 12),
          _buildAnimatedText(),
        ],
      ),
    );
  }

  /// Avatar cinematic với hiệu ứng glow và rung nhẹ
  Widget _buildAnimatedAvatar() {
    return ScaleTransition(
      scale: _avatarGlow,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
          image: DecorationImage(image: AssetImage(AppImages.avatar)),
        ),
      ),
    );
  }

  /// Hiệu ứng trượt chữ cinematic
  Widget _buildAnimatedText() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _textWidgets[_textIndex],
    );
  }

  /// Widget chứa tên + quốc gia
  Widget _buildUserInfo() {
    return Column(
      key: const ValueKey("UserInfo"),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Chung Nguyen Thanh',
          style: AppFont.kNormalTextStyleWhite.copyWith(fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            _clickSignOut();
          },
          child: Opacity(
            opacity: 0.5,
            child: Row(
              children: <Widget>[
                Text('Vietnam', style: AppFont.kNormalTextStyleWhite.copyWith(fontSize: 14)),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Widget chứa văn bản thay thế
  Widget _buildAlternateText(String text) {
    return Column(
      key: ValueKey(text),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: AppFont.kNormalTextStyleWhite.copyWith(fontSize: 14),
        ),
      ],
    );
  }

  /// Icon chuông cinematic với hiệu ứng rung khi có thông báo mới
  Widget _buildNotificationIcon() {
    return AnimatedBuilder(
      animation: _notificationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_notificationShake.value, 0.0),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          _triggerNotificationShake();
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
          child: const Icon(
            Icons.notifications,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  /// Xử lý đăng xuất
  void _clickSignOut() {
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }
}
