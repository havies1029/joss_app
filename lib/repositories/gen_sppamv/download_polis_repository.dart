import 'dart:io';
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
    final fileName = extractFileName(cd)
      ?? "epolis_$ePolisId.pdf";

    final bytes = response.bodyBytes;

    Directory dir = await getApplicationDocumentsDirectory();
    String filePath = "${dir.path}/$fileName";

    File file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }

  String? extractFileName(String? contentDisposition) {
    if (contentDisposition == null) return null;

    // 1) filename*=UTF-8''xxxxx  (RFC 5987)
    final starMatch = RegExp(
      r'filename\*\s*=\s*([^;]+)',
      caseSensitive: false,
    ).firstMatch(contentDisposition);

    if (starMatch != null) {
      var value = starMatch.group(1)!.trim();

      // contoh: UTF-8''epolis_par_only_123.jpg
      // atau: UTF-8''SPPA%2FABC.pdf
      if (value.toLowerCase().startsWith("utf-8''")) {
        value = value.substring(7); // buang: UTF-8''
      }

      // buang quote jika ada
      value = value.replaceAll('"', '');

      // decode url-encoded
      return Uri.decodeFull(value);
    }

    // 2) filename="xxxx" atau filename=xxxx
    final normalMatch = RegExp(
      r'filename\s*=\s*"?([^";]+)"?',
      caseSensitive: false,
    ).firstMatch(contentDisposition);

    return normalMatch?.group(1)?.trim();
  }

}