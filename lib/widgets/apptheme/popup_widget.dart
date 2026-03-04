import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

enum ExportFormat { excel, pdf }

class PopupWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String button1Text;
  final String button2Text;
  final Color button1Color;
  final Color button2Color;
  final void Function(ExportFormat format)? onExportSelected;

  const PopupWidget({
    super.key,
    this.title = "Pilih format file untuk diunduh",
    this.subtitle = "Tersedia Excel dan PDF",
    this.button1Text = "Excel",
    this.button2Text = "PDF",
    this.button1Color = excelGreen,
    this.button2Color = pdfRed,
    this.onExportSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: vPadding),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Judul
            Text(
              "Pilih format file untuk diunduh",
              style: headingStyle(context, fontSize: 17.49),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),

            // Sub Judul
            Text(
              "Tersedia Excel dan PDF",
              style: bodyTextStyle(context, fontSize: 14.31).copyWith(color: hintGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: excelGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: () => onExportSelected?.call(ExportFormat.excel),
                    icon: SvgPicture.asset(
                      "assets/icons/excel.svg",
                      width: 16,
                      height: 16,
                    ),
                    label: Text(
                      "Excel",
                      style:  headingStyle(context, fontSize: 17.49),
                    ),
                  ),
                ),
                const SizedBox(width: hPadding),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pdfRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: () => onExportSelected?.call(ExportFormat.pdf),
                    icon: SvgPicture.asset(
                      "assets/icons/pdf.svg",
                      width: 16,
                      height: 16,
                    ),
                    label: Text(
                      "PDF",
                      style:  headingStyle(context, fontSize: 17.49),
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