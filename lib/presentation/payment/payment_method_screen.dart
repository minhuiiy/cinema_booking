/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Message: Payment Method Screen — Visa mock + send QR via backend
 */

import 'dart:convert';
import 'dart:typed_data';

import 'package:cinema_booking/common/widgets/snackbar/custom_snackbar.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/data/models/ticket/ticket.dart';
import 'package:cinema_booking/service_locator.dart';
import 'package:cinema_booking/domain/usecase/tickets/create_ticket.dart';
import 'package:cinema_booking/core/local/pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cinema_booking/core/api/api_config.dart';
// import removed: dartz
import 'package:go_router/go_router.dart';
import 'package:cinema_booking/presentation/payment/ticket_success_screen.dart';

class PaymentArguments {
  final double amount;
  final String movieName;
  final String cineName;
  final List<String> seatIds;
  final String timeSlot;
  final String? email;

  PaymentArguments({
    required this.amount,
    required this.movieName,
    required this.cineName,
    required this.seatIds,
    required this.timeSlot,
    this.email,
  });
}

class PaymentMethodScreen extends StatefulWidget {
  final PaymentArguments args;
  const PaymentMethodScreen({super.key, required this.args});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cardNumberCtrl = TextEditingController();
  final _expMonthCtrl = TextEditingController();
  final _expYearCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  Uint8List? _qrBytes;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.args.email != null) {
      _emailCtrl.text = widget.args.email!;
    }
  }

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expMonthCtrl.dispose();
    _expYearCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
      final payload = {
        'cardNumber': _cardNumberCtrl.text.trim(),
        'expMonth': int.tryParse(_expMonthCtrl.text.trim()),
        'expYear': int.tryParse(_expYearCtrl.text.trim()),
        'cvv': _cvvCtrl.text.trim(),
        'amount': widget.args.amount,
        'currency': 'VND',
        'email': _emailCtrl.text.trim(),
        'ticket': {
          'movieName': widget.args.movieName,
          'cineName': widget.args.cineName,
          'seatIds': widget.args.seatIds.join(';'),
          'timeSlot': widget.args.timeSlot,
        }
      };

      final res = await dio.post('/api/visa/pay', data: payload);
      final data = res.data as Map<String, dynamic>;
      final base64png = data['qrBase64'] as String?;
      final emailSent = (data['emailSent'] ?? false) as bool;

      // create local ticket after payment success
      final ticket = Ticket(
        DateTime.now().millisecondsSinceEpoch,
        widget.args.movieName,
        '',
        widget.args.timeSlot,
        DateTime.now().millisecondsSinceEpoch,
        widget.args.cineName,
        widget.args.seatIds.join(';'),
      );
      await sl<CreateTicketUseCase>().call(params: ticket);

      // Lưu QR kèm theo id vé để hiển thị lại sau này khi người dùng xem vé
      if (base64png != null && base64png.isNotEmpty) {
        try {
          await LocalPref().saveString('TICKET_QR_${ticket.id}', base64png);
        } catch (_) {
          // ignore storing error
        }
      }

      // Navigate to Ticket Success screen with QR and details
      if (mounted && base64png != null) {
        final succArgs = TicketSuccessArguments(
          qrBase64: base64png,
          movieName: widget.args.movieName,
          cineName: widget.args.cineName,
          timeSlot: widget.args.timeSlot,
          seatIds: widget.args.seatIds,
          amount: widget.args.amount,
        );
        context.push('/ticketSuccess', extra: succArgs);
        return;
      }

      if (mounted) {
        CustomSnackBar.success(
          context,
          msg: emailSent
              ? 'Thanh toán thành công.'
              : 'Thanh toán thành công. (Email chưa cấu hình)'
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.failure(context, msg: 'Thanh toán lỗi: $e');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thanh toán Visa'),
          backgroundColor: AppColors.darkBackground,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Số tiền: ${widget.args.amount.toStringAsFixed(0)} VNĐ', style: AppFont.semibold_white_18),
                WidgetSpacer(height: 16),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Tên chủ thẻ'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập tên chủ thẻ' : null,
                ),
                WidgetSpacer(height: 8),
                TextFormField(
                  controller: _cardNumberCtrl,
                  decoration: const InputDecoration(labelText: 'Số thẻ (Visa)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.trim().length < 13) ? 'Số thẻ không hợp lệ' : null,
                ),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expMonthCtrl,
                      decoration: const InputDecoration(labelText: 'Tháng hết hạn (MM)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => (int.tryParse(v ?? '') ?? 0) > 0 ? null : 'MM không hợp lệ',
                    ),
                  ),
                  WidgetSpacer(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _expYearCtrl,
                      decoration: const InputDecoration(labelText: 'Năm hết hạn (YYYY)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => (int.tryParse(v ?? '') ?? 0) >= DateTime.now().year ? null : 'YYYY không hợp lệ',
                    ),
                  ),
                ]),
                WidgetSpacer(height: 8),
                TextFormField(
                  controller: _cvvCtrl,
                  decoration: const InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.trim().length < 3) ? 'CVV không hợp lệ' : null,
                ),
                WidgetSpacer(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email nhận mã QR'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@')) ? 'Email không hợp lệ' : null,
                ),
                WidgetSpacer(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting ? const CircularProgressIndicator() : const Text('Thanh toán'),
                  ),
                ),

                WidgetSpacer(height: 24),
                // QR sẽ hiển thị ở trang chúc mừng sau khi thanh toán
              ],
            ),
          ),
        ),
      ),
    );
  }
}