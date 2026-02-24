// import 'package:flutter/material.dart';
// import 'package:joss_app/pages/payment/mobile/detail/ringkasan/ringkasan_detail_page.dart';
// import '../../../../../common/constants.dart';
// import '../../../base/base_background_sidepage.dart';
//
// class TemplateDetailPage extends StatefulWidget {
//   final String? ringkasanId;
//   final String? rincianId;
//   final String? listcobId;
//
//   const TemplateDetailPage({
//     super.key,
//     this.ringkasanId,
//     this.rincianId,
//     this.listcobId,
//   });
//
//   @override
//   State<TemplateDetailPage> createState() => _TemplateDetailPageState();
// }
//
// class _TemplateDetailPageState extends State<TemplateDetailPage> {
//   @override
//   Widget build(BuildContext context) {
//     final Widget content = RingkasanDetailPage();
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: secondaryBlackColor,
//       body: SafeArea(
//         child: BaseBackgroundSidePage(
//           title: 'Konfirmasi Detail Polis',
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 content,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
