import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../common/thousand_separator_input_formatter.dart';

class PolisMVPage extends StatefulWidget {
  const PolisMVPage({super.key});

  @override
  PolisMVPageState createState() => PolisMVPageState();
}

class PolisMVPageState extends State<PolisMVPage> {
  static const _fontFamily = 'Satoshi-Regular';
  final _formKey = GlobalKey<FormState>();
  bool _showPremiSection = false;

  // Controllers untuk Data Kendaraan
  String? selectedJenisKendaraan;
  String? selectedTahunPembuatan;
  String? selectedJenisCover;
  final TextEditingController _hargaKendaraanController = TextEditingController();

  // Controllers untuk Perlindungan Tambahan
  bool _isEqSelected = false;
  bool _isFloodSelected = false;
  bool _isSrccSelected = false;
  bool _isTerrorismSelected = false;

  final TextEditingController _passengerLiabilityController = TextEditingController();
  final TextEditingController _paDriverController = TextEditingController();
  final TextEditingController _tplController = TextEditingController();
  final TextEditingController _tplRightController = TextEditingController();
  final TextEditingController _authorizedWorkshopController = TextEditingController();

  // Controllers untuk Premi (akan muncul setelah hitung premi)
  final TextEditingController _premiCascoLeftController = TextEditingController();
  final TextEditingController _premiCascoRightController = TextEditingController();
  final TextEditingController _premiTotalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsive = ResponsiveHelper(constraints);

        return Container(
          width: double.infinity,
          color: Colors.white, // ✅ Full putih
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: SizedBox(
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
                          _buildDataKendaraanSection(responsive),
                          SizedBox(height: responsive.sectionSpacing),
                          _buildPerlindunganTambahanSection(responsive),
                          SizedBox(height: responsive.sectionSpacing),
                          if (_showPremiSection) ...[
                            _buildPremiSection(responsive),
                            SizedBox(height: responsive.sectionSpacing),
                          ],
                          _buildActionButton(responsive),
                          SizedBox(height: responsive.bottomPadding),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
                widthFactor: 0.1, // <-- nanti bisa dinamis
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
              '0%',
              style: TextStyle(
                fontSize: responsive.progressBarTextSize,
                color: Colors.grey[600],
                fontFamily: _fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDataKendaraanSection(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Data Kendaraan', responsive),
        SizedBox(height: responsive.sectionHeaderSpacing),

        // Row 1: Jenis Kendaraan & Tahun Pembuatan
        responsive.isMobile
            ? Column(
          children: [
            _buildDropdownField(
              'Jenis Kendaraan',
              '-- Pilih Jenis Kendaraan --',
              selectedJenisKendaraan,
              ['Mobil', 'Motor', 'Truk', 'Bus'],
                  (value) => setState(() => selectedJenisKendaraan = value),
              responsive,
            ),
            SizedBox(height: responsive.fieldSpacing),
            _buildDropdownField(
              'Tahun Pembuatan',
              '-- Pilih Tahun Pembuatan --',
              selectedTahunPembuatan,
              List.generate(25, (index) => (2024 - index).toString()),
                  (value) => setState(() => selectedTahunPembuatan = value),
              responsive,
            ),
          ],
        )
            : Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                'Jenis Kendaraan',
                '-- Pilih Jenis Kendaraan --',
                selectedJenisKendaraan,
                ['Mobil', 'Motor', 'Truk', 'Bus'],
                    (value) => setState(() => selectedJenisKendaraan = value),
                responsive,
              ),
            ),
            SizedBox(width: responsive.rowSpacing),
            Expanded(
              child: _buildDropdownField(
                'Tahun Pembuatan',
                '-- Pilih Tahun Pembuatan --',
                selectedTahunPembuatan,
                List.generate(25, (index) => (2024 - index).toString()),
                    (value) => setState(() => selectedTahunPembuatan = value),
                responsive,
              ),
            ),
          ],
        ),

        SizedBox(height: responsive.fieldSpacing),

        // Row 2: Jenis Cover & Harga Kendaraan
        responsive.isMobile
            ? Column(
          children: [
            _buildDropdownField(
              'Jenis Cover',
              '-- Pilih Jenis Cover --',
              selectedJenisCover,
              ['Comprehensive', 'Total Loss Only', 'Third Party'],
                  (value) => setState(() => selectedJenisCover = value),
              responsive,
            ),
            SizedBox(height: responsive.fieldSpacing),
            _buildCurrencyField('Harga Kendaraan', _hargaKendaraanController, responsive),
          ],
        )
            : Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                'Jenis Cover',
                '-- Pilih Jenis Cover --',
                selectedJenisCover,
                ['Comprehensive', 'Total Loss Only', 'Third Party'],
                    (value) => setState(() => selectedJenisCover = value),
                responsive,
              ),
            ),
            SizedBox(width: responsive.rowSpacing),
            Expanded(
              child: _buildCurrencyField('Harga Kendaraan', _hargaKendaraanController, responsive),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerlindunganTambahanSection(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Perlindungan Tambahan', responsive),
        SizedBox(height: responsive.sectionHeaderSpacing),

        // Checkboxes
        responsive.isMobile
            ? Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildCheckbox('EQ (Gempa)', _isEqSelected, (value) => setState(() => _isEqSelected = value!), responsive)),
                Expanded(child: _buildCheckbox('Flood (Banjir)', _isFloodSelected, (value) => setState(() => _isFloodSelected = value!), responsive)),
              ],
            ),
            SizedBox(height: responsive.checkboxSpacing),
            Row(
              children: [
                Expanded(child: _buildCheckbox('SRCC (Kerusuhan)', _isSrccSelected, (value) => setState(() => _isSrccSelected = value!), responsive)),
                Expanded(child: _buildCheckbox('Terrorism', _isTerrorismSelected, (value) => setState(() => _isTerrorismSelected = value!), responsive)),
              ],
            ),
          ],
        )
            : Row(
          children: [
            Expanded(child: _buildCheckbox('EQ (Gempa)', _isEqSelected, (value) => setState(() => _isEqSelected = value!), responsive)),
            Expanded(child: _buildCheckbox('Flood (Banjir)', _isFloodSelected, (value) => setState(() => _isFloodSelected = value!), responsive)),
            Expanded(child: _buildCheckbox('SRCC (Kerusuhan)', _isSrccSelected, (value) => setState(() => _isSrccSelected = value!), responsive)),
            Expanded(child: _buildCheckbox('Terrorism', _isTerrorismSelected, (value) => setState(() => _isTerrorismSelected = value!), responsive)),
          ],
        ),

        SizedBox(height: responsive.fieldSpacing),

        // Row 1: Passenger Liability & PA Driver
        responsive.isMobile
            ? Column(
          children: [
            _buildCurrencyField('Passenger Liability', _passengerLiabilityController, responsive),
            SizedBox(height: responsive.fieldSpacing),
            _buildCurrencyField('PA Driver', _paDriverController, responsive),
          ],
        )
            : Row(
          children: [
            Expanded(child: _buildCurrencyField('Passenger Liability', _passengerLiabilityController, responsive)),
            SizedBox(width: responsive.rowSpacing),
            Expanded(child: _buildCurrencyField('PA Driver', _paDriverController, responsive)),
          ],
        ),

        SizedBox(height: responsive.fieldSpacing),

        // Row 2: TPL fields
        responsive.isMobile
            ? Column(
          children: [
            _buildCurrencyField('TPL', _tplController, responsive),
            SizedBox(height: responsive.fieldSpacing),
            _buildCurrencyField('TPL', _tplRightController, responsive),
          ],
        )
            : Row(
          children: [
            Expanded(child: _buildCurrencyField('TPL', _tplController, responsive)),
            SizedBox(width: responsive.rowSpacing),
            Expanded(child: _buildCurrencyField('TPL', _tplRightController, responsive)),
          ],
        ),

        SizedBox(height: responsive.fieldSpacing),

        _buildPercentageField('Authorized Workshop', _authorizedWorkshopController, responsive),
      ],
    );
  }

  Widget _buildPremiSection(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Premi', responsive),
        SizedBox(height: responsive.sectionHeaderSpacing),

        responsive.isMobile
            ? Column(
          children: [
            _buildCurrencyField('Premi Casco', _premiCascoLeftController, responsive),
            SizedBox(height: responsive.fieldSpacing),
            _buildCurrencyField('Premi Casco', _premiCascoRightController, responsive),
          ],
        )
            : Row(
          children: [
            Expanded(child: _buildCurrencyField('Premi Casco', _premiCascoLeftController, responsive)),
            SizedBox(width: responsive.rowSpacing),
            Expanded(child: _buildCurrencyField('Premi Casco', _premiCascoRightController, responsive)),
          ],
        ),

        SizedBox(height: responsive.fieldSpacing),

        _buildCurrencyField('Premi Total', _premiTotalController, responsive),
      ],
    );
  }

  Widget _buildActionButton(ResponsiveHelper responsive) {
    return Container(
      margin: EdgeInsets.only(top: responsive.buttonTopMargin),
      child: Center(
        child: ElevatedButton(
          onPressed: _showPremiSection ? _beliPolis : _hitungPremi,
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
            elevation: 2,
            shadowColor: const Color(0xFF8BC34A).withOpacity(0.3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // 👈 INI YANG PENTING BIAR SEPANJANG ISI
            children: [
              Icon(
                _showPremiSection ? Icons.shopping_cart_outlined : Icons.calculate_outlined,
                size: responsive.buttonIconSize,
              ),
              SizedBox(width: responsive.buttonIconSpacing),
              Text(
                _showPremiSection ? '🛒 Beli Polis' : '📊 Hitung Premi Sekarang',
                style: TextStyle(
                  fontSize: responsive.buttonTextSize,
                  fontWeight: FontWeight.w600,
                  fontFamily: _fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSectionHeader(String title, ResponsiveHelper responsive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Garis vertikal hijau di kiri
        Container(
          width: 4,
          height: responsive.sectionHeaderSize + 4,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF8BC34A),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Judul section
        Text(
          title,
          style: TextStyle(
            fontSize: responsive.sectionHeaderSize,
            fontWeight: FontWeight.w600,
            color: Colors.black87, // Ubah dari hijau ke hitam agar garis lebih kontras
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String hint, String? value, List<String> items, Function(String?) onChanged, ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: responsive.labelSize,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontFamily: _fontFamily,
          ),
        ),
        SizedBox(height: responsive.labelSpacing),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(responsive.fieldBorderRadius),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            // initialValue: value,
            hint: Text(
              hint,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: responsive.fieldTextSize,
                fontFamily: _fontFamily,
              ),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: responsive.fieldHorizontalPadding,
                vertical: responsive.fieldVerticalPadding,
              ),
            ),
            style: TextStyle(
              fontSize: responsive.fieldTextSize,
              color: Colors.black87,
              fontFamily: _fontFamily,
            ),
            items: items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyField(String label, TextEditingController controller, ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: responsive.labelSize,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontFamily: _fontFamily,
          ),
        ),
        SizedBox(height: responsive.labelSpacing),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(responsive.fieldBorderRadius),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.currencyLabelPadding,
                  vertical: responsive.fieldVerticalPadding,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BC34A).withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(responsive.fieldBorderRadius),
                    bottomLeft: Radius.circular(responsive.fieldBorderRadius),
                  ),
                ),
                child: Text(
                  'IDR',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8BC34A),
                    fontSize: responsive.currencyLabelSize,
                    fontFamily: _fontFamily,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    ThousandsSeparatorInputFormatter(),
                  ],
                  style: TextStyle(
                    fontSize: responsive.fieldTextSize,
                    fontFamily: _fontFamily,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsive.fieldHorizontalPadding,
                      vertical: responsive.fieldVerticalPadding,
                    ),
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: _fontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPercentageField(String label, TextEditingController controller, ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: responsive.labelSize,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontFamily: _fontFamily,
          ),
        ),
        SizedBox(height: responsive.labelSpacing),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(responsive.fieldBorderRadius),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: responsive.fieldTextSize,
                    fontFamily: _fontFamily,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsive.fieldHorizontalPadding,
                      vertical: responsive.fieldVerticalPadding,
                    ),
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: _fontFamily,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.currencyLabelPadding,
                  vertical: responsive.fieldVerticalPadding,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BC34A).withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(responsive.fieldBorderRadius),
                    bottomRight: Radius.circular(responsive.fieldBorderRadius),
                  ),
                ),
                child: Text(
                  '%',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8BC34A),
                    fontSize: responsive.currencyLabelSize,
                    fontFamily: _fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged, ResponsiveHelper responsive) {
    return Row(
      children: [
        Transform.scale(
          scale: responsive.checkboxScale,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF8BC34A),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: responsive.checkboxTextSize,
              fontFamily: _fontFamily,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  void _hitungPremi() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _showPremiSection = true;
        // Simulate calculation
        _premiCascoLeftController.text = '1,500,000';
        _premiCascoRightController.text = '1,200,000';
        _premiTotalController.text = '2,700,000';
      });

      // Scroll to show premi section
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _beliPolis() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Proses pembelian polis dimulai...',
          style: TextStyle(fontFamily: _fontFamily),
        ),
        backgroundColor: const Color(0xFF8BC34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// Responsive Helper Class
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