import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PdfOpenHelper {
  Future<void> openBase64Pdf({
    required String base64Pdf,
    String filePrefix = 'invoice',
  }) async {
    String raw = base64Pdf.trim();

    // Kalau ternyata yang dikirim JSON string full, ambil field inv
    if (raw.startsWith('[') || raw.startsWith('{')) {
      final decoded = jsonDecode(raw);
      if (decoded is List && decoded.isNotEmpty) {
        raw = (decoded.first['inv'] ?? '').toString();
      } else if (decoded is Map) {
        raw = (decoded['inv'] ?? '').toString();
      }
    }

    if (raw.isEmpty) {
      throw Exception('Base64 kosong / inv tidak ditemukan');
    }

    // jaga-jaga ada prefix data URL
    raw = raw.replaceFirst(
      RegExp(r'^data:application\/pdf;base64,'),
      '',
    );

    // hilangin whitespace/newline
    raw = raw.replaceAll(RegExp(r'\s+'), '');

    final Uint8List bytes = base64Decode(raw);

    final directory = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();

    if (directory == null) {
      throw Exception('Directory tidak ditemukan');
    }

    final fileName =
        '${filePrefix}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final filePath = join(directory.path, fileName);

    final file = await File(filePath).writeAsBytes(bytes, flush: true);

    final result = await OpenFilex.open(file.path);

    if (result.type != ResultType.done) {
      throw Exception(result.message);
    }
  }
}