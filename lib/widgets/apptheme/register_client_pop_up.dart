// register_client_pop_up.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/constants.dart';

class RegisterClientPopUp extends StatelessWidget {
  final String header;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;
  final bool showIcon;
  final bool showHeaderIcon;
  final VoidCallback? onClose;

  const RegisterClientPopUp({
    super.key,
    required this.header,
    required this.description,
    required this.buttonText,
    required this.onPressed,
    this.showIcon = true,
    this.showHeaderIcon = true,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showHeaderIcon) ...[
              SvgPicture.asset(
                'assets/icons/Information2.svg',
                width: 40,
                height: 40,
                colorFilter: const ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),

              const SizedBox(height: hPadding),
            ],

            Text(
              header,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryLightColor,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.35,
                color: dGrey,
              ),
            ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: showIcon
                  ? AppButton.iconLeft(
                text: buttonText,
                backgroundColor: primaryColor,
                icon: SvgPicture.asset(
                  'assets/icons/daftar_client.svg',
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressed();
                },
              )
                  : AppButton.primary(
                text: buttonText,
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressed();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}