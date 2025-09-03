import 'package:flutter/cupertino.dart';

import '../../common/constants.dart';

class WelcomeHeaderLogin extends StatelessWidget {
  const WelcomeHeaderLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Selamat Datang Kembali!",
                style: TextStyle(
                  fontSize: isDesktop(context)
                      ? 28
                      : isTablet(context)
                      ? 24
                      : 30,  // responsif
                  fontWeight: FontWeight.w700,
                  color: primaryLightColor,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "👋",
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Subtitle
          Text(
            "Yuk masuk, semua polis & klaimmu siap diakses.",
            style: TextStyle(
              fontSize: isDesktop(context)
                  ? 18
                  : isTablet(context)
                  ? 16
                  : 18,
              fontWeight: FontWeight.w400,
              color: hintGrey,
            ),
          ),
        ],
      ),
    );
  }
}
