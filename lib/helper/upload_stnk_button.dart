// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:joss_app/common/constants.dart';
//
// import '../apis/gen_regmv/regmv4form_api.dart';
//
// class UploadStnkButton extends StatefulWidget {
//   final String regmv1Id;
//
//   const UploadStnkButton({
//     super.key,
//     required this.regmv1Id,
//   });
//
//   @override
//   State<UploadStnkButton> createState() => _UploadStnkButtonState();
// }
//
// class _UploadStnkButtonState extends State<UploadStnkButton> {
//   bool _isLoading = false;
//   String? _fileName;
//
//   Future<void> _pickAndUpload() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? file = await picker.pickImage(source: ImageSource.gallery);
//
//     if (file == null) return;
//
//     setState(() {
//       _isLoading = true;
//       _fileName = file.name;
//     });
//
//     final Uint8List bytes = await file.readAsBytes();
//
//     /// CALL API
//     final api = Regmv4FormAPI();
//     final result = await api.uploadBinaryFotoSTNK(
//       widget.regmv1Id,
//       _fileName!,
//       bytes,
//     );
//
//     setState(() => _isLoading = false);
//
//     if (result.success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Foto STNK berhasil diupload")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Upload gagal, coba lagi")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       onPressed: _isLoading ? null : _pickAndUpload,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//       icon: _isLoading
//           ? const SizedBox(
//         height: 18,
//         width: 18,
//         child: CircularProgressIndicator(
//           strokeWidth: 2,
//           color: Colors.white,
//         ),
//       )
//           : const Icon(Icons.upload_file, color: Colors.white),
//       label: Text(
//         _isLoading
//             ? "Mengupload..."
//             : (_fileName != null ? "Reupload Foto STNK" : "Upload Foto STNK"),
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }
