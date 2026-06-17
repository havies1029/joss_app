import 'package:joss_app/models/klaimlacak/klaim_progress_jadwal_bayar_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KlaimLacakJadwal extends StatelessWidget {
  final List<KlaimProgressJadwalBayarModel> items;

  const KlaimLacakJadwal({
    super.key,
    required this.items,
  });

  String _formatPercent(double v) {
    final isInt = v % 1 == 0;
    return isInt ? '${v.toInt()}%' : '${v.toStringAsFixed(1)}%';
  }

  String _formatMoney(String curr, double value) {
    final f = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '$curr ',
      decimalDigits: 2,
    );
    return f.format(value);
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.white.withOpacity(0.12);
    final headerBg = Colors.white.withOpacity(0.06);
    final rowBg = Colors.white.withOpacity(0.03);
    final textColor = Colors.white.withOpacity(0.92);

    // Lebar fixed per kolom supaya bisa horizontal scroll
    const double colNama = 160;
    const double colJenisPenggantian = 150;
    const double colShare = 70;
    const double colNilai = 150;
    const double colTanggal = 110;

    const double totalWidth =
        colNama + colJenisPenggantian + colShare + colNilai + colTanggal;

    Widget buildHeader() => Container(
      color: headerBg,
      child: Row(
        children: [
          _Cell('NAMA TERTANGGUNG', width: colNama, isHeader: true, borderColor: borderColor),
          _Cell('JENIS PENGGANTIAN', width: colJenisPenggantian, isHeader: true, borderColor: borderColor),
          _Cell('SHARE', width: colShare, isHeader: true, borderColor: borderColor),
          _Cell('NILAI KLAIM', width: colNilai, isHeader: true, borderColor: borderColor),
          _Cell('TANGGAL BAYAR', width: colTanggal, isHeader: true, borderColor: borderColor),
        ],
      ),
    );

    Widget buildRow(KlaimProgressJadwalBayarModel it, int i) => Container(
      decoration: BoxDecoration(
        color: i.isEven ? rowBg : Colors.transparent,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          _Cell(it.penanggung, width: colNama, color: textColor, borderColor: borderColor),
          _Cell(it.metodeBayar, width: colJenisPenggantian, color: textColor, borderColor: borderColor),
          _Cell(_formatPercent(it.sharePersen), width: colShare, color: textColor, borderColor: borderColor),
          _Cell(_formatMoney(it.curr, it.nilaiBayar), width: colNilai, color: textColor, borderColor: borderColor),
          _Cell(_formatDate(it.jadwalBayar), width: colTanggal, color: textColor, borderColor: borderColor),
        ],
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: totalWidth,
            child: Column(
              children: [
                buildHeader(),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      'Tidak ada jadwal bayar',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  ...List.generate(items.length, (i) => buildRow(items[i], i)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final double width;
  final bool isHeader;
  final Color? color;
  final Color borderColor;

  const _Cell(
      this.text, {
        required this.width,
        required this.borderColor,
        this.isHeader = false,
        this.color,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: isHeader
          ? const EdgeInsets.all(15)
          : const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        softWrap: true,
        style: isHeader
            ? TextStyle(
          color: Colors.white.withOpacity(0.85),
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        )
            : TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          height: 1.25,
        ),
      ),
    );
  }
}