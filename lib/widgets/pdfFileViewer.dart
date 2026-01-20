import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfFileViewPage extends StatelessWidget {
  final String title;
  final File pdfFile;

  const PdfFileViewPage({
    super.key,
    required this.title,
    required this.pdfFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<bool>(
        future: _checkFile(pdfFile),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data != true) {
            return Center(
              child: Text(
                "PDF tidak bisa dibuka\n${snap.error ?? ''}",
                textAlign: TextAlign.center,
              ),
            );
          }

          return SfPdfViewer.file(
            pdfFile,
            onDocumentLoaded: (details) {
              debugPrint("✅ PDF Loaded - pages: ${details.document.pages.count}");
            },
            onDocumentLoadFailed: (details) {
              debugPrint("❌ PDF Load Failed: ${details.error}");
            },
          );
        },
      ),
    );
  }

  Future<bool> _checkFile(File f) async {
    final exists = await f.exists();
    final len = exists ? await f.length() : 0;

    debugPrint("PDF path: ${f.path}");
    debugPrint("PDF exists: $exists");
    debugPrint("PDF size: $len");

    return exists && len > 0;
  }
}
