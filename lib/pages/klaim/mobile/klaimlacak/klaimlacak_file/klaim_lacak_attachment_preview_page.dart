// pages/klaimlacak/klaim_lacak_attachment_preview_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:open_filex/open_filex.dart';
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
  bool _externalOpenRequested = false;

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

  Future<void> _openExternal(KlaimLacakAttachmentLocalFile file) async {
    final result = await OpenFilex.open(file.path);
    if (!mounted) return;

    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          result.message.isNotEmpty
              ? result.message
              : 'Tidak ada aplikasi yang dapat membuka file ini.',
        ),
      );
    }
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
            return const Center(child: LoadingIndicator());
          }

          if (snap.hasError || !snap.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Gagal membuka file: ${snap.error}',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
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
                  errorSnackBar('Gagal membuka PDF: $error'),
                );
              },
            );
          }

          if (!_externalOpenRequested) {
            _externalOpenRequested = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _openExternal(file);
            });
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.insert_drive_file_outlined,
                    color: primaryLightColor,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    file.name,
                    textAlign: TextAlign.center,
                    style: bodyTextStyle(context),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'File akan dibuka dengan aplikasi yang tersedia di perangkat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  AppButton.primary(
                    text: 'Buka File',
                    onPressed: () => _openExternal(file),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
