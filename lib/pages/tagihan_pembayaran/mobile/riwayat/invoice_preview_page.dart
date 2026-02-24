import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class InvoicePreviewFromBase64Page extends StatefulWidget {
  final String base64Pdf; // idealnya ini INV base64, bukan JSON

  const InvoicePreviewFromBase64Page({
    super.key,
    required this.base64Pdf,
  });

  @override
  State<InvoicePreviewFromBase64Page> createState() => _InvoicePreviewFromBase64PageState();
}

class _InvoicePreviewFromBase64PageState extends State<InvoicePreviewFromBase64Page> {
  PdfControllerPinch? _controller;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  Future<void> _initPdf() async {
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
      raw = raw.replaceFirst(RegExp(r'^data:application\/pdf;base64,'), '');
      // hilangin whitespace/newline
      raw = raw.replaceAll(RegExp(r'\s+'), '');

      final Uint8List bytes = base64Decode(raw);

      _controller = PdfControllerPinch(
        document: PdfDocument.openData(bytes),
      );
    } catch (e) {
      _error = "Gagal buka invoice: $e";
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Preview')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null
          ? Center(child: Text(_error!))
          : PdfViewPinch(controller: _controller!)),
    );
  }
}