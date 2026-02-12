import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
  const PdfPreviewPage({super.key, required this.path});

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  final PdfViewerController _controller = PdfViewerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _zoomIn() {
    final next = (_controller.zoomLevel + 0.25).clamp(1.0, 5.0);
    _controller.zoomLevel = next;
  }

  void _zoomOut() {
    final next = (_controller.zoomLevel - 0.25).clamp(1.0, 5.0);
    _controller.zoomLevel = next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview PDF"),
        actions: [
          IconButton(
            tooltip: 'Zoom In',
            icon: const Icon(Icons.zoom_in),
            onPressed: _zoomIn,
          ),
          IconButton(
            tooltip: 'Zoom Out',
            icon: const Icon(Icons.zoom_out),
            onPressed: _zoomOut,
          ),
        ],
      ),
      body: SfPdfViewer.file(
        File(widget.path),
        controller: _controller,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
        onDocumentLoadFailed: (details) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal buka PDF: ${details.error}')),
          );
        },
      ),
    );
  }
}
