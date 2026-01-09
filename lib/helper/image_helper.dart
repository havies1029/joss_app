import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  Future<String> convertBytes2LocalImage(
      {String? fileName, required Uint8List bytes}) async {
    //debugPrint("filePolisFromUrl");

    final directory = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();
    if (directory == null) {
      return Future.error("null");
    }

    fileName ??= "${idGenerator()}.jpg";

    final filePath = join(directory.path, fileName);

    final file = await File(filePath).writeAsBytes(bytes);
    //debugPrint("file.path : ${file.path}");

    return file.path;
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  static String bankLogoAsset(String bankCode) {
    switch (bankCode.toUpperCase()) {
      case 'BCA':
        return 'assets/bank_logo/bca.png';
      case 'MANDIRI':
        return 'assets/bank_logo/mandiri.png';
      case 'BNI':
        return 'assets/bank_logo/bni.png';
      case 'BRI':
        return 'assets/bank_logo/bri.png';
      case 'DANAMON':
        return 'assets/bank_logo/danamon.png';
      default:
        return 'assets/bank_logo/bank.png';
    }
  }
}
