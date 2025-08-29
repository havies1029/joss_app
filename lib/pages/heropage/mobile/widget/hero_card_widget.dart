import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class HeroCardWidget extends StatefulWidget {
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
  State<HeroCardWidget> createState() => _HeroCardWidgetState();
}

class _HeroCardWidgetState extends State<HeroCardWidget> {
  bool _isPremiumVisible = false; // Default: hidden dengan bintang-bintang

  // Function untuk convert premium amount ke stars
  String _getStarsText(String amount) {
    // Hitung panjang text tanpa spasi dan format
    String cleanAmount = amount.replaceAll(RegExp(r'[^\d]'), ''); // Hapus non-digit
    int length = cleanAmount.length;

    // Return bintang sesuai panjang angka
    return '*' * (length > 0 ? length : 8); // Minimum 8 bintang jika kosong
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: hPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBorderRadius*2),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor,                    // Border penuh di atas
            primaryColor,                    // Border penuh sampai tengah
            primaryColor.withOpacity(0.6),   // Mulai fade pertama
            primaryColor.withOpacity(0.2),   // Fade lebih halus
            Colors.transparent,              // Transparan di bawah
          ],
          stops: const [0.0, 0.5, 0.75, 0.9, 1.0], // Fade lebih smooth
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(1.5), // Margin untuk efek border
        padding: const EdgeInsets.all(hPaddingForCard),
        decoration: BoxDecoration(
          color: secondaryBlackColor,
          borderRadius: BorderRadius.circular(cardBorderRadius*2-1.5),
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
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    final hasBytes = widget.imageBytes != null && widget.imageBytes!.isNotEmpty;
    final src = (widget.userImage?.isNotEmpty ?? false) ? widget.userImage! : HeroCardWidget._placeholder;

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
          child: ClipOval(
            child: hasBytes
                ? Image.memory(
              widget.imageBytes!,
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
              Text('Halo, ${widget.userName}',
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 20),
                    color: primaryLightColor,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: widget.onNasabahTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Nasabah Biasa',
                      style: TextStyle(
                        color: primaryLightColor,
                        fontSize: getResponsiveFont(context, 18),
                      ),
                    ),
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
      height: 122,
      decoration: BoxDecoration(
        color: pGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(cardBorderRadius * 1.6),
        border: Border.all( // ⬅️ tambahkan border luar
          color: sGrey,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Premium dengan stars toggle
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
                      fontSize: getResponsiveFont(context, 16),
                      color: primaryLightColor,
                    ),
                  ),
                  Row(
                    children: [
                      // Fixed width container untuk text agar icon tidak bergeser
                      SizedBox(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            // Smooth fade transition tanpa slide untuk menghindari pergeseran
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
                            style: TextStyle(
                              fontSize: getResponsiveFont(context, 26),
                              color: primaryLightColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : Text(
                            _getStarsText(widget.premiumAmount),
                            key: const ValueKey('stars'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: getResponsiveFont(context, 26),
                              color: primaryLightColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0, // Spacing antar bintang
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Icon dengan posisi tetap
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
                              // Smooth rotation transition untuk icon
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
                        Text('Buka Detail',
                            style: TextStyle(
                              fontSize: getResponsiveFont(context, 14),
                              color: primaryLightColor,
                            )),
                        const Icon(Icons.keyboard_arrow_right, color: primaryColor, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Container(width: 1, height: double.infinity, color: sGrey),

          // Polis
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center( // ⬅️ bikin konten tepat di tengah area ini
                child: Column(
                  mainAxisSize: MainAxisSize.min,                // ⬅️ biar setinggi kontennya saja
                  mainAxisAlignment: MainAxisAlignment.center,   // ⬅️ tengah vertikal
                  crossAxisAlignment: CrossAxisAlignment.center, // ⬅️ tengah horizontal
                  children: [
                    Text(
                      'Polis',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getResponsiveFont(context, 14),
                        color: primaryLightColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.polisCount.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getResponsiveFont(context, 30),
                        color: primaryLightColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
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