import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class HeroCardWidget extends StatelessWidget {
  final String userName;
  final Uint8List? imageBytes;        // foto dari cubit (prioritas)
  final String? userImage;            // opsional; kalau null → pakai placeholder
  final String premiumAmount;
  final int polisCount;
  final VoidCallback? onDetailTap;
  final VoidCallback? onNasabahTap;

  static const String _placeholder = 'assets/images/profile_placeholder.jpg';

  const HeroCardWidget({
    Key? key,
    required this.userName,
    this.imageBytes,
    this.userImage,                   // <-- opsional
    required this.premiumAmount,
    required this.polisCount,
    this.onDetailTap,
    this.onNasabahTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: hPadding),
      padding: const EdgeInsets.all(hPadding),
      decoration: BoxDecoration(
        color: secondaryBlackColor,
        borderRadius: BorderRadius.circular(cardBorderRadiusForHome),
        border: Border.all(color: primaryColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(context),
          const SizedBox(height: fieldSpacing),
          _buildInfoCard(context),
          const SizedBox(height: 10),
          _buildDotsIndicator(),
        ],
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    final hasBytes = imageBytes != null && imageBytes!.isNotEmpty;
    final src = (userImage?.isNotEmpty ?? false) ? userImage! : _placeholder;

    Widget buildFromString(String s) {
      if (s.startsWith('http')) {
        return Image.network(s, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _avatarFallback());
      }
      return Image.asset(s, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _avatarFallback());
    }

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor, width: 2),
          ),
          child: ClipOval(
            child: hasBytes
                ? Image.memory(
              imageBytes!,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, __, ___) => _avatarFallback(),
            )
                : buildFromString(src), // <-- kalau bytes null, pakai placeholder
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Halo, $userName',
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 20),
                    color: primaryLightColor,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onNasabahTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Nasabah Biasa', style: TextStyle(color: sGrey)),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_right, color: primaryColor, size: 18),
                  ],
                ),
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
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: pGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(cardInsideBorderRadiusForHome),
      ),
      child: Row(
        children: [
          // Premium
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Premi',
                    style: TextStyle(
                      fontSize: getResponsiveFont(context, 14),
                      color: primaryLightColor,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          premiumAmount,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: getResponsiveFont(context, 22),
                            color: primaryLightColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.visibility_outlined, color: primaryColor, size: 20),
                    ],
                  ),
                  GestureDetector(
                    onTap: onDetailTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Buka Detail',
                            style: TextStyle(
                              fontSize: getResponsiveFont(context, 14),
                              color: primaryColor,
                            )),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_right, color: primaryColor, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Container(width: 1, height: double.infinity, color: sGrey.withOpacity(0.3)),

          // Polis
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Polis',
                      style: TextStyle(
                        fontSize: getResponsiveFont(context, 14),
                        color: primaryLightColor,
                      )),
                  const SizedBox(height: 8),
                  Text(
                    polisCount.toString(),
                    style: TextStyle(
                      fontSize: getResponsiveFont(context, 36),
                      color: primaryLightColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: sGrey, shape: BoxShape.circle)),
      ],
    );
  }
}
