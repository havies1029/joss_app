  import 'package:flutter/cupertino.dart';
  import 'package:flutter_svg/svg.dart';
  import '../../common/constants.dart';

  class EmptyStatePage extends StatelessWidget {
    final String iconPath;
    final String title;
    final String description;
    final double iconHeight;

    const EmptyStatePage({
      super.key,
      this.iconPath = 'assets/icons/empty_review_page.svg',
      this.title = 'Tidak ada data',
      this.description = 'Data belum tersedia saat ini',
      this.iconHeight = 50,
    });

    @override
    Widget build(BuildContext context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                height: iconHeight,
              ),

              const SizedBox(height: 20),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getResponsiveFont(context, 16),
                  color: primaryLightColor,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getResponsiveFont(context, 14),
                  color: hintGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }