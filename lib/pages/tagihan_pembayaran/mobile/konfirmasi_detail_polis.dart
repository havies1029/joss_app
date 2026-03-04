import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/payment/dnsppacari_model.dart';

enum KonfirmasiSource {
  ringkasan,
  rincian,
}

/// Model untuk konfigurasi kolom table
class TableColumnConfig {
  final String header;
  final double width;
  final String Function(DnsppaCariModel) getValue;
  final bool alignRight;

  const TableColumnConfig({
    required this.header,
    required this.width,
    required this.getValue,
    this.alignRight = false,
  });
}

class KonfirmasiDetailPolisPage extends StatelessWidget {
  final List<DnsppaCariModel> selectedItems;
  final KonfirmasiSource source;
  final List<TableColumnConfig>? customColumns;

  const KonfirmasiDetailPolisPage({
    super.key,
    required this.selectedItems,
    required this.source,
    this.customColumns,
  });

  String formatNum(num value) => NumberFormat.decimalPattern().format(value);

  /// Default columns untuk Ringkasan
  List<TableColumnConfig> get _ringkasanColumns => [
    TableColumnConfig(
      header: "No",
      width: 50,
      getValue: (_) => "",
    ),
    // TableColumnConfig(
    //   header: "Kategori",
    //   width: 120,
    //   getValue: (d) => d. ?? "-",
    // ),
    TableColumnConfig(
      header: "No Polis",
      width: 140,
      getValue: (d) => d.noPolis,
    ),
    TableColumnConfig(
      header: "Object",
      width: 200,
      getValue: (d) => d.objectDesc,
    ),
    TableColumnConfig(
      header: "Curr",
      width: 70,
      getValue: (d) => d.currSimbol,
    ),
    TableColumnConfig(
      header: "Outstanding",
      width: 120,
      getValue: (d) => formatNum(d.dnOs),
      alignRight: true,
    ),
    TableColumnConfig(
      header: "Periode",
      width: 180,
      getValue: (d) =>
      "${d.polisMulai.toString().substring(0, 10)} → ${d.polisAkhir.toString().substring(0, 10)}",
    ),
  ];

  /// Default columns untuk Rincian
  List<TableColumnConfig> get _rincianColumns => [
    TableColumnConfig(
      header: "No",
      width: 50,
      getValue: (_) => "",
    ),
    TableColumnConfig(
      header: "No Polis",
      width: 140,
      getValue: (d) => d.noPolis,
    ),
    TableColumnConfig(
      header: "Object",
      width: 200,
      getValue: (d) => d.objectDesc,
    ),
    TableColumnConfig(
      header: "Curr",
      width: 70,
      getValue: (d) => d.currSimbol,
    ),
    TableColumnConfig(
      header: "Premi",
      width: 120,
      getValue: (d) => formatNum(d.dnOs),
      alignRight: true,
    ),
    TableColumnConfig(
      header: "Periode Polis",
      width: 180,
      getValue: (d) =>
      "${d.polisMulai.toString().substring(0, 10)} → ${d.polisAkhir.toString().substring(0, 10)}",
    ),
  ];

  List<TableColumnConfig> get _columns {
    if (customColumns != null) return customColumns!;

    switch (source) {
      case KonfirmasiSource.ringkasan:
        return _ringkasanColumns;
      case KonfirmasiSource.rincian:
        return _rincianColumns;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalOs = selectedItems.fold<num>(0, (s, e) => s + e.dnOs);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Konfirmasi Detail Polis"),
      ),
      body: BlocListener<DnRekap2invBloc, DnRekap2invState>(
        listener: (context, state) {
          if (state.isProcessed) {
            if (state.paymentStatus == "20") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Silakan lanjutkan ke metode pembayaran.'),
                ),
              );
              Navigator.pushNamed(context, '/payment-methods');
            } else if (state.paymentStatus == "30") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Silakan lakukan pembayaran.')),
              );
              Navigator.pushNamed(
                context,
                '/payment-process',
                arguments: {'viewMode': 'ubah', 'recordId': state.invoiceId},
              );
            } else if (state.paymentStatus == "40") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proses pembayaran berhasil.')),
              );
              Navigator.pushNamed(context, '/payment-success');
            } else if (state.paymentStatus == "91") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Proses pembayaran gagal. Silakan coba lagi.'),
                ),
              );
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.all(hPadding * 1.5),
          child: Column(
            children: [
              _buildInfoSource(context),
              const SizedBox(height: 16),
              Expanded(
                child: _buildTable(context),
              ),
              const SizedBox(height: 16),
              _buildSummary(context, totalOs),
              const SizedBox(height: 16),
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSource(BuildContext context) {
    String label;
    switch (source) {
      case KonfirmasiSource.ringkasan:
        label = "Data berasal dari Ringkasan";
        break;
      case KonfirmasiSource.rincian:
        label = "Data berasal dari Rincian Polis";
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: formGrey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: sGrey),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: primaryColor),
          const SizedBox(width: 8),
          Text(label, style: bodyTextStyle(context)),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: sGrey),
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Table(
              border: const TableBorder(
                horizontalInside: BorderSide(color: sGrey, width: 1),
                verticalInside: BorderSide(color: sGrey, width: 1),
              ),
              columnWidths: Map.fromEntries(
                _columns.asMap().entries.map(
                      (e) => MapEntry(e.key, FixedColumnWidth(e.value.width)),
                ),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _headerRow(context),
                ...selectedItems.asMap().entries.map(
                      (e) => _dataRow(context, e.key, e.value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _headerRow(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(color: formGrey),
      children: _columns
          .map(
            (col) => Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            col.header,
            style: bodyTextStyle(context, fontSize: 15),
          ),
        ),
      )
          .toList(),
    );
  }

  TableRow _dataRow(
      BuildContext context,
      int index,
      DnsppaCariModel d,
      ) {
    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? pGrey : Colors.white,
      ),
      children: _columns.asMap().entries.map((entry) {
        final colIndex = entry.key;
        final col = entry.value;

        // First column is always the row number
        if (colIndex == 0) {
          return _Cell("${index + 1}");
        }

        // All other cells are tappable
        return InkWell(
          onTap: () => _showPolisDetailDialog(context, d),
          child: _Cell(
            col.getValue(d),
            alignRight: col.alignRight,
            isClickable: true,
          ),
        );
      }).toList(),
    );
  }

  void _showPolisDetailDialog(BuildContext context, DnsppaCariModel polis) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Detail Polis"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(label: "No Polis", value: polis.noPolis),
              _DetailRow(label: "Object", value: polis.objectDesc),
              // _DetailRow(label: "Kategori", value: polis.cobNama ?? "-"),
              _DetailRow(label: "Currency", value: polis.currSimbol),
              _DetailRow(label: "Outstanding", value: formatNum(polis.dnOs)),
              _DetailRow(
                label: "Periode Mulai",
                value: polis.polisMulai.toString().substring(0, 10),
              ),
              _DetailRow(
                label: "Periode Akhir",
                value: polis.polisAkhir.toString().substring(0, 10),
              ),
              if (polis.sppa1Id.isNotEmpty)
                _DetailRow(label: "SPPA ID", value: polis.sppa1Id),
              if (polis.dn1Id.isNotEmpty)
                _DetailRow(label: "DN ID", value: polis.dn1Id),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, num totalOs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: sGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Outstanding",
                style: bodyTextStyle(context, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                "${selectedItems.length} Polis",
                style: bodyTextStyle(
                  context,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            "${selectedItems.first.currSimbol} ${formatNum(totalOs)}",
            style: bodyTextStyle(
              context,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.payment),
        label: const Text("Lanjut Pembayaran"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          // Trigger payment process based on source
          final listIds = selectedItems.map((e) {
            if (source == KonfirmasiSource.ringkasan) {
              return e.dn1Id;
            } else {
              return e.dn1Id;
            }
          }).join(";");

          if (source == KonfirmasiSource.ringkasan) {
            context.read<DnRekap2invBloc>().add(
              DnToInvByListCobProcessEvent(listCob: listIds),
            );
          } else {
            context.read<DnRekap2invBloc>().add(
              DnToInvByListDnProcessEvent(listDn: listIds),
            );
          }
        },
      ),
    );
  }
}

// ============================
// HELPER WIDGETS
// ============================
class _Cell extends StatelessWidget {
  final String text;
  final bool alignRight;
  final bool isClickable;

  const _Cell(
      this.text, {
        this.alignRight = false,
        this.isClickable = false,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: bodyTextStyle(
          context,
          fontSize: 14,
        ).copyWith(
          color: isClickable ? primaryColor : primaryLightColor,
          decoration: isClickable ? TextDecoration.underline : null,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: bodyTextStyle(context, fontSize: 14),
            ),
          ),
          const Text(": "),
          Expanded(
            child: Text(
              value,
              style: bodyTextStyle(context, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}