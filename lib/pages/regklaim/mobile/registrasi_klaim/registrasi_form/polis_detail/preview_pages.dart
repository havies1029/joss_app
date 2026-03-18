import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../../../common/constants.dart';
import '../../../../../../models/regklaim/attachment_item.dart';

void openPreview(BuildContext context, AttachmentItem item) {
  Navigator.push(context, MaterialPageRoute(builder: (_) {
    return AttachmentUnifiedPreviewPage(item: item);
  }));
}

class AttachmentUnifiedPreviewPage extends StatefulWidget {
  final AttachmentItem item;

  const AttachmentUnifiedPreviewPage({
    super.key,
    required this.item,
  });

  @override
  State<AttachmentUnifiedPreviewPage> createState() =>
      _AttachmentUnifiedPreviewPageState();
}

class _AttachmentUnifiedPreviewPageState
    extends State<AttachmentUnifiedPreviewPage> {

  PdfControllerPinch? _pdfController;

  @override
  void initState() {
    super.initState();

    if (widget.item.isPdf) {
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openFile(widget.item.path),
      );
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: secondaryBlackColor,
      appBar: AppBar(
        backgroundColor: secondaryBlackColor,
        iconTheme: const IconThemeData(color: primaryLightColor),
        title: Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: primaryLightColor,
          ),
        ),
      ),
      body: Center(
        child: item.isImage
            ? InteractiveViewer(
          child: Image.file(File(item.path)),
        )
            : item.isPdf
            ? PdfViewPinch(
          controller: _pdfController!,
          onDocumentError: (error) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Gagal membuka PDF: $error"),
              ),
            );
          },
        )
            : const Text(
          "Format file belum didukung untuk preview.",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}