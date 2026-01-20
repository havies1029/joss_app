import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:joss_app/apis/gen_sppamv/download_polis_api.dart';

class DownloadPolisRepository {
  DownloadPolisApi api = DownloadPolisApi();

  Future<String> downloadPolis(String ePolisId) async {
    debugPrint("⬇️ [DownloadPolis] Start download | ePolisId=$ePolisId");

    final response = await api.downloadPolisApi(ePolisId);

    debugPrint(
      "🌐 [DownloadPolis] Response status: ${response.statusCode}",
    );

    if (response.statusCode != 200) {
      debugPrint(
        "❌ [DownloadPolis] Download failed | status=${response.statusCode}",
      );
      throw Exception("Gagal download: ${response.statusCode}");
    }

    final cd = response.headers['content-disposition'];
    debugPrint("📎 [DownloadPolis] content-disposition: $cd");

    final fileName =
        extractFileName(cd) ?? "epolis_$ePolisId.pdf";

    debugPrint("📝 [DownloadPolis] Parsed fileName: $fileName");

    final bytes = response.bodyBytes;
    debugPrint("📦 [DownloadPolis] File size: ${bytes.length} bytes");

    final Directory dir = await getApplicationDocumentsDirectory();
    final String filePath = "${dir.path}/$fileName";

    debugPrint("📂 [DownloadPolis] Save path: $filePath");

    final File file = File(filePath);
    await file.writeAsBytes(bytes);

    debugPrint("✅ [DownloadPolis] File saved successfully");

    return filePath;
  }

  String? extractFileName(String? contentDisposition) {
    if (contentDisposition == null) {
      debugPrint("⚠️ [extractFileName] content-disposition is null");
      return null;
    }

    debugPrint(
      "🔍 [extractFileName] Raw header: $contentDisposition",
    );

    // 1) filename*=UTF-8''xxxxx (RFC 5987)
    final starMatch = RegExp(
      r'filename\*\s*=\s*([^;]+)',
      caseSensitive: false,
    ).firstMatch(contentDisposition);

    if (starMatch != null) {
      var value = starMatch.group(1)!.trim();
      debugPrint("⭐ [extractFileName] filename*: $value");

      if (value.toLowerCase().startsWith("utf-8''")) {
        value = value.substring(7);
      }

      value = value.replaceAll('"', '');
      final decoded = Uri.decodeFull(value);

      debugPrint("✅ [extractFileName] Decoded filename*: $decoded");
      return decoded;
    }

    // 2) filename="xxxx" atau filename=xxxx
    final normalMatch = RegExp(
      r'filename\s*=\s*"?([^";]+)"?',
      caseSensitive: false,
    ).firstMatch(contentDisposition);

    final result = normalMatch?.group(1)?.trim();
    debugPrint("📄 [extractFileName] filename: $result");

    return result;
  }
}
