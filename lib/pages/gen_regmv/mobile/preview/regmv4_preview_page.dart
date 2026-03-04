import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../common/constants.dart';
import '../../../../models/gen_regmv/regmv4upload_model.dart';

void openPreviewRegmv4(BuildContext context, Regmv4UploadModel item) {
  Navigator.push(context, MaterialPageRoute(builder: (_) {
    return Regmv4UnifiedPreviewPage(item: item);
  }));
}

class Regmv4UnifiedPreviewPage extends StatefulWidget {
  final Regmv4UploadModel item;

  const Regmv4UnifiedPreviewPage({
    super.key,
    required this.item,
  });

  @override
  State<Regmv4UnifiedPreviewPage> createState() => _Regmv4UnifiedPreviewPageState();
}

class _Regmv4UnifiedPreviewPageState extends State<Regmv4UnifiedPreviewPage> {
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
          widget.item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: primaryLightColor,
            // fontWeight: FontWeight.w600,
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
              SnackBar(content: Text('Gagal membuka PDF: $error')),
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