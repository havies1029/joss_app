import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';
import '../blocs/gallery/gallerymembercari_bloc.dart';

class ClientSection extends StatefulWidget {
  const ClientSection({super.key});

  @override
  State<ClientSection> createState() => _ClientSectionState();
}

class _ClientSectionState extends State<ClientSection> {
  @override
  void initState() {
    super.initState();
    context.read<GallerymemberCariBloc>().add(RefreshGallerymemberCariEvent());
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Judul + icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/badge.svg', height: 24),
              const SizedBox(width: 6),
              Text(
                "Resmi, Aman dan Terpercaya",
                style: bodyTextStyle(context, fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Badge orange
          Container(
            padding: const EdgeInsets.symmetric(horizontal: hPadding, vertical: 5),
            decoration: BoxDecoration(
              color: pGrey,
              borderRadius: BorderRadius.circular(cardBorderRadius),
              border: Border.all(color: sGrey),
            ),
            child: Text(
              "Terdaftar Resmi Oleh:",
              style: bodyTextStyle(context, fontSize: 14),
            ),
          ),
          const SizedBox(height: 18),
          // LOGO Klien (from Bloc)
          BlocBuilder<GallerymemberCariBloc, GallerymemberCariState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < state.items.length && i < 3; i++) ...[
                    _ClientLogoCard(
                      imagePath: state.items[i].image1Url,
                      isMobile: isMobile,
                    ),
                    if (i < 2) const SizedBox(width: 15),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          Text(
            "Ikuti perjalanan kami & temukan insight seputar asuransi:",
            textAlign: TextAlign.center,
            style: bodyTextStyle(context),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocmedIcon('assets/icons/instagram.svg', isMobile),
              const SizedBox(width: 15),
              SocmedIcon('assets/icons/tiktok.svg', isMobile),
              const SizedBox(width: 15),
              SocmedIcon('assets/icons/linkedin.svg', isMobile),
              const SizedBox(width: 15),
              SocmedIcon('assets/icons/facebook.svg', isMobile),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClientLogoCard extends StatelessWidget {
  final String imagePath;
  final bool isMobile;

  const _ClientLogoCard({required this.imagePath, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final double cardWidth = isMobile ? 72 : 95;
    final double cardHeight = isMobile ? 42 : 60;

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
        color: primaryLightColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardBorderRadius - 1),
        child: Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder:
              (c, e, s) => Icon(
                Icons.error,
                color: Colors.grey,
                size: isMobile ? 18 : 32,
              ),
        ),
      ),
    );
  }
}

Widget SocmedIcon(String assetPath, bool isMobile) => Container(
  width: isMobile ? 40 : 48,
  height: isMobile ? 40 : 48,
  padding: const EdgeInsets.all(1),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: sGrey
  ),
  child: Container(
    decoration: const BoxDecoration(
      color: pGrey,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: SvgPicture.asset(
        assetPath,
        width: isMobile ? 20 : 30,
        height: isMobile ? 20 : 30,
        colorFilter: const ColorFilter.mode(primaryLightColor, BlendMode.srcIn),
        allowDrawingOutsideViewBox: true,
        fit: BoxFit.scaleDown,
      ),
    ),
  ),
);
