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
  sdm,
  lain_lain,
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
      await OpenFilex.open(file.path); // Optional: langsung buka file
    }
  }

  static Future<void> _exportToPdf(List<Map<String, dynamic>> data, String categoryName) async {
    if (data.isEmpty || !(await _ensurePermission())) return;

    final pdf = pw.Document();
    final headers = data.first.keys.toList();

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Table.fromTextArray(
        headers: headers,
        data: data.map((row) => headers.map((h) => row[h]?.toString() ?? '').toList()).toList(),
      ),
    ));

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

  static Future<String> _getDownloadPath(String filename) async {
    final dir = await getExternalStorageDirectory();
    final downloadsPath = dir?.path ?? '/storage/emulated/0/Download';
    return '$downloadsPath/$filename';
  }
}
