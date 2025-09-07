import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

import '../../../register/mobile/client/register_client_page.dart';

class HeroCardWidget extends StatefulWidget {
  final String userName;
  final Uint8List? imageBytes;
  final String? userImage;
  final String premiumAmount;
  final int polisCount;
  final VoidCallback? onDetailTap;
  final VoidCallback? onNasabahTap;
  final String custType;

  static const String _placeholder = 'assets/images/profile_placeholder.jpg';

  const HeroCardWidget({
    Key? key,
    required this.userName,
    this.imageBytes,
    this.userImage,
    required this.premiumAmount,
    required this.polisCount,
    this.onDetailTap,
    this.onNasabahTap,
    required this.custType,
  }) : super(key: key);

  @override
  State<HeroCardWidget> createState() => _HeroCardWidgetState();
}

class _HeroCardWidgetState extends State<HeroCardWidget> {
  bool _isPremiumVisible = false;

  // Function untuk convert premium amount ke stars
  String _getStarsText(String amount) {
    String cleanAmount = amount.replaceAll(RegExp(r'[^\d]'), '');
    int length = cleanAmount.length;

    // Return bintang sesuai panjang angka
    return '*' * (length > 0 ? length : 8);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: hPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBorderRadius * 2),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.6),
            primaryColor.withOpacity(0.4),
            primaryColor.withOpacity(0.2),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 0.75, 0.9, 1.0],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(1.5),
        padding: const EdgeInsets.all(hPadding + 6),
        decoration: BoxDecoration(
          color: secondaryBlackColor,
          borderRadius: BorderRadius.circular(cardBorderRadius * 2 - 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(context),
            const SizedBox(height: 16),
            _buildInfoCard(context),
            const SizedBox(height: 8),
            _buildDotsIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    final hasBytes = widget.imageBytes != null && widget.imageBytes!.isNotEmpty;
    final src =
        (widget.userImage?.isNotEmpty ?? false)
            ? widget.userImage!
            : HeroCardWidget._placeholder;

    Widget buildFromString(String s) {
      if (s.startsWith('http')) {
        return Image.network(
          s,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _avatarFallback(),
        );
      }
      return Image.asset(
        s,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _avatarFallback(),
      );
    }

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          child: ClipOval(
            child:
                hasBytes
                    ? Image.memory(
                      widget.imageBytes!,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, __, ___) => _avatarFallback(),
                    )
                    : buildFromString(src),
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, ${widget.userName}',
                style: headingStyle(context, fontSize: 22),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: widget.onNasabahTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.custType == 'C'
                              ? 'Klien JPS'
                              : 'Nasabah Biasa',
                          style: bodyTextStyle(context),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: primaryColor,
                          size: 11.33,
                        ),
                      ],
                    ),
                  ),
                  // Button daftar klien

                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _avatarFallback() => Container(
    color: pGrey,
    child: const Icon(Icons.person, color: primaryLightColor, size: 25),
  );

  Widget _buildInfoCard(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius * 1.6),
          border: Border.all(color: sGrey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: vPadding - 12,
                  horizontal: hPadding + 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Premi',
                      style: bodyTextStyle(context).copyWith(fontSize: 16),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child:
                              _isPremiumVisible
                                  ? Text(
                                    'Rp ${widget.premiumAmount}',
                                    key: const ValueKey('visible'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: headingStyle(context),
                                  )
                                  : Text(
                                    _getStarsText(widget.premiumAmount),
                                    key: const ValueKey('stars'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: headingStyle(context),
                                  ),
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPremiumVisible = !_isPremiumVisible;
                              });
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return RotationTransition(
                                  turns: animation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: Icon(
                                _isPremiumVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off_outlined,
                                key: ValueKey(_isPremiumVisible),
                                color: primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: widget.onDetailTap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Buka Detail', style: bodyTextStyle(context)),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            color: primaryColor,
                            size: 11.33,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            Container(width: 1, color: sGrey),

            // Polis
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Polis',
                    textAlign: TextAlign.center,
                    style: bodyTextStyle(context),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.polisCount.toString(),
                    textAlign: TextAlign.center,
                    style: headingStyle(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(color: sGrey, shape: BoxShape.circle),
        ),
      ],
    );
  }
}
