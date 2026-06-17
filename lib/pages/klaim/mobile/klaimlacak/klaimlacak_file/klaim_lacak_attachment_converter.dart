// services/klaim_lacak_attachment_converter.dart

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../../../../models/klaimlacak/klaim_lacak_attachment_item.dart';

class KlaimLacakAttachmentLocalFile {
  final String name;
  final String path;
  final KlaimAttachmentKind kind;

  const KlaimLacakAttachmentLocalFile({
    required this.name,
    required this.path,
    required this.kind,
  });

  bool get isImage => kind == KlaimAttachmentKind.image;
  bool get isPdf => kind == KlaimAttachmentKind.pdf;
}

class KlaimLacakAttachmentConverter {
  static Future<KlaimLacakAttachmentLocalFile> toLocalFile(
      KlaimLacakAttachmentItem item,
      ) async {
    final bytes = await _readBytes(item);
    final dir = await getTemporaryDirectory();

    final safeName = item.name.trim().isEmpty
        ? 'attachment_${DateTime.now().millisecondsSinceEpoch}'
        : item.name.trim();

    final file = File('${dir.path}/$safeName');
    await file.writeAsBytes(bytes, flush: true);

    return KlaimLacakAttachmentLocalFile(
      name: safeName,
      path: file.path,
      kind: item.kind,
    );
  }

  static Future<Uint8List> _readBytes(
      KlaimLacakAttachmentItem item,
      ) async {
    switch (item.sourceType) {
      case KlaimAttachmentSourceType.url:
        final res = await http.get(
          Uri.parse(item.source),
          headers: item.headers,
        );

        if (res.statusCode != 200) {
          throw Exception('Failed to download file: ${res.statusCode}');
        }

        return res.bodyBytes;

      case KlaimAttachmentSourceType.base64:
        final clean = item.source.contains(',')
            ? item.source.split(',').last
            : item.source;

        return base64Decode(clean);

      case KlaimAttachmentSourceType.bytes:
        final b = item.bytes;
        if (b == null) {
          throw Exception('Bytes source is null');
        }
        return b;

      case KlaimAttachmentSourceType.asset:
        final data = await rootBundle.load(item.source);
        return data.buffer.asUint8List();

      case KlaimAttachmentSourceType.file:
        return File(item.source).readAsBytes();
    }
  }
}