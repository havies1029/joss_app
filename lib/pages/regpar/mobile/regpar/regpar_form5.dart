// import 'package:flutter/material.dart';
// import 'package:joss_app/common/constants.dart';
//
//
// class RegparForm6Section extends StatefulWidget {
//   final bool isExpanded;
//
//   /// PARAMETER BARU — supaya parent bisa kirim kumpulan data
//   final Map<String, dynamic>? initialPayload;
//
//   const RegparForm6Section({
//     super.key,
//     required this.isExpanded,
//     this.initialPayload,
//   });
//
//   @override
//   State<RegparForm6Section> createState() => RegparForm6SectionState();
// }
//
//
// class RegparForm6SectionState extends State<RegparForm6Section> {
//   final diskonPremiCtrl = TextEditingController();
//   final netCtrl = TextEditingController();
//   final subtotalCtrl = TextEditingController();
//
//   Map<String, dynamic>? _lastPayload;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Jika parent pertama kali ngirim payload → inject
//     if (widget.initialPayload != null) {
//       injectPayload(widget.initialPayload!);
//     }
//   }
//
//   @override
//   void dispose() {
//     diskonPremiCtrl.dispose();
//     netCtrl.dispose();
//     subtotalCtrl.dispose();
//     super.dispose();
//   }
//
//   void injectPayload(Map<String, dynamic> payload) {
//     _lastPayload = payload;
//
//     setState(() {
//       diskonPremiCtrl.text = payload["diskonPremi"]?.toString() ?? "0";
//       netCtrl.text = payload["netPremi"]?.toString() ?? "0";
//       subtotalCtrl.text = payload["subtotalPremi"]?.toString() ?? "0";
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: pGrey,
//       child: Column(
//         children: [
//           ListTile(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//             title: Text(
//               'Hasil Perhitungan Premi',
//               style: bodyTextStyle(context),
//             ),
//             trailing: AnimatedRotation(
//               turns: widget.isExpanded ? 0.5 : 0.0,
//               duration: const Duration(milliseconds: 250),
//               child: const Icon(
//                 Icons.keyboard_arrow_down,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             onTap: () {
//               // toggle kalau nanti mau
//             },
//           ),
//
//           if (widget.isExpanded)
//             Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
//               child: Column(
//                 children: [
//                   appTextField(
//                     label: 'Subtotal Premi',
//                     controller: subtotalCtrl,
//                     enabled: false,
//                   ),
//
//                   const SizedBox(height: hPadding * 1.5),
//
//                   appTextField(
//                     label: 'Premi Diskon',
//                     controller: diskonPremiCtrl,
//                     enabled: false,
//                   ),
//
//                   const SizedBox(height: hPadding * 1.5),
//
//                   appTextField(
//                     label: 'Premi Bersih',
//                     controller: netCtrl,
//                     enabled: false,
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }