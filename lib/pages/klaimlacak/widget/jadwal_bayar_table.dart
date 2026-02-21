import 'package:joss_app/models/klaimlacak/klaim_progress_jadwal_bayar_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JadwalBayarTable extends StatelessWidget {
  final List<KlaimProgressJadwalBayarModel> items;

  const JadwalBayarTable({
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
    return DateFormat('dd/MM/yyyy').format(dt); // ✅ full year
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.white.withOpacity(0.12);
    final headerBg = Colors.white.withOpacity(0.06);
    final rowBg = Colors.white.withOpacity(0.03);
    final textColor = Colors.white.withOpacity(0.92);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ===== Header =====
          Container(
            color: headerBg,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: const [
                _HeaderCell('NAMA TERTANGGUNG', flex: 5),
                _HeaderCell('SHARE', flex: 2, align: TextAlign.center),
                _HeaderCell('NILAI KLAIM', flex: 4),
                _HeaderCell('TANGGAL BAYAR', flex: 3, align: TextAlign.center), // ✅ lebih lebar
              ],
            ),
          ),

          // ===== Rows =====
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                'Tidak ada jadwal bayar',
                style: TextStyle(color: Colors.white70),
              ),
            )
          else
            ...List.generate(items.length, (i) {
              final it = items[i];
              return Container(
                decoration: BoxDecoration(
                  color: i.isEven ? rowBg : Colors.transparent,
                  border: Border(top: BorderSide(color: borderColor)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Row(
                  children: [
                    _BodyCell(it.penanggung, flex: 5, color: textColor),
                    _BodyCell(
                      _formatPercent(it.sharePersen),
                      flex: 2,
                      align: TextAlign.center,
                      color: textColor,
                      maxLines: 1,
                    ),
                    _BodyCell(
                      _formatMoney(it.curr, it.nilaiBayar),
                      flex: 4,
                      color: textColor,
                      maxLines: 1,
                    ),
                    _BodyCell(
                      _formatDate(it.jadwalBayar),
                      flex: 3, // ✅ lebih lebar
                      align: TextAlign.center,
                      color: textColor,
                      maxLines: 1, // ✅ jangan pecah
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  final TextAlign align;

  const _HeaderCell(
    this.text, {
    required this.flex,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.white.withOpacity(0.12);
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: borderColor)),
        ),
        child: Text(
          text,
          textAlign: align,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  final String text;
  final int flex;
  final TextAlign align;
  final Color color;
  final int maxLines;

  const _BodyCell(
    this.text, {
    required this.flex,
    this.align = TextAlign.left,
    required this.color,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.white.withOpacity(0.12);
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: borderColor)),
        ),
        child: Text(
          text,
          textAlign: align,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}
