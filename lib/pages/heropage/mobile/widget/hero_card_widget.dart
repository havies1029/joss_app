import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

import '../../../settingpage/mobile/settingpage.dart';

class HeroCardWidget extends StatefulWidget {
  final String userName;
  final Uint8List? imageBytes;
  final String? userImage;
  final String premiumAmount;
  final int polisCount;
  final int asetCount;
  final VoidCallback? onDetailTap;
  final String custType;


  static const String _placeholder = 'assets/images/profile_placeholder.jpg';

  const HeroCardWidget({
    Key? key,
    required this.userName,
    this.imageBytes,
    this.userImage,
    required this.premiumAmount,
    required this.polisCount,
    required this.asetCount,
    this.onDetailTap,
    required this.custType,
  }) : super(key: key);

  @override
  State<HeroCardWidget> createState() => _HeroCardWidgetState();
}

class _HeroCardWidgetState extends State<HeroCardWidget> {
  bool _isPremiumVisible = false;
  int _cardIndex = 0;
  late final PageController _cardPageController;
  String _getStarsText(String amount) => '-' * 6;
  @override
  void initState() {
    super.initState();
    _cardPageController = PageController(
      viewportFraction: 1.0,
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _cardPageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: hPadding + 5),
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
            SizedBox(
              height: 120, // kasih tinggi tetap supaya PageView punya constraint
              child: PageView(
                controller: _cardPageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) => setState(() => _cardIndex = i),
                children: [
                  _buildInfoCardPremi(context), // card 1 (punyamu yang premi)
                  _buildInfoCardPolis(context), // card 2 (ringkasan polis + tipe)
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildDotsIndicator(count: 2, index:_cardIndex),
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
              Text(
                widget.custType == 'C'
                    ? 'Klien JPS'
                    : 'Nasabah Biasa',
                style: bodyTextStyle(context),
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

  Widget _buildInfoCardPremi(BuildContext context) {
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
                        // ===== Amount =====
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: _isPremiumVisible
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
                        // ===== Icon =====
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
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                // bikin animasi scale + fade
                                return ScaleTransition(
                                  scale: CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutBack, // efek "jauh → deket" smooth
                                  ),
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

  Widget _buildInfoCardPolis(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Aset',
                      style: bodyTextStyle(context).copyWith(fontSize: 16),
                    ),
                    Text(
                      '${widget.asetCount}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: headingStyle(context),
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
          ],
        ),
      ),
    );
  }

  Widget _buildDotsIndicator({required int count, required int index}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 8,
          width: active ? 18 : 8, // aktif lebih panjang biar jelas
          decoration: BoxDecoration(
            color: active ? primaryColor : sGrey,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}