import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class InviteSuccessPopup extends StatelessWidget {
  const InviteSuccessPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ✅ klik area luar popup => tutup popup
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.6),
        body: Center(
          child: GestureDetector(
            // biar klik di dalam popup nggak nutup popup
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: vPadding),
              padding: const EdgeInsets.all(hPadding + 4),
              decoration: BoxDecoration(
                color: secondaryBlackColor,
                borderRadius: BorderRadius.circular(cardBorderRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Judul
                  Text(
                    "Undangan Telah Terkirim",
                    textAlign: TextAlign.center,
                    style: headingStyle(context, fontSize: getResponsiveFont(context, 18)),
                  ),
                  const SizedBox(height: 6),

                  // Subjudul
                  Text(
                    "PIC telah berhasil dikirimi undangan melalui email.",
                    textAlign: TextAlign.center,
                    style: bodyTextStyle(context).copyWith(
                      fontSize: getResponsiveFont(context, 16),
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: vPadding),

                  // Tombol Aksi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(cardBorderRadius),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                      label: Text(
                        "Kembali",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: getResponsiveFont(context, 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
