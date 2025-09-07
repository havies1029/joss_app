import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/constants.dart';

class WelcomeHeaderRegister extends StatelessWidget {
  const WelcomeHeaderRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(6),
            splashColor: Colors.orange.withOpacity(0.1),
            highlightColor: Colors.orange.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      "Kembali",
                      style: TextStyle(
                        fontSize: getResponsiveFont(context, 18),
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 4),
          // Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Baru di JPS?",
                style: TextStyle(
                  fontSize: isDesktop(context)
                      ? 28
                      : isTablet(context)
                      ? 24
                      : 30,
                  fontWeight: FontWeight.w700,
                  color: primaryLightColor,
                ),
              ),
              const SizedBox(width: 6),
              const Text("🎉", style: TextStyle(fontSize: 22)),
            ],
          ),

          const SizedBox(height: 4),

          // Subtitle
          Text(
            "Yuk, buat akun dan mulai proteksi hidupmu.",
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
