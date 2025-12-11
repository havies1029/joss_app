import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:joss_app/apis/gen_regmv/regmv_download_acc_api.dart';

class RegmvDownloadFotoAccRepository {
  RegmvDownloadAccApi api = RegmvDownloadAccApi();

  Future<String> downloadFotoAcc(String regmv7Id) async {
    final response = await api.downloadFotoAccApi(regmv7Id);
    if (response.statusCode != 200) {
      throw Exception("Gagal download: ${response.statusCode}");
    }

    final bytes = response.bodyBytes;

    Directory dir = await getApplicationDocumentsDirectory();
    String filePath = "${dir.path}/FOTOACC_$regmv7Id.jpg";

    File file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }
}