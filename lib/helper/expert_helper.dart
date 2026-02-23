import 'dart:io';
import 'dart:typed_data';
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
  static Future<void> export(String format, List<Map<String, dynamic>> data, CategoryType category) async {
    final categoryName = category.name;
    switch (format.toLowerCase()) {
      case 'excel':
        await _exportToExcel(data, categoryName);
        break;
      case 'pdf':
        await _exportToPdf(data, categoryName);
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

  static Future<void> _exportToPdf(List<Map<String, dynamic>> data, String categoryName) async {
    if (data.isEmpty || !(await _ensurePermission())) return;

    final pdf = pw.Document();
    final headers = data.first.keys.toList();
    final now = DateTime.now();
    final formattedDate = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}';

    // Modern color palette
    final primaryColor = PdfColor.fromHex('#2563eb'); // Blue
    final headerBg = PdfColor.fromHex('#1e40af'); // Dark blue
    final evenRowBg = PdfColor.fromHex('#f8fafc'); // Light gray
    final borderColor = PdfColor.fromHex('#e2e8f0'); // Border gray

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header Section
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 20),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: primaryColor, width: 3),
              ),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Laporan Data',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: headerBg,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          _formatCategoryName(categoryName),
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColor.fromHex('#64748b'),
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Tanggal Export',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColor.fromHex('#94a3b8'),
                          ),
                        ),
                        pw.Text(
                          formattedDate,
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#475569'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 24),

          // Stats Section
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#eff6ff'),
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColor.fromHex('#bfdbfe')),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Icon(
                  pw.IconData(0xe85d), // document icon
                  size: 20,
                  color: primaryColor,
                ),
                pw.SizedBox(width: 10),
                pw.Text(
                  'Total Records: ${data.length}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: headerBg,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Modern Table
          pw.Table(
            border: pw.TableBorder(
              horizontalInside: pw.BorderSide(color: borderColor, width: 0.5),
              verticalInside: pw.BorderSide(color: borderColor, width: 0.5),
              left: pw.BorderSide(color: borderColor, width: 1),
              right: pw.BorderSide(color: borderColor, width: 1),
              top: pw.BorderSide(color: headerBg, width: 2),
              bottom: pw.BorderSide(color: borderColor, width: 1),
            ),
            columnWidths: _getColumnWidths(headers),
            children: [
              // Header Row
              pw.TableRow(
                decoration: pw.BoxDecoration(color: headerBg),
                children: headers.map((header) {
                  return pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: pw.Text(
                      _formatHeaderName(header),
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                        letterSpacing: 0.3,
                      ),
                      textAlign: pw.TextAlign.left,
                    ),
                  );
                }).toList(),
              ),
              // Data Rows
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
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: pw.Text(
                        row[header]?.toString() ?? '-',
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColor.fromHex('#334155'),
                          lineSpacing: 1.3,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ],
        footer: (context) => pw.Container(
          margin: const pw.EdgeInsets.only(top: 20),
          padding: const pw.EdgeInsets.only(top: 10),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: borderColor, width: 1),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated by Export System',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColor.fromHex('#94a3b8'),
                ),
              ),
              pw.Text(
                'Halaman ${context.pageNumber} dari ${context.pagesCount}',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColor.fromHex('#94a3b8'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final pdfBytes = await pdf.save();
    final filename = 'Data_${categoryName}_${DateTime.now().millisecondsSinceEpoch}.pdf';

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