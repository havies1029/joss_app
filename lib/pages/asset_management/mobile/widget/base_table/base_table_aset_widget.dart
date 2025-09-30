import 'package:flutter/material.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/table_form/table_health_widget.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/table_form/table_mv_widget.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/table_form/table_par_widget.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/base_table/table_form/table_ringkasan_widget.dart';

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
    Widget child;

    if (_isRingkasan) {
      child = const TableRingkasanWidget(initialStatusId: "10001");
    } else if (_isPar) {
      child = const TableParWidget(initialStatusId: "10002");
    } else if (_isMv) {
      child = const TableMvWidget(initialStatusId: "10003");
    } else if (_isHealth) {
      child = const TableHealthWidget(initialStatusId: "10005");
    } else {
      child = Padding(
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
      );
    }

    return Expanded(
      child: child,
    );
  }
}
