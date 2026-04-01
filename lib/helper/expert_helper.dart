import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:file_saver/file_saver.dart';

enum CategoryType {
  ringkasan,
  properti,
  kendaraan,
  kesehatan,
  marineKargo,
  Angkutan,
  hull,
  sdm,
  lain_lain,
  rincian,
  klaimrasio,
  klaim,
  klaimrincian,
}

class ExportHelper {
  static String _getReportGroupTitle(CategoryType category) {
    switch (category) {
      case CategoryType.ringkasan:
      case CategoryType.properti:
      case CategoryType.kendaraan:
      case CategoryType.kesehatan:
      case CategoryType.marineKargo:
      case CategoryType.Angkutan:
      case CategoryType.hull:
      case CategoryType.sdm:
      case CategoryType.lain_lain:
        return 'polis';

      case CategoryType.rincian:
      case CategoryType.klaimrasio:
      case CategoryType.klaim:
      case CategoryType.klaimrincian:
        return 'klaim';
    }
  }

  static Future<void> export(String format, List<Map<String, dynamic>> data, CategoryType category) async {
    final categoryName = category.name;
    switch (format.toLowerCase()) {
      case 'excel':
        await _exportToExcel(data, categoryName);
        break;
      case 'pdf':
        await _exportToPdf(data, category);
        break;
    }
  }

  static Future<bool> _ensurePermission() async {
    if (kIsWeb) return true;
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<void> _exportToExcel(List<Map<String, dynamic>> data, String categoryName) async {
    if (data.isEmpty || !(await _ensurePermission())) return;

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    final headers = data.first.keys.toList();
    sheet.appendRow(headers);
    for (final row in data) {
      sheet.appendRow(headers.map((h) => row[h]?.toString() ?? '').toList());
    }

    final fileBytes = excel.encode()!;
    final filename = 'Data_${categoryName}_${DateTime.now().millisecondsSinceEpoch}.xlsx';

    if (kIsWeb) {
      await FileSaver.instance.saveFile(
        name: filename,
        bytes: Uint8List.fromList(fileBytes),
        ext: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );
    } else {
      final filePath = await _getDownloadPath(filename);
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);
      await OpenFilex.open(file.path);
    }
  }

  static Future<void> _exportToPdf(
      List<Map<String, dynamic>> data,
      CategoryType category,
      ) async {
    if (data.isEmpty || !(await _ensurePermission())) return;

    final pdf = pw.Document();
    final headers = data.first.keys.toList();
    final now = DateTime.now();
    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    final reportGroup = _getReportGroupTitle(category);

    final borderColor = PdfColor.fromHex('#d1d5db');
    final headerBg = PdfColor.fromHex('#1e3a8a');
    final evenRowBg = PdfColor.fromHex('#f8fafc');
    final textColor = PdfColor.fromHex('#111827');
    final subTextColor = PdfColor.fromHex('#4b5563');

    final logoImage = pw.MemoryImage(
      File('assets/images/logo.png').readAsBytesSync(),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          // HEADER ATAS
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 16),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Laporan data $reportGroup',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'Tanggal dibuat : $formattedDate',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: subTextColor,
                      ),
                    ),
                  ],
                ),
                pw.Container(
                  height: 42,
                  width: 42,
                  child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 16),

          // TABEL
          pw.Table(
            border: pw.TableBorder(
              horizontalInside: pw.BorderSide(color: borderColor, width: 0.5),
              verticalInside: pw.BorderSide(color: borderColor, width: 0.5),
              left: pw.BorderSide(color: borderColor, width: 1),
              right: pw.BorderSide(color: borderColor, width: 1),
              top: pw.BorderSide(color: borderColor, width: 1),
              bottom: pw.BorderSide(color: borderColor, width: 1),
            ),
            columnWidths: _getColumnWidths(headers),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: headerBg),
                children: headers.map((header) {
                  return pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: pw.Text(
                      _formatHeaderName(header),
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  );
                }).toList(),
              ),
              ...data.asMap().entries.map((entry) {
                final index = entry.key;
                final row = entry.value;
                final isEven = index % 2 == 0;

                return pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: isEven ? evenRowBg : PdfColors.white,
                  ),
                  children: headers.map((header) {
                    return pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: pw.Text(
                        row[header]?.toString() ?? '-',
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: textColor,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ],
        footer: (context) => pw.Container(
          margin: const pw.EdgeInsets.only(top: 16),
          padding: const pw.EdgeInsets.only(top: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                'Halaman ${context.pageNumber} dari ${context.pagesCount}',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColor.fromHex('#6b7280'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final pdfBytes = await pdf.save();
    final filename = 'Data_${category.name}_${DateTime.now().millisecondsSinceEpoch}.pdf';

    if (kIsWeb) {
      await FileSaver.instance.saveFile(
        name: filename,
        bytes: Uint8List.fromList(pdfBytes),
        ext: 'pdf',
        mimeType: MimeType.pdf,
      );
    } else {
      final filePath = await _getDownloadPath(filename);
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);
      await OpenFilex.open(file.path);
    }
  }

  // Helper untuk format nama kategori
  static String _formatCategoryName(String name) {
    final Map<String, String> categoryLabels = {
      'ringkasan': 'Ringkasan',
      'properti': 'Properti',
      'kendaraan': 'Kendaraan',
      'kesehatan': 'Kesehatan',
      'marineKargo': 'Marine & Kargo',
      'sdm': 'Sumber Daya Manusia',
      'lain_lain': 'Lain-lain',
      'rincian': 'Rincian',
      'klaimrasio': 'Rasio Klaim',
    };
    return categoryLabels[name] ?? name;
  }

  // Helper untuk format nama header
  static String _formatHeaderName(String header) {
    return header
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  // Helper untuk dynamic column widths
  static Map<int, pw.TableColumnWidth> _getColumnWidths(List<String> headers) {
    final widths = <int, pw.TableColumnWidth>{};
    for (var i = 0; i < headers.length; i++) {
      // Kolom pertama lebih lebar, sisanya flex
      widths[i] = i == 0
          ? const pw.FlexColumnWidth(2.5)
          : const pw.FlexColumnWidth(1.5);
    }
    return widths;
  }

  static Future<String> _getDownloadPath(String filename) async {
    final dir = await getExternalStorageDirectory();
    final downloadsPath = dir?.path ?? '/storage/emulated/0/Download';
    return '$downloadsPath/$filename';
  }
}