import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joss_app/common/constants.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:file_saver/file_saver.dart';

class MobileDownloadHelper {
  static Future<void> download({
    required BuildContext context,
    required String fileName,
    required List<Map<String, dynamic>> data,
    required String format,
    required String reportTitle,
    String logoAssetPath = 'assets/images/logo.png',
  }) async {
    final lowerFormat = format.toLowerCase();

    late final Uint8List bytes;
    late final String ext;
    late final MimeType mimeType;

    if (lowerFormat == 'pdf') {
      final pdf = await _generatePdf(
        data,
        reportTitle: reportTitle,
        logoAssetPath: logoAssetPath,
      );

      bytes = await pdf.save();
      ext = 'pdf';
      mimeType = MimeType.pdf;
    } else if (lowerFormat == 'excel' || lowerFormat == 'xlsx') {
      final excel = _generateExcel(data);

      bytes = Uint8List.fromList(excel.encode()!);
      ext = 'xlsx';
      mimeType = MimeType.microsoftExcel;
    } else {
      throw UnsupportedError("Format $format tidak didukung di mobile.");
    }

    final cleanName = fileName.replaceAll(RegExp(r'\.(pdf|xlsx)$'), '');

    final savedPath = await FileSaver.instance.saveFile(
      name: cleanName,
      bytes: bytes,
      ext: ext,
      mimeType: mimeType,
    );

    debugPrint("SAVED PATH: $savedPath");

    if (savedPath != null && savedPath.isNotEmpty) {
      await OpenFilex.open(savedPath);
    }
  }

  static Future<File> generatePdfFile({
    required String fileName,
    required List<Map<String, dynamic>> data,
    required String reportTitle,
    String logoAssetPath = 'assets/images/logo.png',
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');

    final pdf = await _generatePdf(
      data,
      reportTitle: reportTitle,
      logoAssetPath: logoAssetPath,
    );

    await file.writeAsBytes(await pdf.save());
    return file;
  }
  static Future<pw.Document> _generatePdf(
      List<Map<String, dynamic>> data, {
        required String reportTitle,
        required String logoAssetPath,
      }) async {
    pw.Font? regularFont;
    pw.Font? boldFont;

    try {
      final regularFontData =
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
      final boldFontData =
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf');

      regularFont = pw.Font.ttf(regularFontData);
      boldFont = pw.Font.ttf(boldFontData);
    } catch (_) {
      regularFont = null;
      boldFont = null;
    }

    final pdf = pw.Document(
      theme: regularFont != null && boldFont != null
          ? pw.ThemeData.withFont(
        base: regularFont,
        bold: boldFont,
      )
          : null,
    );

    final headers = data.isNotEmpty
        ? data.first.keys.map((e) => e.toString()).toList()
        : <String>[];

    final now = DateTime.now();
    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    final borderColor = PdfColor.fromHex('#d1d5db');
    final headerBg = PdfColor.fromHex('#8bbb4e');
    final evenRowBg = PdfColor.fromHex('#f8fafc');
    final textColor = PdfColor.fromHex('#111827');
    final subTextColor = PdfColor.fromHex('#4b5563');

    pw.MemoryImage? logoImage;

    try {
      final logoBytes = await rootBundle.load(logoAssetPath);
      logoImage = pw.MemoryImage(
        Uint8List.fromList(logoBytes.buffer.asUint8List()),
      );
    } catch (_) {
      logoImage = null;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(vPadding),
        build: (context) {
          if (headers.isEmpty) {
            return [
              pw.Text(
                'Tidak ada data',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: subTextColor,
                ),
              ),
            ];
          }

          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Laporan data $reportTitle',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'Tanggal dibuat : $formattedDate',
                        style: pw.TextStyle(
                          fontSize: 11,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (logoImage != null)
                  pw.Image(
                    logoImage,
                    width: 180,
                    fit: pw.BoxFit.contain,
                  ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: borderColor, width: 1),
                borderRadius: pw.BorderRadius.circular(cardBorderRadius),
              ),
              child: pw.ClipRRect(
                horizontalRadius: cardBorderRadius,
                verticalRadius: cardBorderRadius,
                child: pw.Table(
                  border: pw.TableBorder(
                    horizontalInside: pw.BorderSide(
                      color: borderColor,
                      width: 0.4,
                    ),
                    verticalInside: pw.BorderSide(
                      color: borderColor,
                      width: 0.25,
                    ),
                  ),
                  columnWidths: _getColumnWidths(headers),
                  defaultVerticalAlignment:
                  pw.TableCellVerticalAlignment.middle,
                  children: [
                    _buildHeaderRow(
                      headers: headers,
                      headerBg: headerBg,
                    ),
                    ...data.asMap().entries.map((entry) {
                      final rowIndex = entry.key;
                      final row = entry.value;
                      final isEven = rowIndex % 2 == 0;
                      final isLastRow = rowIndex == data.length - 1;

                      return _buildDataRow(
                        row: row,
                        headers: headers,
                        isEven: isEven,
                        isLastRow: isLastRow,
                        evenRowBg: evenRowBg,
                        textColor: textColor,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ];
        },
        footer: (context) => pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: hPadding),
          child: pw.Row(
            children: [
              pw.Expanded(child: pw.SizedBox()),
              pw.Expanded(
                flex: 2,
                child: pw.Center(
                  child: pw.Text(
                    'Perusahaan Pialang dan Konsultan Asuransi www.jayaproteksindo.co.id',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    '${context.pageNumber} / ${context.pagesCount}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return pdf;
  }

  static pw.TableRow _buildHeaderRow({
    required List<String> headers,
    required PdfColor headerBg,
  }) {
    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: headerBg, // 🔥 FULL ROW COLOR (no gap)
      ),
      children: headers.asMap().entries.map((entry) {
        final index = entry.key;
        final rawHeader = entry.value;

        final isNo = rawHeader.trim().toLowerCase() == 'no';

        return pw.Container(
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          alignment: isNo
              ? pw.Alignment.center
              : pw.Alignment.centerLeft,
          child: pw.Text(
            isNo ? 'No' : _formatHeaderName(rawHeader),
            maxLines: 1,
            overflow: pw.TextOverflow.clip,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        );
      }).toList(),
    );
  }

  static pw.TableRow _buildDataRow({
    required Map<String, dynamic> row,
    required List<String> headers,
    required bool isEven,
    required bool isLastRow,
    required PdfColor evenRowBg,
    required PdfColor textColor,
  }) {
    return pw.TableRow(
      children: headers.asMap().entries.map((entry) {
        final colIndex = entry.key;
        final header = entry.value;
        final value = _displayValue(row[header]);
        final alignment = _getCellAlignment(header);

        return pw.Container(
          decoration: pw.BoxDecoration(
            color: isEven ? evenRowBg : PdfColors.white,
            borderRadius: pw.BorderRadius.only(
              bottomLeft: isLastRow && colIndex == 0
                  ? const pw.Radius.circular(cardBorderRadius)
                  : pw.Radius.zero,
              bottomRight: isLastRow && colIndex == headers.length - 1
                  ? const pw.Radius.circular(cardBorderRadius)
                  : pw.Radius.zero,
            ),
          ),
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          child: pw.Align(
            alignment: alignment,
            child: pw.Text(
              value,
              maxLines: _isLongTextColumn(header) ? 3 : 1,
              overflow: pw.TextOverflow.clip,
              style: pw.TextStyle(
                fontSize: 9,
                color: textColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  static Excel _generateExcel(List<Map<String, dynamic>> data) {
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet() ?? 'Sheet1'];

    final headers = data.isNotEmpty ? data.first.keys.toList() : <String>[];

    if (headers.isEmpty) {
      return excel;
    }

    // Header row
    sheet.appendRow(headers.map((h) => _formatHeaderName(h)).toList());

    // Data rows
    for (final row in data) {
      sheet.appendRow(
        headers.map((h) => _displayValue(row[h])).toList(),
      );
    }

    // Header style
    for (int col = 0; col < headers.length; col++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
      );

      final rawHeader = headers[col].trim().toLowerCase();

      cell.cellStyle = CellStyle(
        bold: true,
        fontColorHex: '#FFFFFF',
        backgroundColorHex: '#8BBB4E',
        horizontalAlign:
        rawHeader == 'no' ? HorizontalAlign.Center : HorizontalAlign.Left,
        verticalAlign: VerticalAlign.Center,
      );
    }

    // Body style
    for (int col = 0; col < headers.length; col++) {
      final rawHeader = headers[col].trim().toLowerCase();

      for (int row = 1; row <= data.length; row++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
        );

        cell.cellStyle = CellStyle(
          horizontalAlign:
          rawHeader == 'no' ? HorizontalAlign.Center : HorizontalAlign.Left,
          verticalAlign: VerticalAlign.Center,
        );
      }
    }

    // Column widths
    for (int col = 0; col < headers.length; col++) {
      final rawHeader = headers[col].trim().toLowerCase();
      sheet.setColWidth(col, _getExcelColumnWidth(rawHeader));
    }

    return excel;
  }

  static double _getExcelColumnWidth(String header) {
    if (header == 'no') return 6;
    if (header == 'currency') return 12;

    if (_isTinyExcelColumn(header)) return 10;
    if (_isSmallExcelColumn(header)) return 14;
    if (_isMediumExcelColumn(header)) return 20;
    if (_isLargeExcelColumn(header)) return 28;
    if (_isXLargeExcelColumn(header)) return 36;

    return 18;
  }

  static bool _isTinyExcelColumn(String header) {
    return [
      'id',
      'kode',
      'code',
      'jk',
      'usia',
      'umur',
      'qty',
    ].contains(header);
  }

  static bool _isSmallExcelColumn(String header) {
    return header.contains('tanggal') ||
        header.contains('date') ||
        header.contains('status') ||
        header.contains('level') ||
        header.contains('phone') ||
        header.contains('hp') ||
        header.contains('nomor');
  }

  static bool _isMediumExcelColumn(String header) {
    return header.contains('nama') ||
        header.contains('name') ||
        header.contains('email') ||
        header.contains('jabatan') ||
        header.contains('kategori') ||
        header.contains('jenis');
  }

  static bool _isLargeExcelColumn(String header) {
    return header.contains('alamat') ||
        header.contains('address') ||
        header.contains('keterangan') ||
        header.contains('deskripsi') ||
        header.contains('description') ||
        header.contains('catatan') ||
        header.contains('note');
  }

  static bool _isXLargeExcelColumn(String header) {
    return header.contains('remark') ||
        header.contains('uraian') ||
        header.contains('detail') ||
        header.contains('informasi') ||
        header.contains('message');
  }

  static String _formatHeaderName(String header) {
    final h = header.toLowerCase();

    if (h == 'currency') return 'Mata uang';
    if (h == 'deskripsi_transaksi') return 'Deskripsi';
    if (h == 'nama_perusahaan_panjang_banget') return 'Perusahaan';

    return header
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
    word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  static bool _isCurrencyColumn(String header) {
    return header == 'currency';
  }

  static Map<int, pw.TableColumnWidth> _getColumnWidths(List<String> headers) {
    final widths = <int, pw.TableColumnWidth>{};

    for (var i = 0; i < headers.length; i++) {
      final header = headers[i].trim().toLowerCase();

      if (_isNoColumn(header)) {
        widths[i] = const pw.FixedColumnWidth(32);
      } else if (_isCurrencyColumn(header)) {
        widths[i] = const pw.FixedColumnWidth(58);
      } else if (_isTinyColumn(header)) {
        widths[i] = const pw.FixedColumnWidth(55);
      } else if (_isSmallColumn(header)) {
        widths[i] = const pw.FixedColumnWidth(80);
      } else if (_isMediumColumn(header)) {
        widths[i] = const pw.FlexColumnWidth(1.2);
      } else if (_isLargeColumn(header)) {
        widths[i] = const pw.FlexColumnWidth(2.2);
      } else if (_isXLargeColumn(header)) {
        widths[i] = const pw.FlexColumnWidth(3.0);
      } else {
        widths[i] = const pw.FlexColumnWidth(1.4);
      }
    }

    return widths;
  }
  // static pw.Alignment _getCellAlignment(String header, {bool isHeader = false}) {
  //   final h = header.trim().toLowerCase();
  //
  //   if (_isNumericColumn(h)) {
  //     return pw.Alignment.centerRight;
  //   }
  //
  //   if (_isCenteredColumn(h)) {
  //     return pw.Alignment.center;
  //   }
  //
  //   return isHeader ? pw.Alignment.centerLeft : pw.Alignment.centerLeft;
  // }

  static pw.Alignment _getCellAlignment(String header) {
    final h = header.trim().toLowerCase();

    if (h == 'no') {
      return pw.Alignment.center;
    }

    return pw.Alignment.centerLeft;
  }

  static bool _isNoColumn(String header) {
    return header == 'no';
  }

  static bool _isTinyColumn(String header) {
    return [
      'id',
      'kode',
      'code',
      'jk',
      'usia',
      'umur',
      'qty',
      'jumlah',
      'currency',
    ].contains(header);
  }

  static bool _isSmallColumn(String header) {
    return header.contains('tanggal') ||
        header.contains('date') ||
        header.contains('status') ||
        header.contains('hp') ||
        header.contains('phone') ||
        header.contains('nomor') ||
        header.contains('no ') ||
        header.startsWith('no_') ||
        header.contains('level');
  }

  static bool _isMediumColumn(String header) {
    return header.contains('nama') ||
        header.contains('name') ||
        header.contains('email') ||
        header.contains('jabatan') ||
        header.contains('kategori') ||
        header.contains('jenis');
  }

  static bool _isLargeColumn(String header) {
    return header.contains('alamat') ||
        header.contains('address') ||
        header.contains('keterangan') ||
        header.contains('deskripsi') ||
        header.contains('description') ||
        header.contains('catatan') ||
        header.contains('note');
  }

  static bool _isXLargeColumn(String header) {
    return header.contains('remark') ||
        header.contains('uraian') ||
        header.contains('detail') ||
        header.contains('informasi') ||
        header.contains('message');
  }

  static bool _isNumericColumn(String header) {
    return header.contains('total') ||
        header.contains('harga') ||
        header.contains('price') ||
        header.contains('amount') ||
        header.contains('qty') ||
        header.contains('jumlah') ||
        header.contains('nominal') ||
        header.contains('persen') ||
        header.contains('percent') ||
        header.contains('rate') ||
        header.contains('nilai') ||
        header.contains('score') ||
        header.contains('poin');
  }

  static bool _isCenteredColumn(String header) {
    return _isNoColumn(header) ||
        header.contains('status') ||
        header.contains('level') ||
        header.contains('jenis') ||
        header.contains('kategori') ||
        header.contains('gender') ||
        header.contains('jk');
  }

  static bool _isLongTextColumn(String header) {
    return header.contains('alamat') ||
        header.contains('address') ||
        header.contains('deskripsi') ||
        header.contains('description') ||
        header.contains('keterangan') ||
        header.contains('catatan') ||
        header.contains('remark') ||
        header.contains('detail') ||
        header.contains('message') ||
        header.contains('informasi');
  }

  static String _displayValue(dynamic value) {
    if (value == null) return '-';

    final text = value.toString().trim();
    if (text.isEmpty) return '-';

    return text;
  }
}