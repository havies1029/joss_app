import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/management_polis/detail_management_page/polis_card_page/polis_detail_health.dart';
import 'package:joss_app/pages/management_polis/detail_management_page/polis_card_page/polis_detail_hull.dart';
import 'package:joss_app/pages/management_polis/detail_management_page/polis_card_page/polis_detail_mv.dart';
import 'package:joss_app/pages/management_polis/detail_management_page/polis_card_page/polis_detail_others.dart';
import 'package:joss_app/pages/management_polis/detail_management_page/polis_card_page/polis_detail_par.dart';
import 'package:joss_app/pages/management_polis/detail_management_page/polis_card_page/polis_detail_ringkasan.dart';

class PolisDetailCard extends StatelessWidget {
  final Map<String, dynamic> dataMap;
  final String cobId;
  final String? title;

  /// fallback only (dipakai kalau cobId tidak kita mapping)
  final Set<String> excludeKeys;

  final Color cardColor;
  final Color borderColor;
  final Color dividerColor;
  final Color labelColor;
  final Color valueColor;
  final double borderRadius;

  final double Function(BuildContext context, double base) fontSize;

  const PolisDetailCard({
    super.key,
    required this.dataMap,
    required this.cobId,
    this.title,
    this.excludeKeys = const {},
    required this.cardColor,
    required this.borderColor,
    required this.dividerColor,
    required this.labelColor,
    required this.valueColor,
    required this.borderRadius,
    required this.fontSize,
  });

  void _navigateByCobId(BuildContext context) {
    if (cobId.trim().isEmpty) return;

    late final Widget page;
    switch (cobId) {
      case "10001":
        page = PolisDetailRingkasan(dataMap: dataMap);
        break;
      case "10002":
        page = PolisDetailPar(dataMap: dataMap);
        break;
      case "10003":
        page = PolisDetailMv(dataMap: dataMap);
        break;
      case "10004":
        page = PolisDetailHull(dataMap: dataMap);
        break;
      case "10005":
        page = PolisDetailHealth(dataMap: dataMap);
        break;
      default:
        page = PolisDetailOthers(dataMap: dataMap);
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  /// ====== CARD ROWS (harus sama dengan yang ditampilkan di page detail / header table) ======
  List<MapEntry<String, String>> _rowsForCard() {
    String s(String key) =>
        (dataMap[key]
            ?.toString()
            .trim()
            .isNotEmpty ?? false)
            ? dataMap[key].toString().trim()
            : "-";

    String periode() {
      final mulai = _formatDate(dataMap["periodeMulai"]);
      final akhir = _formatDate(dataMap["periodeAkhir"]);
      if (mulai == "-" && akhir == "-") return "-";
      return "$mulai - $akhir";
    }

    String money(String valueKey) {
      final c = s("curr");
      final n = _formatNum(_toNum(dataMap[valueKey]));
      if (c == "-" && n == "0") return "-";
      if (c == "-") return n;
      return "$c $n";
    }

    // NOTE:
    // - PAR (10002): No Proses, No Polis, Tertanggung, Alamat, Periode, Nilai Pertanggungan, Premi
    // - MV  (10003): Tertanggung, Periode, Merk, Nomor Polisi, Nilai Pertanggungan, Premi
    switch (cobId) {
      case "10002": // PAR
        return [
          MapEntry("No Proses", s("prosesId")),
          MapEntry("No Polis", s("polisNo")),
          MapEntry("Tertanggung", s("tertanggung")),
          MapEntry("Alamat", s("alamat")),
          MapEntry("Periode", periode()),
          MapEntry("Nilai Pertanggungan", money("sumInsured")),
          MapEntry("Premi", money("premi")),
        ];

      case "10003": // MV
        return [
          MapEntry("Tertanggung", s("tertanggung")),
          MapEntry("Periode", periode()),
          MapEntry("Merk", s("merk")),
          MapEntry("Nomor Polisi", s("noPolisi")),
          MapEntry("Nilai Pertanggungan", money("sumInsured")),
          MapEntry("Premi", money("premi")),
        ];

      case "10004": // HULL (header table: Tertanggung, Detail Rangka Kapal, Nilai Tertanggung, Premi)
        return [
          MapEntry("Tertanggung", s("tertanggung")),
          MapEntry("Detail Rangka Kapal", s("namaKapal")),
          MapEntry("Nilai Tertanggung", money("tsi")),
          MapEntry("Premi", money("premi")), // ✅ plus curr udah dari money()
        ];

      case "10005": // HEALTH (header table: Nama, Benefit)
        return [
          MapEntry("Nama", s("nama")),
          MapEntry("Benefit", s("status")), // table benefit = status
        ];

      default:
      // OTHERS (header table: Object, Polis No, Sum Insured, Premi)
      // Kalau kamu mau "Others" selalu pakai 4 field ini (bukan fallback entries),
      // pakai return ini.
        return [
          MapEntry("Object", s("objectDesc")),
          MapEntry("Polis No", s("polisNo")),
          MapEntry("Sum Insured", money("sumInsured")),
          MapEntry("Premi", money("premi")),
        ];

    // --- kalau kamu masih mau fallback entries untuk cobId lain beneran unknown,
    // ganti "default" jadi:
    //
    // default:
    //   final entries = dataMap.entries.where((e) {
    //     if (e.key == "no") return false;
    //     if (excludeKeys.contains(e.key)) return false;
    //     final value = e.value?.toString().trim() ?? "";
    //     if (value.isEmpty || value == "-" || value.toLowerCase() == "null") return false;
    //     return true;
    //   }).toList();
    //
    //   return entries
    //     .map((e) => MapEntry(_beautifyKey(e.key), e.value?.toString() ?? "-"))
    //     .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasCobId = cobId.trim().isNotEmpty;
    final rows = _rowsForCard()
        .where((r) => !_isEmptyValue(r.value))
        .toList();

    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      // onTap: hasCobId ? () => _navigateByCobId(context) : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  color: valueColor,
                  fontSize: fontSize(context, 16),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
            ],

            /// NO (FIXED)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "No:",
                  style: TextStyle(
                    color: primaryLightColor,
                    fontSize: fontSize(context, 16),
                  ),
                ),
                Text(
                  dataMap["no"]?.toString() ?? "1",
                  style: TextStyle(
                    color: valueColor,
                    fontSize: fontSize(context, 16),
                  ),
                ),
              ],
            ),

            Divider(color: dividerColor, height: 20),

            /// KEY VALUE LIST (sesuai mapping cobId)
            ...rows.map((row) => _kvRow(
              context: context,
              label: row.key,
              value: row.value,
            )),
          ],
        ),
      ),
    );
  }

  Widget _kvRow({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: TextStyle(
                color: labelColor,
                fontSize: fontSize(context, 16),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: valueColor,
                  fontSize: fontSize(context, 16),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static bool _isEmptyValue(String v) {
    final t = v.trim();
    return t.isEmpty || t == "-" || t.toLowerCase() == "null";
  }

  static num _toNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    final s = v.toString().replaceAll(',', '').trim();
    return num.tryParse(s) ?? 0;
  }

  static String _formatNum(num v) => NumberFormat.decimalPattern().format(v);

  static String _formatDate(dynamic value) {
    if (value == null) return "-";
    if (value is DateTime) return DateFormat("dd MMM yyyy").format(value);

    // kalau server udah kasih string tanggal yang rapi, pakai apa adanya
    final s = value.toString().trim();
    return s.isEmpty ? "-" : s;
  }

  static String _beautifyKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}')
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((w) => w.isEmpty
        ? ''
        : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }
}
