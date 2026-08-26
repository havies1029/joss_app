import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

typedef RegisterPhoneStatusAction = Future<bool> Function();

Future<bool?> showRegisterPhoneStatusPopup(
  BuildContext context, {
  required bool isRegistered,
  required RegisterPhoneStatusAction onPressed,
  String? titleOverride,
  String? descriptionOverride,
  String? buttonTextOverride,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.55),
    builder: (_) {
      return _RegisterPhoneStatusPopup(
        isRegistered: isRegistered,
        onPressed: onPressed,
        titleOverride: titleOverride,
        descriptionOverride: descriptionOverride,
        buttonTextOverride: buttonTextOverride,
      );
    },
  );
}

class _RegisterPhoneStatusPopup extends StatefulWidget {
  final bool isRegistered;
  final RegisterPhoneStatusAction onPressed;
  final String? titleOverride;
  final String? descriptionOverride;
  final String? buttonTextOverride;

  const _RegisterPhoneStatusPopup({
    required this.isRegistered,
    required this.onPressed,
    this.titleOverride,
    this.descriptionOverride,
    this.buttonTextOverride,
  });

  @override
  State<_RegisterPhoneStatusPopup> createState() =>
      _RegisterPhoneStatusPopupState();
}

class _RegisterPhoneStatusPopupState extends State<_RegisterPhoneStatusPopup> {
  bool _isLoading = false;

  String get _title =>
      widget.titleOverride ??
      (widget.isRegistered
          ? 'Nomor telepon telah terdaftar'
          : 'Nomor telepon berhasil diverifikasi');

  String get _description =>
      widget.descriptionOverride ??
      (widget.isRegistered
          ? 'Akun Anda telah terdaftar. Silahkan atur kata sandi baru untuk mengakses akun tersebut.'
          : 'Nomor telepon Anda berhasil diverifikasi. Silahkan lengkapi data diri untuk membuat akun Proteksi Plus.');

  String get _buttonText =>
      widget.buttonTextOverride ??
      (widget.isRegistered ? 'Atur Kata Sandi' : 'Lengkapi Data');

  Future<void> _handlePressed() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final shouldClose = await widget.onPressed();
    if (!mounted) return;

    if (shouldClose) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: hPadding * 1.5,
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: hPadding * 1.5,
          vertical: hPadding * 2.4,
        ),
        decoration: BoxDecoration(
          color: thirdBlackColor,
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/simple-line-icons_check.svg',
                height: 46,
                colorFilter: const ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: vPadding),
              Text(
                _title,
                style: bodyTextStyle(context, fontSize: 18).copyWith(
                  color: primaryLightColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: hPadding),
              Text(
                _description,
                style: bodyTextStyle(context, fontSize: 16).copyWith(
                  color: dGrey,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: vPadding),
              AppButton.primary(
                text: _buttonText,
                isLoading: _isLoading,
                backgroundColor:
                    _isLoading ? secondaryBlackColor : primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: _isLoading ? null : _handlePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
