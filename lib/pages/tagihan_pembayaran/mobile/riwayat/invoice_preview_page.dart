/*
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class InvoicePreviewFromBase64Page extends StatefulWidget {
  final String base64Pdf;

  const InvoicePreviewFromBase64Page({
    super.key,
    required this.base64Pdf,
  });

  @override
  State<InvoicePreviewFromBase64Page> createState() =>
      _InvoicePreviewFromBase64PageState();
}

class _InvoicePreviewFromBase64PageState
    extends State<InvoicePreviewFromBase64Page> {
  String? _error;
  bool _loading = true;
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _openPdfExternally();
  }

  Future<void> _openPdfExternally() async {
    try {
      String raw = widget.base64Pdf.trim();

      // Kalau ternyata yang dikirim JSON string full, ambil field inv
      if (raw.startsWith('[') || raw.startsWith('{')) {
        final decoded = jsonDecode(raw);
        if (decoded is List && decoded.isNotEmpty) {
          raw = (decoded.first['inv'] ?? '').toString();
        } else if (decoded is Map) {
          raw = (decoded['inv'] ?? '').toString();
        }
      }

      if (raw.isEmpty) {
        throw Exception("Base64 kosong / inv tidak ditemukan");
      }

      // jaga-jaga ada prefix data URL
      raw = raw.replaceFirst(
        RegExp(r'^data:application\/pdf;base64,'),
        '',
      );

      // hilangin whitespace/newline
      raw = raw.replaceAll(RegExp(r'\s+'), '');

      final Uint8List bytes = base64Decode(raw);

      final directory = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getExternalStorageDirectory();

      if (directory == null) {
        throw Exception("Directory tidak ditemukan");
      }

      final fileName =
          'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = join(directory.path, fileName);

      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      final result = await OpenFilex.open(file.path);

      if (result.type != ResultType.done) {
        throw Exception(result.message);
      }

      _opened = true;
    } catch (e) {
      _error = "Gagal buka invoice: $e";
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Invoice')),
      body: _loading
          ? const Center(child: LoadingIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : Center(
        child: Text(
          _opened
              ? 'PDF berhasil dibuka di aplikasi lain.'
              : 'Menyiapkan PDF...',
        ),
      ),
    );
  }
}*/
