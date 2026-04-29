import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../widgets/apptheme/example_nested_scrollable_table_page.dart';
import '../../../cari_asuransi/mobile/cari_asuransi_page2.dart';
import '../../../management_polis/mobile/management_polis_page.dart';
import '../../../perbaruiklaimmv/mobile/klaimmvpoliscrud_form.dart';
import '../../../register/mobile/client/register_client_page.dart';
import 'package:confetti/confetti.dart';
import '../../../regklaim/mobile/registrasi_klaim/daftar_cob_klaim_page.dart';
import '../../../tagihan_pembayaran/tagihan_pembayaran_page.dart';
import 'package:joss_app/pages/regklaim/mobile/main_page/klaim_main_page.dart';

class ListMenuWidget extends StatelessWidget {
  final String userType;

  const ListMenuWidget({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    final menuItems = _getMenuItems();
    final itemWidth = getItemWidth(context);

    final textStyle = bodyTextStyle(context).copyWith(
      height: 1.2,
    );

    bool willWrapToSecondLine(String text) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr,
        ellipsis: '…',
      )..layout(maxWidth: itemWidth - 8);

      return tp.didExceedMaxLines;
    }

    final needsExtraHeight = menuItems.any((m) => willWrapToSecondLine(m.title));
    final double menuHeight = needsExtraHeight ? 140 : 120;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        /*
        micky - 2026-02-20
        if (state is AuthenticationRequireRegisterClient) {
          _openRegisterClientDialog(context, requestFrom: state.requiredFrom);
        }
        */
      },
      child: Column(
        children: [
          if (userType != 'C') _buildDaftarKlienButton(context),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              color: secondaryBlackColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(cardBorderRadius),
                bottomRight: Radius.circular(cardBorderRadius),
              ),
            ),
            child: SizedBox(
              height: menuHeight,
              child: Stack(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return SizedBox(
                        width: itemWidth,
                        child: _buildMenuItem(context, item, userType),
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 40,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: blackFadeGradientHorizontal,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 48,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: blackFadeGradientHorizontalReversed,
                        ),
                      ),
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

/*
  void _openRegisterClientDialog(BuildContext context, {required String requestFrom}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: primaryBlackColor,
              child: RegisterClient(requestFrom: requestFrom),
            ),
          ),
        );
      },
      /*
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        );
      },
      */
    );
  }
  */

  Widget _buildDaftarKlienButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        onTap: () {
          // optional: haptic biar terasa "klik"
          // HapticFeedback.lightImpact();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegisterClient(requestFrom: 'daftarclient_page'),
            ),
          );
          /*
          context.read<AuthenticationBloc>().add(
            RequireRegisterClient(
              requiredFrom: 'daftarclient_page',
            ),
          );
          */
        },
        child: Ink(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: registerButtonGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: hPadding,
              horizontal: vPadding,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/diamond.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Daftar Klien Sekarang!',
                            style: bodyTextStyle(context, fontSize: 16),
                          ),
                          Text(
                            'Langkah pertama untuk mengelola Polis',
                            style: bodyTextStyle(context, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                // CTA "Mulai"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Mulai',
                    style: bodyTextStyle(context, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildMenuItem(BuildContext context, MenuItem item, String userType) {
    final isClient = userType == 'C';
    final isAlwaysActive =
        item.title == "Cari Asuransi" || item.title == "Lapor Klaim" || item.title == "Bantuan";
    final isActive = isClient || isAlwaysActive;

    return GestureDetector(
      onTap: isActive ? () => handleMenuTap(context, item.title) : null,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: isActive ? 1.0 : 0.35,
        child: LayoutBuilder(
          builder: (context, c) {
            final titleStyle = bodyTextStyle(context).copyWith(
              height: 1.2,
              color: isActive ? primaryLightColor : hintGrey,
            );

            final fontSize = titleStyle.fontSize ?? 14;
            final lineHeight = fontSize * (titleStyle.height ?? 1.2);

            final desiredTitleHeight = (lineHeight * 2) + 6;

            const iconSize = 68.0;
            const topMargin = 15.0;
            const gapAfterIcon = 8.0;
            final bottomGap = hPadding.toDouble();

            final fixedHeights = iconSize + topMargin + gapAfterIcon + bottomGap;
            final remaining = (c.maxHeight - fixedHeights).clamp(0.0, double.infinity);
            final titleHeight = desiredTitleHeight.clamp(0.0, remaining);
            final bottomFill = (remaining - titleHeight).clamp(0.0, double.infinity);

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  margin: const EdgeInsets.only(top: 15),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: pGrey,
                          shape: BoxShape.circle,
                          border: Border.all(color: sGrey),
                        ),
                        child: Center(
                          child: SvgPicture.asset(item.iconPath, width: 38, height: 38),
                        ),
                      ),
                      if (item.isPopular)
                        Positioned(
                          top: -10,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(cardBorderRadius),
                              gradient: primaryBadgeGradient,
                            ),
                            child: Text(
                              'Populer!',
                              style: bodyTextStyle(context).copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                SizedBox(
                  height: titleHeight,
                  child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                  ),
                ),

                SizedBox(height: hPadding),

                SizedBox(height: bottomFill),
              ],
            );
          },
        ),
      ),
    );
  }

  double getItemWidth(BuildContext ctx) {
    if (isDesktop(ctx)) return 120;
    if (isTablet(ctx)) return 100;
    return 85;
  }

  List<MenuItem> _getMenuItems() {
    return [
      MenuItem(title: 'Cari Asuransi', iconPath: 'assets/icons/menu_cari_asuransi.svg', isPopular: true,),
      MenuItem(title: 'Lapor Klaim', iconPath: 'assets/icons/menu_lapor_klaim.svg',),
      MenuItem(title: 'Klaim', iconPath: 'assets/icons/menu_klaim.svg'),
      MenuItem(title: 'Polis', iconPath: 'assets/icons/menu_polis.svg'),
      MenuItem(title: 'Test Page', iconPath: 'assets/icons/menu_beli_polis.svg',),
      MenuItem(title: 'Tagihan Pembayaran', iconPath: 'assets/icons/menu_tagihan_pembayaran.svg',),
    ];
  }

  void handleMenuTap(BuildContext context, String title) async {

    final polisFormKey = GlobalKey<FormState>();
    switch (title) {
      case 'Cari Asuransi':
        Navigator.push(context, MaterialPageRoute(builder: (_) => CariAsuransiWidget2.page()));
        break;

      case 'Lapor Klaim':
        Navigator.push(context, MaterialPageRoute(builder: (_) => DaftarCobKlaimPage()));
        break;

      case 'Polis':
        Navigator.push(context, MaterialPageRoute(builder: (_) => ManagementPolisPage()));
        break;

      case 'Test Page':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ExampleNestedScrollableTablesPage(),
          ),
        );
        break;

      case 'Klaim':
        Navigator.push(context, MaterialPageRoute(builder: (_) => KlaimMainPage()));
        break;

      case 'Tagihan Pembayaran':
        Navigator.push(context, MaterialPageRoute(builder: (_) => TagihanPembayaranPage(initialTab: 0,)));
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          infoSnackBar('Fitur $title belum tersedia!'),
        );
    }
  }

}

class MenuItem {
  final String title;
  final String iconPath;
  final bool isPopular;

  MenuItem({
    required this.title,
    required this.iconPath,
    this.isPopular = false,
  });
}

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 🎨 Background pakai ShaderMask biar mirip StartScreen
          SizedBox.expand(
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.transparent],
                  stops: [0.0, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                "assets/images/background_gradient.png",
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // 🎊 Confetti efek
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            gravity: 0.3,
            emissionFrequency: 0.05,
            numberOfParticles: 25,
            colors: const [
              Colors.pinkAccent,
              Colors.orangeAccent,
              Colors.tealAccent,
              Colors.yellowAccent,
              Colors.blueAccent,
            ],
          ),

          // 💚 Konten utama
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Icon success
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2ECC71),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 60,
                    color: Colors.white,
                  )
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.easeOutBack)
                      .fadeIn(duration: 500.ms),
                ),

                const SizedBox(height: 30),

                Text(
                  "Perubahan berhasil disimpan!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 10),

                const Text(
                  "Tim internal akan meninjau dan mengonfirmasi status Anda.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 30),

                // 🔘 Tombol
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    side: const BorderSide(color: Colors.white30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // contoh back
                  },
                  child: const Text(
                    "Lihat Detail",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 900.ms)
                    .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}