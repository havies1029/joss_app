import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfFileViewPage extends StatefulWidget {
  final String title;
  final File pdfFile;

  const PdfFileViewPage({
    super.key,
    required this.title,
    required this.pdfFile,
  });

  @override
  State<PdfFileViewPage> createState() => _PdfFileViewPageState();
}

class _PdfFileViewPageState extends State<PdfFileViewPage> {
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.pdfFile.path),
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
        title: Text(widget.title),
      ),
      body: FutureBuilder<bool>(
        future: _checkFile(widget.pdfFile),
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

          return PdfView(
            controller: _pdfController,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            onDocumentLoaded: (doc) {
              debugPrint("✅ PDF Loaded - pages: ${doc.pagesCount}");
            },
            onDocumentError: (error) {
              debugPrint("❌ PDF Load Error: $error");
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
