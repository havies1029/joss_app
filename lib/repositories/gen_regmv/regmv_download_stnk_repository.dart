import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:joss_app/apis/gen_regmv/regmv_download_stnk_api.dart';

class RegmvDownloadStnkRepository {
  RegmvDownloadStnkApi api = RegmvDownloadStnkApi();

  Future<String> downloadStnk(String regmv4Id) async {
    final response = await api.downloadStnkApi(regmv4Id);

    if (response.statusCode != 200) {
      throw Exception("Gagal download: ${response.statusCode}");
    }

    final bytes = response.bodyBytes;

    Directory dir = await getApplicationDocumentsDirectory();
    String filePath = "${dir.path}/STNK_$regmv4Id.jpg";

    File file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }
}