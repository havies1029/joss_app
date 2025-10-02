import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

/// Format yang didukung
enum ExportFormat { excel, pdf }

class PopupWidget extends StatelessWidget {
  final String title;             // Baris pertama (fontSize 18)
  final String subtitle;          // Baris kedua (fontSize 16)
  final String button1Text;       // Tulisan tombol kiri
  final String button2Text;       // Tulisan tombol kanan
  final Color button1Color;       // Warna tombol kiri
  final Color button2Color;       // Warna tombol kanan
  final void Function(ExportFormat format)? onExportSelected;

  const PopupWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.button1Text,
    required this.button2Text,
    this.button1Color = Colors.green,
    this.button2Color = Colors.red,
    this.onExportSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
              title,
              style: headingStyle(context, fontSize: getResponsiveFont(context, 18)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6.0),

            // Sub Judul
            Text(
              subtitle,
              style: bodyTextStyle(context).copyWith(fontSize: getResponsiveFont(context, 16)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: vPadding),

            // Tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: button1Color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    // ✅ klik tombol 1 = Excel
                    onPressed: () => onExportSelected?.call(ExportFormat.excel),
                    icon: const Icon(Icons.table_chart, color: Colors.white),
                    label: Text(
                      button1Text,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: hPadding),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: button2Color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    // ✅ klik tombol 2 = PDF
                    onPressed: () => onExportSelected?.call(ExportFormat.pdf),
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: Text(
                      button2Text,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
