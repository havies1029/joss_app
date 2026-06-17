// models/klaimlacak/klaim_lacak_attachment_item.dart

import 'dart:typed_data';

enum KlaimAttachmentSourceType {
  url,
  base64,
  bytes,
  asset,
  file,
}

enum KlaimAttachmentKind {
  image,
  pdf,
  file,
}

class KlaimLacakAttachmentItem {
  final String name;
  final String source;
  final Uint8List? bytes;
  final KlaimAttachmentSourceType sourceType;
  final KlaimAttachmentKind kind;
  final Map<String, String>? headers;

  const KlaimLacakAttachmentItem({
    required this.name,
    required this.source,
    this.bytes,
    required this.sourceType,
    required this.kind,
    this.headers,
  });

  bool get isImage => kind == KlaimAttachmentKind.image;
  bool get isPdf => kind == KlaimAttachmentKind.pdf;
}