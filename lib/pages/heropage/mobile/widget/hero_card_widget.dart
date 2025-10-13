import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../blocs/user_profile/user_profile_cubit.dart';

class HeroCardWidget extends StatefulWidget {
  final String userName;
  final Uint8List? imageBytes;
  final String? userImage;
  final String premiumAmount;
  final int polisCount;
  final VoidCallback? onDetailTap;
  final String custType;


  static const String _placeholder = 'assets/images/profile_placeholder.jpg';

  const HeroCardWidget({
    super.key,
    required this.userName,
    this.imageBytes,
    this.userImage,
    required this.premiumAmount,
    required this.polisCount,
    this.onDetailTap,
    required this.custType,
  });

  @override
  State<HeroCardWidget> createState() => _HeroCardWidgetState();
}

class _HeroCardWidgetState extends State<HeroCardWidget> {
  bool _isPremiumVisible = false;
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
    final custType = widget.custType;
    final mjnsclientId = context.watch<UserProfileCubit>().state.mjnsclientId ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: hPadding + 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBorderRadius * 2),
        gradient: primaryBlackGradient,
      ),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: secondaryBlackColor,
          borderRadius: BorderRadius.circular(cardBorderRadius * 2 - 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildUserHeader(context),
            const SizedBox(height: 16),

            if (custType == 'C' && mjnsclientId == '10') _buildInfoCardPremi(context),

            const SizedBox(height: 12),
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: hPadding + 6),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            height: 46,
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
      )
    );
  }

  Widget _avatarFallback() => Container(
    color: pGrey,
    child: const Icon(Icons.person, color: primaryLightColor, size: 25),
  );

  Widget _buildInfoCardPremi(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius * 1.6),
          border: Border.all(color: sGrey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: hPadding + 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Premi',
                      style: bodyTextStyle(context, fontSize: 16),
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
                                return ScaleTransition(
                                  scale: CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutBack,
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
                    // GestureDetector(
                    //   onTap: widget.onDetailTap,
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Text('Buka Detail', style: bodyTextStyle(context)),
                    //       const SizedBox(width: 2),
                    //       const Icon(
                    //         Icons.keyboard_arrow_right,
                    //         color: primaryColor,
                    //         size: 11.33,
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                    style: bodyTextStyle(context, fontSize: 16),
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
}