import 'dart:io';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart'; // ⬅️ untuk snackbar

class MobileDownloadHelper {
  static Future<void> download({
    required BuildContext context,
    required String fileName,
    required List<Map<String, dynamic>> data,
    required String format,
  }) async {
    final messenger = ScaffoldMessenger.of(context);

    final hasPermission = await Permission.manageExternalStorage.request().isGranted;
    if (!hasPermission) {
      // messenger.showSnackBar(
      //   const SnackBar(content: Text('❌ Izin penyimpanan ditolak.')),
      // );
      return;
    }

    // ✅ Folder download yang terlihat di File Manager
    final directory = Directory('/storage/emulated/0/Download');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final path = '${directory.path}/$fileName';
    final file = File(path);

    try {
      final lowerFormat = format.toLowerCase();
      if (lowerFormat == 'pdf') {
        final pdf = _generatePdf(data);
        await file.writeAsBytes(await pdf.save());
      } else if (lowerFormat == 'excel' || lowerFormat == 'xlsx') {
        final excel = _generateExcel(data);
        await file.writeAsBytes(excel.encode()!);
      } else {
        throw UnsupportedError("Format $format tidak didukung di mobile.");
      }

      // messenger.showSnackBar(
      //   SnackBar(content: Text('✅ Berhasil mengunduh ke folder Download:\n$fileName')),
      // );

      await OpenFilex.open(file.path);
    } catch (e) {
      // messenger.showSnackBar(
      //   SnackBar(content: Text('❌ Gagal menyimpan file: $e')),
      // );
    }
  }

  static pw.Document _generatePdf(List<Map<String, dynamic>> data) {
    final pdf = pw.Document();
    final headers = data.isNotEmpty ? data.first.keys.toList() : [];

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Table.fromTextArray(
          headers: headers,
          data: data.map((row) => headers.map((h) => row[h].toString()).toList()).toList(),
        ),
      ),
    );
    return pdf;
  }

  static Excel _generateExcel(List<Map<String, dynamic>> data) {
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet() ?? 'Sheet1'];

    final headers = data.isNotEmpty ? data.first.keys.toList() : [];
    sheet.appendRow(headers);

    for (var row in data) {
      sheet.appendRow(headers.map((h) => row[h]?.toString() ?? '').toList());
    }

    return excel;
  }
}
