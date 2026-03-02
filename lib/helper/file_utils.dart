import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String> bytesToPath({
  required Uint8List bytes,
  String name = "file",
  String ext = "jpg",
}) async {
  final dir = await getTemporaryDirectory();

  final filePath = p.join(
    dir.path,
    "${name}_${DateTime.now().millisecondsSinceEpoch}.$ext",
  );

  final file = File(filePath);
  await file.writeAsBytes(bytes, flush: true);

  return filePath;
}