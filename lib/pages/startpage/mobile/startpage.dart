import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/size_config.dart';

import '../../../common/constants.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

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
      subtitle: 'Dapatkan pendampingan langsung dari broker berlisensi dan terpercaya.',
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

  void _onGetStarted() {
    // Navigate to main app or login screen
    // Navigator.pushReplacementNamed(context, '/login');
    Navigator.of(context).pop(); // Temporary for demo
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor,
              primaryBlackColor,
            ],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              _buildSkipButton(),

              // Page Indicator
              _buildPageIndicator(),

              // Content
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

              // Bottom Button
              _buildBottomButton(),

              SizedBox(height: getProportionateScreenHeight(40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: EdgeInsets.only(
        top: getProportionateScreenHeight(20),
        right: getProportionateScreenWidth(hPadding),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: _skipToEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(16),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(5)),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: getProportionateScreenWidth(14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _onboardingData.length,
              (index) => AnimatedContainer(
            duration: defaultDuration,
            margin: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(4),
            ),
            height: getProportionateScreenHeight(8),
            width: _currentIndex == index
                ? getProportionateScreenWidth(40)
                : getProportionateScreenWidth(8),
            decoration: BoxDecoration(
              color: _currentIndex == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(24),
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
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
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: getProportionateScreenWidth(16),
                      height: 1.4,
                    ),
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
        horizontal: getProportionateScreenWidth(hPaddingForCard),
        vertical: getProportionateScreenHeight(10),
      ),
      child: AnimatedSwitcher(
        duration: defaultDuration,
        child: SizedBox(
          key: ValueKey(isLastPage),
          width: double.infinity,
          height: getProportionateScreenHeight(buttonHeight),
          child: ElevatedButton(
            onPressed: isLastPage ? _onGetStarted : _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: defaultElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  getProportionateScreenWidth(cardBorderRadius),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastPage ? 'Selesai' : 'Selanjutnya',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!isLastPage) ...[
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: getProportionateScreenWidth(14),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomIndicator() {
    return Container(
      width: getProportionateScreenWidth(134),
      height: getProportionateScreenHeight(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2.5),
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