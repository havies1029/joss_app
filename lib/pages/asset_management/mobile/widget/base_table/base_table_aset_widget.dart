import 'package:flutter/material.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/table_form/table_health_widget.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/table_form/table_mv_widget.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/table_form/table_par_widget.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/table_form/table_ringkasan_widget.dart';
import '../../../../../common/constants.dart';
class BaseTableAsetWidget extends StatelessWidget {
  final String? cobId;
  final String? cobNama;

  const BaseTableAsetWidget({
    super.key,
    this.cobId,
    this.cobNama,
  });

  bool get _isRingkasan => cobId == "10001" && cobNama == "Ringkasan";
  bool get _isPar => cobId == "10002" && cobNama == "Properti";
  bool get _isMv => cobId == "10003" && cobNama == "Kendaraan";
  bool get _isHealth => cobId == "10005" && cobNama == "Kesehatan";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: hPadding, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info COB
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              (cobId != null && cobNama != null)
                  ? "COB: $cobNama (ID: $cobId)"
                  : "Belum ada COB dipilih",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          // Konten
          if (_isRingkasan)
          // kasih tinggi biar child list gak unbounded
            TableRingkasanWidget(
              listHeight: 400, // atur sesuai desain lu
              padding: const EdgeInsets.only(top: 4),
              initialStatusId: "10001",
            )
          else if (_isPar)
            TableParWidget(
              listHeight: 400, // atur sesuai desain lu
              padding: const EdgeInsets.only(top: 4),
              initialStatusId: "10002",
            )
          else if (_isMv)
            TableMvWidget(
              listHeight: 400, // atur sesuai desain lu
              padding: const EdgeInsets.only(top: 4),
              initialStatusId: "10003",
            )
          else if (_isHealth)
            TableHealthWidget(
              listHeight: 400, // atur sesuai desain lu
              padding: const EdgeInsets.only(top: 4),
              initialStatusId: "10005",
            )
          else
          // placeholder ringan
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, size: 18, color: Colors.white70),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Pilih COB ‘Ringkasan’ untuk melihat tabel ringkasan.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
