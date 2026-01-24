// import 'package:flutter/material.dart';
// import '../pages/asset_management/mobile/widget/base_table/tables/reusable_aset_table.dart';
// import '../pages/asset_management/mobile/widget/detail_management_page/detail_management_widget.dart';
// import '../pages/gen_endors/endors1crud_form.dart';
//
//   List<ActionButtonWidget> getActionButtonsByStatus(
//     String status, {
//       VoidCallback? onProcessTap,
//       String? namaItem,
//       BuildContext? context,
//       dynamic? itemData,
//     }) {
//   switch (status.toLowerCase()) {
//     case 'aktif':
//       return [
//         ActionButtonWidget(
//           asset: 'assets/icons/unduh_polis.svg',
//           label: 'Unduh Polis',
//           bgColor: const Color(0xFF37C76A),
//           onTap: () => debugPrint("Unduh Polis diklik"),
//         ),
//       ];
//
//     case 'diproses':
//       return [
//         ActionButtonWidget(
//           asset: 'assets/icons/lacak_polis.svg',
//           label: 'Lacak Polis',
//           bgColor: const Color(0xFF2F80ED),
//           onTap: () {
//             debugPrint("📡 Klik Lacak Polis untuk item: $namaItem");
//
//             if (context != null && itemData != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DetailManagementPolisPage(
//                     data: itemData,
//                   ),
//                 ),
//               );
//             }
//
//             onProcessTap?.call();
//           },
//         ),
//       ];
//
//     case 'jatuh tempo':
//     case 'berakhir':
//       return [
//         ActionButtonWidget(
//           asset: 'assets/icons/perpanjangan.svg',
//           label: 'Perpanjangan',
//           bgColor: const Color(0xFFFDC13C),
//           onTap: () => debugPrint("Perpanjangan diklik"),
//         ),
//       ];
//
//     case 'non aktif':
//       return [
//         ActionButtonWidget(
//           asset: 'assets/icons/aktifkan_kembali.svg',
//           label: 'Aktifkan Kembali',
//           bgColor: const Color(0xFFF85B5B),
//           onTap: () => debugPrint("Aktifkan Kembali diklik"),
//         ),
//         ActionButtonWidget(
//           asset: 'assets/icons/unduh_polis.svg',
//           label: 'Unduh Polis',
//           bgColor: const Color(0xFF37C76A),
//           onTap: () => debugPrint("Unduh Polis diklik"),
//         ),
//       ];
//
//     case 'tunggu pembayaran':
//       return [
//         // Tombol Lacak Polis
//         ActionButtonWidget(
//           asset: 'assets/icons/lacak_polis.svg',
//           label: 'Lacak Polis',
//           bgColor: const Color(0xFF2F80ED),
//           onTap: () {
//             debugPrint("📡 Klik Lacak Polis untuk item: $namaItem");
//
//             if (context != null && itemData != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DetailManagementPolisPage(
//                     data: itemData,
//                   ),
//                 ),
//               );
//             }
//
//             onProcessTap?.call();
//           },
//         ),
//
//         // Tombol Endorse
//         ActionButtonWidget(
//           asset: 'assets/icons/endorse.svg',
//           label: 'Endorse',
//           bgColor: const Color(0xFF00BBFF),
//           onTap: () {
//             debugPrint("🧾 Klik Endorse untuk item: $namaItem");
//
//             if (context != null && itemData != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Endors1CrudFormPage(
//                     viewMode: "tambah",
//                     recordId: "",
//                     data: itemData,
//                     pageTitle: "Endorse",
//                   ),
//                 ),
//               );
//             }
//
//             onProcessTap?.call();
//           },
//         ),
//         ActionButtonWidget(
//           asset: 'assets/icons/endorse.svg',
//           label: 'Perpanjangan',
//           bgColor: const Color(0xFF00BBFF),
//           onTap: () {
//             debugPrint("🧾 Klik Endorse untuk item: $namaItem");
//
//             if (context != null && itemData != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Endors1CrudFormPage(
//                     viewMode: "tambah",
//                     recordId: "",
//                     data: itemData,
//                     pageTitle: "Perpanjangan",
//                   ),
//                 ),
//               );
//             }
//
//             onProcessTap?.call();
//           },
//         ),
//         ActionButtonWidget(
//           asset: 'assets/icons/endorse.svg',
//           label: 'Aktifkan kembali',
//           bgColor: const Color(0xFF00BBFF),
//           onTap: () {
//             debugPrint("🧾 Klik Endorse untuk item: $namaItem");
//
//             if (context != null && itemData != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Endors1CrudFormPage(
//                     viewMode: "tambah",
//                     recordId: "",
//                     data: itemData,
//                     pageTitle: "Aktifkan kembali",
//                   ),
//                 ),
//               );
//             }
//
//             onProcessTap?.call();
//           },
//         ),
//       ];
//
//     default:
//       return [];
//   }
// }
//
//
