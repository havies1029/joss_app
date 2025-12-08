// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/widgets/form_error.dart';
// import 'package:intl/intl.dart';
// import 'package:joss_app/common/thousand_separator_input_formatter.dart';
// import 'package:dropdown_search/dropdown_search.dart';
//
// import '../../../../blocs/regpar/regpar6form_bloc.dart';
//
// class RegparForm6Section extends StatefulWidget {
//   final String viewMode;
//   final String recordId;
//   final bool isExpanded;
//   final Function(bool) onToggle;
//   final String? regpar1Id;
//
//   const RegparForm6Section({super.key, required this.viewMode, required this.isExpanded, required this.onToggle, this.recordId, this.regpar1Id});
//
//   @override
//   RegparForm6SectionState createState() => RegparForm6SectionState();
// }
//
// class RegparForm6SectionState extends State<RegparForm6Section> {
//
//   final _regparform6key = GlobalKey<FormState>();
//   bool _showError = false;
//   List<Uint8List> _images = [];
//   List<String> _fileNames = [];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Regpar6FormBloc, Regpar6FormState>(
//       builder: (context, state) {
//         // if (state is UploadFotoAccPreview) {
//         //   if (!_fileNames.contains(state.fileName)) {
//         //     _images.add(state.imageBytes);
//         //     _fileNames.add(state.fileName);
//         //   }
//         // }
//
//         return Card(
//           color: pGrey,
//           child: Column(
//             children: [
//               _buildHeader(),
//               if (widget.isExpanded) _buildForm(),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildHeader() {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//       title: Text("Foto Bangunan", style: bodyTextStyle(context)),
//       trailing: AnimatedRotation(
//         turns: widget.isExpanded ? 0.5 : 0,
//         duration: const Duration(milliseconds: 250),
//         child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
//       ),
//       onTap: () {
//         widget.onToggle(!widget.isExpanded);
//       },
//     );
//   }
//
//   Widget _buildForm() {
//     return Padding(
//       padding: const EdgeInsets.only(
//         left: hPadding,
//         right: hPadding,
//         bottom: hPadding,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _uploadInstructionBox(),
//         ],
//       ),
//     );
//   }
//
// }