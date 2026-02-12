// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:pdfx/pdfx.dart';
// import 'package:joss_app/models/regklaim/attachment_item.dart';
//
// void openPreview(BuildContext context, AttachmentItem item) {
//   if (item.isImage) {
//     Navigator.push(context, MaterialPageRoute(builder: (_) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(backgroundColor: Colors.black),
//         body: Center(
//           child: InteractiveViewer(child: Image.file(File(item.path))),
//         ),
//       );
//     }));
//     return;
//   }
//
//   if (item.isPdf) {
//     Navigator.push(context, MaterialPageRoute(builder: (_) {
//       return PdfPreviewPage(path: item.path);
//     }));
//   }
// }
//
// class PdfPreviewPage extends StatelessWidget {
//   final String path;
//   const PdfPreviewPage({super.key, required this.path});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = PdfControllerPinch(
//       document: PdfDocument.openFile(path),
//     );
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Preview PDF")),
//       body: PdfViewPinch(
//         controller: controller,
//       ),
//     );
//   }
// }
