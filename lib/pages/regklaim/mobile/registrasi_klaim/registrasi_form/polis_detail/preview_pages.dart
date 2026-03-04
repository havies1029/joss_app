import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../../../models/regklaim/attachment_item.dart';

void openPreview(BuildContext context, AttachmentItem item) {
  if (item.isImage) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: Center(
          child: InteractiveViewer(
            child: Image.file(File(item.path)),
          ),
        ),
      );
    }));
    return;
  }

  if (item.isPdf) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return PdfPreviewPage(path: item.path);
    }));
  }
}

class PdfPreviewPage extends StatefulWidget {
  final String path;

  const PdfPreviewPage({
    super.key,
    required this.path,
  });

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  late PdfControllerPinch _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openFile(widget.path),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview PDF"),
      ),
      body: PdfViewPinch(
        controller: _pdfController,
        onDocumentLoaded: (doc) {
          debugPrint("✅ PDF Loaded - pages: ${doc.pagesCount}");
        },
        onDocumentError: (error) {
          debugPrint("❌ PDF Load Error: $error");
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal buka PDF: $error')),
          );
        },
      ),
    );
  }
}
