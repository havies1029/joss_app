import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants.dart';

class StartScreen extends StatefulWidget {
  final VoidCallback? onCompleted;
  const StartScreen({super.key, this.onCompleted});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      image: 'assets/images/start-1.svg',
      title: 'Semua Proteksi, Satu Aplikasi',
      subtitle: 'Kelola polis & premi lebih simpel, kapan pun, di\n mana pun.',
    ),
    OnboardingData(
      image: 'assets/images/start-2.svg',
      title: 'Klaim Tanpa Ribet',
      subtitle: 'Ajukan klaim lebih cepat, transparan, dan praktis.',
    ),
    OnboardingData(
      image: 'assets/images/start-3.svg',
      title: 'Didampingi Broker Terpercaya',
      subtitle:
      'Dapatkan pendampingan langsung dari broker berlisensi dan terpercaya.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: defaultDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      _onboardingData.length - 1,
      duration: defaultDuration,
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    // Panggil callback untuk notify main.dart
    if (widget.onCompleted != null) {
      widget.onCompleted!();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(hPadding),
              vertical: getProportionateScreenHeight(10),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildPageIndicator(),
                  ),
                ),
                const SizedBox(width: 18),
                _buildSkipButton(),
              ],
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background dengan fade
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

          // Konten onboarding
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return _buildOnboardingPage(_onboardingData[index]);
                    },
                  ),
                ),
                _buildBottomButton(),
                SizedBox(height: getProportionateScreenHeight(40)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkipButton() {
    bool isLastPage = _currentIndex == _onboardingData.length - 1;

    return AnimatedSwitcher(
      duration: 300.ms,
      child: isLastPage
          ? const SizedBox.shrink()
          : Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: _skipToEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Skip', style: headingStyle(context, fontSize: 20)),
              SizedBox(width: getProportionateScreenWidth(5)),
              Icon(
                Icons.arrow_forward_ios,
                size: getProportionateScreenWidth(14),
                color: primaryLightColor,
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      children: List.generate(
        _onboardingData.length,
            (index) => Expanded(
          child:
          AnimatedContainer(
            duration: defaultDuration,
            margin: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(5),
            ),
            height: getProportionateScreenHeight(8),
            decoration: BoxDecoration(
              color:
              _currentIndex == index
                  ? primaryColor
                  : primaryLightColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
          ).animate().fadeIn(duration: 300.ms).slideX(),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(hPadding),
      ),
      child: Column(
        children: [
          // Illustration
          Expanded(
            flex: 3,
            child: Center(
              child: SvgPicture.asset(
                data.image,
                height: getProportionateScreenHeight(250),
                fit: BoxFit.contain,
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),
            ),
          ),

          // Content
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Title
                Text(
                  data.title,
                  style: headingStyle(context),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms)
                    .slideY(begin: 0.3),

                SizedBox(height: getProportionateScreenHeight(10)),

                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  child: Text(
                    data.subtitle,
                    style: headingStyle(
                      context,
                      fontSize: 20,
                    ).copyWith(color: hintGrey),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 500.ms)
                      .slideY(begin: 0.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    bool isLastPage = _currentIndex == _onboardingData.length - 1;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(hPadding * 1.5),
        vertical: getProportionateScreenHeight(10),
      ),
      child: AnimatedSwitcher(
        duration: defaultDuration,
        child:
        isLastPage
            ? AppButton.primary(text: 'Selesai', onPressed: _onGetStarted)
            : AppButton.iconRight(
          text: 'Selanjutnya',
          icon: Icon(
            Icons.arrow_forward_ios,
            size: getProportionateScreenWidth(14),
            color: Colors.white,
          ),
          onPressed: _nextPage,
        ),
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String subtitle;

  OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}