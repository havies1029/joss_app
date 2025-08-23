import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class Img {
  static String get(String name) {
    return 'assets/images/$name';
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<Uint8List?> readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File file = File.fromUri(myUri);
    Uint8List? bytes;
    await file.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value); 
    debugPrint('reading of bytes is completed');
    }).catchError((onError) {
        debugPrint('Exception Error while reading bytes from path:$onError');
    });
    return bytes;
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
