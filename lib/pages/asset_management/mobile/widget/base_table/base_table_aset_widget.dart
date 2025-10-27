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
    Widget child;

    if (_isRingkasan) {
      // child = const TableRingkasanWidget(initialStatusId: "10001");
      child = const TableRingkasanWidget();
    } else if (_isPar) {
      // child = const TableParWidget(initialStatusId: "10001");
      child = const TableParWidget();
    } else if (_isMv) {
      // child = const TableMvWidget(initialStatusId: "10001");
      child = const TableMvWidget();
    } else if (_isHealth) {
      // child = const TableHealthWidget(initialStatusId: "10001");
      child = const TableHealthWidget();
    } else {
      child = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              strokeWidth: 3,
            ),
            SizedBox(height: 12),
            Text(
              "Memuat data...",
              style: TextStyle(color: Colors.white70, fontSize: 14),
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
