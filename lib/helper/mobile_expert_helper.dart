import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joss_app/common/constants.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
                  columnWidths: _getPdfColumnWidths(headers, data),
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
        color: headerBg,
      ),
      children: headers.map((rawHeader) {
        final isNo = _isNoColumn(rawHeader);

        return pw.Container(
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          alignment: isNo ? pw.Alignment.center : pw.Alignment.centerLeft,
          child: pw.Text(
            isNo ? 'No' : _formatHeaderName(rawHeader),
            maxLines: _shouldWrapHeader(rawHeader) ? 2 : 1,
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
            alignment: _getCellAlignment(header),
            child: pw.Text(
              value,
              maxLines: _shouldWrapValue(value) ? 3 : 1,
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

    sheet.appendRow(headers.map((h) => _formatHeaderName(h)).toList());

    for (final row in data) {
      sheet.appendRow(
        headers.map((h) => _displayValue(row[h])).toList(),
      );
    }

    for (int col = 0; col < headers.length; col++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
      );

      final header = headers[col];

      cell.cellStyle = CellStyle(
        bold: true,
        fontColorHex: '#FFFFFF',
        backgroundColorHex: '#8BBB4E',
        horizontalAlign:
        _isNoColumn(header) ? HorizontalAlign.Center : HorizontalAlign.Left,
        verticalAlign: VerticalAlign.Center,
      );
    }

    for (int col = 0; col < headers.length; col++) {
      final header = headers[col];

      for (int row = 1; row <= data.length; row++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
        );

        cell.cellStyle = CellStyle(
          horizontalAlign:
          _isNoColumn(header) ? HorizontalAlign.Center : HorizontalAlign.Left,
          verticalAlign: VerticalAlign.Center,
        );
      }
    }

    for (int col = 0; col < headers.length; col++) {
      sheet.setColWidth(
        col,
        _getExcelColumnWidth(headers[col], data),
      );
    }

    return excel;
  }

  static Map<int, pw.TableColumnWidth> _getPdfColumnWidths(
      List<String> headers,
      List<Map<String, dynamic>> data,
      ) {
    final widths = <int, pw.TableColumnWidth>{};

    for (var i = 0; i < headers.length; i++) {
      final header = headers[i];

      if (_isNoColumn(header)) {
        widths[i] = const pw.FixedColumnWidth(32);
        continue;
      }

      final maxLength = _maxColumnTextLength(header, data);

      if (maxLength <= 8) {
        widths[i] = const pw.FixedColumnWidth(55);
      } else if (maxLength <= 12) {
        widths[i] = const pw.FixedColumnWidth(75);
      } else if (maxLength <= 18) {
        widths[i] = const pw.FixedColumnWidth(95);
      } else if (maxLength <= 28) {
        widths[i] = const pw.FixedColumnWidth(125);
      } else {
        widths[i] = const pw.FixedColumnWidth(155);
      }
    }

    return widths;
  }

  static double _getExcelColumnWidth(
      String header,
      List<Map<String, dynamic>> data,
      ) {
    if (_isNoColumn(header)) return 6;

    final maxLength = _maxColumnTextLength(header, data);

    if (maxLength <= 8) return 10;
    if (maxLength <= 12) return 14;
    if (maxLength <= 18) return 20;
    if (maxLength <= 28) return 28;

    return 36;
  }

  static int _maxColumnTextLength(
      String header,
      List<Map<String, dynamic>> data,
      ) {
    final headerLength = _formatHeaderName(header).length;

    final maxValueLength = data.fold<int>(0, (currentMax, row) {
      final valueLength = _displayValue(row[header]).length;
      return valueLength > currentMax ? valueLength : currentMax;
    });

    return headerLength > maxValueLength ? headerLength : maxValueLength;
  }

  static bool _shouldWrapHeader(String header) {
    if (_isNoColumn(header)) return false;

    return _formatHeaderName(header).length > 28;
  }

  static bool _shouldWrapValue(String value) {
    return value.length > 28;
  }

  static String _formatHeaderName(String header) {
    final h = header.toLowerCase();

    if (h == 'currency') return 'Mata uang';
    if (h == 'deskripsi_transaksi') return 'Deskripsi';
    if (h == 'nama_perusahaan_panjang_banget') return 'Perusahaan';

    return header
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
    )
        .join(' ');
  }

  static pw.Alignment _getCellAlignment(String header) {
    if (_isNoColumn(header)) {
      return pw.Alignment.center;
    }

    return pw.Alignment.centerLeft;
  }

  static bool _isNoColumn(String header) {
    return header.trim().toLowerCase() == 'no';
  }

  static String _displayValue(dynamic value) {
    if (value == null) return '-';

    final text = value.toString().trim();
    if (text.isEmpty) return '-';

    return text;
  }
}