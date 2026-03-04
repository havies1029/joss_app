import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:joss_app/apis/gen_sppamv/download_polis_api.dart';

class DownloadPolisRepository {
  DownloadPolisApi api = DownloadPolisApi();

  Future<String> downloadPolis(String ePolisId) async {
    final response = await api.downloadPolisApi(ePolisId);

    if (response.statusCode != 200) {
      throw Exception("Gagal download: ${response.statusCode}");
    }

    final cd = response.headers['content-disposition'];

    final fileName =
        extractFileName(cd) ?? "epolis_$ePolisId.pdf";

    final bytes = response.bodyBytes;

    final Directory dir = await getApplicationDocumentsDirectory();
    final String filePath = "${dir.path}/$fileName";

    final File file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }

  String? extractFileName(String? contentDisposition) {
    if (contentDisposition == null) {
      debugPrint("⚠️ [extractFileName] content-disposition is null");
      return null;
    }

    final starMatch = RegExp(
      r'filename\*\s*=\s*([^;]+)',
      caseSensitive: false,
    ).firstMatch(contentDisposition);

    if (starMatch != null) {
      var value = starMatch.group(1)!.trim();

      if (value.toLowerCase().startsWith("utf-8''")) {
        value = value.substring(7);
      }

      value = value.replaceAll('"', '');
      final decoded = Uri.decodeFull(value);

      return decoded;
    }

    final normalMatch = RegExp(
      r'filename\s*=\s*"?([^";]+)"?',
      caseSensitive: false,
    ).firstMatch(contentDisposition);

    final result = normalMatch?.group(1)?.trim();
    debugPrint("📄 [extractFileName] filename: $result");

    return result;
  }
}
