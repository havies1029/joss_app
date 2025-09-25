import 'package:joss_app/widgets/section/polis/real_polis/sppa_mv/sppa_form/sppamvcrud_form.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_mv/simul_form/simul_casco.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_mv/simul_form/simul_opsi.dart';
import 'package:joss_app/widgets/section/polis/simul_polis/simul_mv/simul_form/simul_premi.dart';
import 'package:flutter/material.dart';// asumsi responsive helper dipisah
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../pages/simulmv/simulmvcrud_form_casco.dart';
import '../../../../../pages/simulmv/simulmvcrud_form_opsi.dart';
import '../../../../../pages/simulmv/simulmvcrud_form_premi.dart';

class SppaMvPage extends StatefulWidget {
  const SppaMvPage({super.key});

  @override
  State<SppaMvPage> createState() => _SppaMvPageState();
}

class _SppaMvPageState extends State<SppaMvPage> {
  final _formKey = GlobalKey<FormState>();
  bool _showPremiSection = false;
  static const _fontFamily = 'Satoshi-Regular';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = ResponsiveHelper(constraints);

        return Container(
          color: Colors.white, // ✅ tetap putih tanpa Scaffold
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(), // ✅ biar gak konflik dengan ScrollView utama
            child: Center(
              child: Container(
                width: responsive.maxWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: responsive.sectionSpacing),
                      _buildHeader(responsive),
                      _buildProgressBar(responsive),
                      SizedBox(height: responsive.sectionSpacing),

                      // 🔷 Form CASCO
                      _buildSectionHeader('Data Kendaraan', responsive),
                      SppamvFormPage(viewMode: "tambah", recordId: ""),
                      SizedBox(height: responsive.sectionSpacing),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ResponsiveHelper responsive) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18), // ✅ semua sisi

      child: Container(
        width: double.infinity,
        height: responsive.headerHeight,
        color: const Color(0xFF91C050),
        child: Stack(
          children: [
            // SVG di kanan bawah
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/images/frame_polis.svg',
                width: responsive.headerIconSize,
                height: responsive.headerIconSize,
                fit: BoxFit.contain,
              ),
            ),
            // Teks Header
            Padding(
              padding: EdgeInsets.only(
                left: responsive.horizontalPadding,
                top: responsive.headerTextTop,
                right: responsive.horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beli Polis',
                    style: TextStyle(
                      fontSize: responsive.headerTitleSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: _fontFamily,
                    ),
                  ),
                  SizedBox(height: responsive.headerSubtitleSpacing),
                  Text(
                    'Sebelum lanjut, pastikan data kamu sudah lengkap, ya!',
                    style: TextStyle(
                      fontSize: responsive.headerSubtitleSize,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: _fontFamily,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.progressBarVerticalMargin),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _showPremiSection ? 1.0 : 0.33,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF8BC34A),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.progressBarTextSpacing),
          Padding(
            padding: EdgeInsets.only(right: responsive.horizontalPadding),
            child: Text(
              _showPremiSection ? '100%' : '33%',
              style: TextStyle(
                fontSize: responsive.progressBarTextSize,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.horizontalPadding,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: responsive.sectionHeaderSize + 4,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF8BC34A),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: responsive.sectionHeaderSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ResponsiveHelper responsive) {
    return Container(
      margin: EdgeInsets.only(top: responsive.buttonTopMargin),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _showPremiSection = !_showPremiSection;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.buttonIconSpacing * 2,
              vertical: 12,
            ),
            backgroundColor: const Color(0xFF8BC34A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(responsive.buttonBorderRadius),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _showPremiSection ? Icons.shopping_cart : Icons.calculate_outlined,
                size: responsive.buttonIconSize,
              ),
              SizedBox(width: responsive.buttonIconSpacing),
              Text(
                _showPremiSection ? '🛒 Beli Polis' : '📊 Hitung Premi Sekarang',
                style: TextStyle(
                  fontSize: responsive.buttonTextSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ResponsiveHelper {
  final BoxConstraints constraints;

  ResponsiveHelper(this.constraints);

  bool get isMobile => constraints.maxWidth < 768;
  bool get isTablet => constraints.maxWidth >= 768 && constraints.maxWidth < 992;
  bool get isDesktop => constraints.maxWidth >= 992;

  double get horizontalPadding => constraints.maxWidth > 1200
      ? 48
      : isTablet
      ? 36
      : 24;

  double get maxWidth => constraints.maxWidth > 1200
      ? 1200
      : isTablet
      ? constraints.maxWidth * 0.95
      : constraints.maxWidth * 0.9;

  // Header
  double get headerHeight => isMobile ? 130 : isTablet ? 150 : 160;
  double get headerTitleSize => isMobile ? 24 : isTablet ? 28 : 32;
  double get headerSubtitleSize => isMobile ? 13 : isTablet ? 14 : 15;
  double get headerTextTop => isMobile ? 36 : 45;
  double get headerSubtitleSpacing => isMobile ? 6 : 8;
  double get headerIconSize => isMobile ? 90 : 110;
  double get headerIconRight => isMobile ? 20 : isTablet ? 30 : 40;
  double get headerIconTop => isMobile ? 20 : isTablet ? 25 : 30;

  // Progress Bar
  double get progressBarVerticalMargin => isMobile ? 16 : 20;
  double get progressBarTextSpacing => 12;
  double get progressBarTextSize => isMobile ? 12 : 13;

  // Sections
  double get sectionHeaderSize => isMobile ? 16 : isTablet ? 17 : 18;
  double get sectionHeaderSpacing => isMobile ? 16 : 18;
  double get sectionSpacing => isMobile ? 24 : isTablet ? 28 : 32;

  // Fields
  double get labelSize => isMobile ? 14 : 15;
  double get labelSpacing => 8;
  double get fieldTextSize => isMobile ? 14 : 15;
  double get fieldBorderRadius => 8;
  double get fieldHorizontalPadding => isMobile ? 12 : 14;
  double get fieldVerticalPadding => isMobile ? 12 : 14;
  double get fieldSpacing => isMobile ? 16 : 18;
  double get rowSpacing => isMobile ? 12 : isTablet ? 16 : 20;

  // Currency
  double get currencyLabelSize => isMobile ? 13 : 14;
  double get currencyLabelPadding => isMobile ? 12 : 14;

  // Checkbox
  double get checkboxScale => isMobile ? 0.9 : 1.0;
  double get checkboxTextSize => isMobile ? 12 : 13;
  double get checkboxSpacing => isMobile ? 8 : 12;

  // Button
  double get buttonHeight => isMobile ? 48 : isTablet ? 52 : 56;
  double get buttonTextSize => isMobile ? 15 : 16;
  double get buttonIconSize => isMobile ? 20 : 22;
  double get buttonIconSpacing => 8;
  double get buttonBorderRadius => 50;
  double get buttonTopMargin => isMobile ? 24 : 32;

  // Layout
  double get bottomPadding => isMobile ? 32 : 40;
}

// Custom Painter untuk frame SVG pattern
class FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Draw geometric frame pattern
    final path = Path();

    // Main outer frame
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 8, size.width - 16, size.height - 16),
      const Radius.circular(12),
    ));

    // Inner decorative squares
    final squareSize = size.width * 0.15;
    final padding = size.width * 0.15;

    // Top left square
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(padding, padding, squareSize, squareSize),
      const Radius.circular(4),
    ));

    // Top right square
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width - padding - squareSize, padding, squareSize, squareSize),
      const Radius.circular(4),
    ));

    // Bottom left square
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(padding, size.height - padding - squareSize, squareSize, squareSize),
      const Radius.circular(4),
    ));

    // Bottom right square
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width - padding - squareSize, size.height - padding - squareSize, squareSize, squareSize),
      const Radius.circular(4),
    ));

    // Center diamond
// Center diamond
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final diamondSize = squareSize * 0.8;

    path.moveTo(centerX, centerY - diamondSize / 2);
    path.lineTo(centerX + diamondSize / 2, centerY);
    path.lineTo(centerX, centerY + diamondSize / 2);
    path.lineTo(centerX - diamondSize / 2, centerY);
    path.close();

    // Connecting lines
    final lineLength = squareSize * 0.6;

    // Horizontal line through center
    path.moveTo(centerX - lineLength, centerY);
    path.lineTo(centerX + lineLength, centerY);

    // Vertical line through center
    path.moveTo(centerX, centerY - lineLength);
    path.lineTo(centerX, centerY + lineLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Thousands separator formatter
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ',';

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue,) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all separators
    String newText = newValue.text.replaceAll(separator, '');

    // Add separators
    final buffer = StringBuffer();
    final length = newText.length;
    for (int i = 0; i < length; i++) {
      buffer.write(newText[i]);
      final remainingDigits = length - i - 1;
      if (remainingDigits > 0 && remainingDigits % 3 == 0) {
        buffer.write(separator);
      }
    }

    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}