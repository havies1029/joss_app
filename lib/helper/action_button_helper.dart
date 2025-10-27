import 'package:flutter/material.dart';
import 'package:joss_app/pages/asset_management/mobile/widget/endorsement_management_page/endorsement_management_widget.dart';
import '../pages/asset_management/mobile/widget/base_table/tables/reusable_aset_table.dart';
import '../pages/asset_management/mobile/widget/detail_management_page/detail_management_widget.dart';

List<ActionButtonWidget> getActionButtonsByStatus(
    String status, {
      VoidCallback? onProcessTap,
      String? namaItem,
      BuildContext? context, // ✅ tambahkan context biar bisa navigasi
      dynamic? itemData,
    }) {
  switch (status.toLowerCase()) {
    case 'aktif':
      return [
        ActionButtonWidget(
          asset: 'assets/icons/unduh_polis.svg',
          label: 'Unduh Polis',
          bgColor: const Color(0xFF37C76A),
          onTap: () => debugPrint("Unduh Polis diklik"),
        ),
        ActionButtonWidget(
          asset: 'assets/icons/endorse.svg',
          label: 'Endorse',
          bgColor: const Color(0xFF00BBFF),
          onTap: () {
            debugPrint("📡 Klik Lacak Polis untuk item: $namaItem");

            if (context != null && itemData != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EndorsementManagementPage(
                    data: itemData, // kirim seluruh objek
                  ),
                ),
              );
            }

            if (onProcessTap != null) onProcessTap();
          },
        ),
      ];

    case 'diproses':
      return [
        ActionButtonWidget(
          asset: 'assets/icons/lacak_polis.svg',
          label: 'Lacak Polis',
          bgColor: const Color(0xFF2F80ED),
          onTap: () {
            debugPrint("📡 Klik Lacak Polis untuk item: $namaItem");

            if (context != null && itemData != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailManagementPolisPage(
                    data: itemData, // kirim seluruh objek
                  ),
                ),
              );
            }

            if (onProcessTap != null) onProcessTap();
          },
        ),
      ];

    case 'jatuh tempo':
      return [
        ActionButtonWidget(
          asset: 'assets/icons/perpanjangan.svg',
          label: 'Perpanjangan',
          bgColor: const Color(0xFFFDC13C),
          onTap: () => debugPrint("Perpanjangan diklik"),
        ),
      ];

    case 'berakhir':
      return [
        ActionButtonWidget(
          asset: 'assets/icons/perpanjangan.svg',
          label: 'Perpanjangan',
          bgColor: const Color(0xFFFDC13C),
          onTap: () => debugPrint("Perpanjangan diklik"),
        ),
      ];

    case 'non aktif':
      return [
        ActionButtonWidget(
          asset: 'assets/icons/aktifkan_kembali.svg',
          label: 'Aktifkan Kembali',
          bgColor: const Color(0xFFF85B5B),
          onTap: () => debugPrint("Aktifkan Kembali diklik"),
        ),
        ActionButtonWidget(
          asset: 'assets/icons/unduh_polis.svg',
          label: 'Unduh Polis',
          bgColor: const Color(0xFF37C76A),
          onTap: () => debugPrint("Unduh Polis diklik"),
        ),
      ];

    default:
      return [];
  }
}
