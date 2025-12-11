import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:joss_app/apis/regpar/regpar_download_fotoobject_api.dart';

class RegparDownloadFotoObjectRepository {
  RegparDownloadFotoObjectApi api = RegparDownloadFotoObjectApi();

  Future<String> downloadFotoObject(String regpar6Id) async {
    final response = await api.downloadFotoObjectApi(regpar6Id);
    if (response.statusCode != 200) {
      throw Exception("Gagal download: ${response.statusCode}");
    }

    final bytes = response.bodyBytes;

    Directory dir = await getApplicationDocumentsDirectory();
    String filePath = "${dir.path}/FOTOOBJECT_$regpar6Id.jpg";

    File file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }
}