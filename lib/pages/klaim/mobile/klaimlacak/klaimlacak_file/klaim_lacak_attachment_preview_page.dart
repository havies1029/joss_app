// pages/klaimlacak/klaim_lacak_attachment_preview_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimlacak/klaim_lacak_attachment_item.dart';

import 'klaim_lacak_attachment_converter.dart';

void openKlaimLacakAttachmentPreview(
    BuildContext context,
    KlaimLacakAttachmentItem item,
    ) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => KlaimLacakAttachmentPreviewPage(item: item),
    ),
  );
}

class KlaimLacakAttachmentPreviewPage extends StatefulWidget {
  final KlaimLacakAttachmentItem item;

  const KlaimLacakAttachmentPreviewPage({
    super.key,
    required this.item,
  });

  @override
  State<KlaimLacakAttachmentPreviewPage> createState() =>
      _KlaimLacakAttachmentPreviewPageState();
}

class _KlaimLacakAttachmentPreviewPageState
    extends State<KlaimLacakAttachmentPreviewPage> {
  late Future<KlaimLacakAttachmentLocalFile> _future;
  PdfControllerPinch? _pdfController;

  @override
  void initState() {
    super.initState();
    _future = KlaimLacakAttachmentConverter.toLocalFile(widget.item);
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  void _initPdfController(String path) {
    _pdfController ??= PdfControllerPinch(
      document: PdfDocument.openFile(path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryBlackColor,
      appBar: AppBar(
        backgroundColor: secondaryBlackColor,
        iconTheme: const IconThemeData(color: primaryLightColor),
        title: Text(
          widget.item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: primaryLightColor),
        ),
      ),
      body: FutureBuilder<KlaimLacakAttachmentLocalFile>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError || !snap.hasData) {
            return Center(
              child: Text(
                'Gagal membuka file: ${snap.error}',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            );
          }

          final file = snap.data!;

          if (file.isImage) {
            return Center(
              child: InteractiveViewer(
                child: Image.file(File(file.path)),
              ),
            );
          }

          if (file.isPdf) {
            _initPdfController(file.path);

            return PdfViewPinch(
              controller: _pdfController!,
              onDocumentError: (error) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal membuka PDF: $error')),
                );
              },
            );
          }

          return const Center(
            child: Text(
              'Format file belum didukung untuk preview.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        },
      ),
    );
  }
}