import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:joss_app/apis/gen_regmv/regmv_download_mobil_api.dart';

class RegmvDownloadFotoMobilRepository {
  RegmvDownloadMobilApi api = RegmvDownloadMobilApi();

  Future<String> downloadFotoMobil(String regmv5Id) async {
    final response = await api.downloadFotoMobilApi(regmv5Id);
    if (response.statusCode != 200) {
      throw Exception("Gagal download: ${response.statusCode}");
    }

    final bytes = response.bodyBytes;

    Directory dir = await getApplicationDocumentsDirectory();
    String filePath = "${dir.path}/FOTOMOBIL_$regmv5Id.jpg";

    File file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }
}