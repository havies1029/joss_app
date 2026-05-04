import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/constants.dart';

class BaseBackgroundSidePage extends StatelessWidget {
  final Widget child;
  final double fadeHeight;
  final String backgroundAsset;
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onHome;
  final bool showBackButton;
  final bool showHomeButton;

  final List<BlocListener>? blocListeners;

  const BaseBackgroundSidePage({
    super.key,
    required this.child,
    required this.title,
    this.onBack,
    this.onHome,
    this.fadeHeight = 300,
    this.backgroundAsset = "assets/images/background_gradient.png",
    this.blocListeners,
    this.showBackButton = true,
    this.showHomeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget page = Scaffold(
      backgroundColor: secondaryBlackColor,
      bottomNavigationBar: Container(
        height: 46,
        width: double.infinity,
        color: secondaryBlackColor,
        alignment: Alignment.center,
        child: Text(
          "Claim Is Simple",
          style: headingStyle(
            context,
            fontSize: getResponsiveFont(context, 18),
          ).copyWith(fontStyle: FontStyle.italic),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              height: 56,
              color: secondaryBlackColor,
              padding: const EdgeInsets.symmetric(horizontal: hPadding * 2),
              child: Stack(
                children: [
                  if (showBackButton)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.25,
                        heightFactor: 1,
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: onBack ?? () => Navigator.pop(context),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SvgPicture.asset(
                              "assets/icons/arrow_back.svg",
                            ),
                          ),
                        ),
                      ),
                    ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 56),
                      child: Text(
                        title,
                        style: headingStyle(context, fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  if (showHomeButton)
                    Align(
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: 0.25,
                        heightFactor: 1,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: onHome ??
                                  () {
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SvgPicture.asset(
                              "assets/icons/home3.svg",
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // BODY + BACKGROUND
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) {
                  final double height = c.maxHeight * 0.45;

                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: fadeHeight > 0 ? fadeHeight : height,
                          width: double.infinity,
                          child: ShaderMask(
                            shaderCallback: (Rect rect) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  primaryLightColor,
                                  Colors.transparent,
                                ],
                                stops: [0.0, 1.0],
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.asset(
                              backgroundAsset,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),

                      child,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (blocListeners == null || blocListeners!.isEmpty) {
      return page;
    }

    return MultiBlocListener(
      listeners: blocListeners!,
      child: page,
    );
  }
}