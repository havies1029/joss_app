// // lib/pages/gen_klaim/klaim1_inline_editor_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/blocs/gen_klaim/klaim1list_bloc.dart';
// import 'package:joss_app/blocs/gen_klaim/klaim1crud_bloc.dart';
// import 'package:joss_app/pages/gen_klaim/mobile/widget/list_klaim_widget/klaim2list_timeline.dart';
//
// import 'klaim1_add_form_card.dart';
// import 'klaim1_list_editor.dart';
//
//
// class Klaim1InlineEditorPage extends StatefulWidget {
//   const Klaim1InlineEditorPage({super.key});
//
//   @override
//   State<Klaim1InlineEditorPage> createState() => _Klaim1InlineEditorPageState();
// }
//
// class _Klaim1InlineEditorPageState extends State<Klaim1InlineEditorPage> {
//   final _scrollCtr = ScrollController();
//   bool _showAddForm = false;
//   bool _isSavingNew = false;
//   final Map<String, bool> _isSavingById = {};
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<Klaim1ListBloc>().add(FetchKlaim1ListEvent());
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollCtr.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final content = BlocListener<Klaim1CrudBloc, Klaim1CrudState>(
//       listener: (context, state) {
//         if (state.isSaved) {
//           context.read<Klaim1ListBloc>().add(FetchKlaim1ListEvent());
//           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan')));
//           setState(() {
//             _isSavingNew = false;
//             _isSavingById.clear();
//             _showAddForm = false;
//           });
//         } else if (state.hasFailure) { // pastikan field ini ada di state kamu
//           setState(() {
//             _isSavingNew = false;
//             _isSavingById.updateAll((_, __) => false);
//           });
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan data')));
//         }
//       },
//       child: SingleChildScrollView(
//         controller: _scrollCtr,
//         padding: EdgeInsets.fromLTRB(hPadding, 24, hPadding, 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Header
//             Padding(
//               padding: EdgeInsets.only(bottom: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Informasi Klaim',
//                       style: TextStyle(fontSize: getResponsiveFont(context, 22), fontWeight: FontWeight.w600, color: primaryLightColor)),
//                   Text('Data klaim utama: tertanggung, lokasi, tanggal kejadian, jumlah, mata uang, dan status.',
//                       style: TextStyle(fontSize: getResponsiveFont(context, 16), color: sGrey, height: 1.3)),
//                 ],
//               ),
//             ),
//
//             // List Editor
//             Klaim1ListEditor(
//               isSavingById: _isSavingById,
//               onSaveExisting: (id, record) {
//                 setState(() => _isSavingById[id] = true);
//                 context.read<Klaim1CrudBloc>().add(Klaim1CrudUbahEvent(record: record));
//               },
//               onDelete: (id) {
//                 context.read<Klaim1CrudBloc>().add(Klaim1CrudHapusEvent(recordId: id));
//               },
//               onView: (id) {
//                 Navigator.of(context).push(MaterialPageRoute(builder: (_) => Klaim2ListTimeline(klaim1Id: id,)));
//               },
//             ),
//
//             const SizedBox(height: 8),
//
//             // Add section
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 200),
//               transitionBuilder: (child, anim) => SizeTransition(sizeFactor: anim, child: child),
//               child: _showAddForm
//                   ? Klaim1AddFormCard(
//                 key: const ValueKey('add-form'),
//                 isSaving: _isSavingNew,
//                 onSave: (record) {
//                   setState(() => _isSavingNew = true);
//                   context.read<Klaim1CrudBloc>().add(Klaim1CrudTambahEvent(record: record));
//                 },
//                 onCancel: () => setState(() => _showAddForm = false),
//               )
//                   : SizedBox(
//                 key: const ValueKey('add-button'),
//                 width: double.infinity,
//                 height: 56,
//                 child: AppButton.iconLeft(
//                   text: 'Tambah Klaim',
//                   icon: const Icon(Icons.add, size: 20),
//                   onPressed: () async {
//                     setState(() => _showAddForm = true);
//                     await Future.delayed(const Duration(milliseconds: 50));
//                     if (mounted) {
//                       _scrollCtr.animateTo(
//                         _scrollCtr.position.maxScrollExtent,
//                         duration: const Duration(milliseconds: 250),
//                         curve: Curves.easeOut,
//                       );
//                     }
//                   },
//                   backgroundColor: primaryColor,
//                   iconTextSpacing: 10,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: primaryBlackColor,
//       body: SafeArea(
//         child: Container(
//           decoration: const BoxDecoration(
//             color: secondaryBlackColor,
//             borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//             border: Border(top: BorderSide(color: primaryColor, width: 4.0)),
//           ),
//           child: content,
//         ),
//       ),
//     );
//   }
// }
//

// lib/pages/gen_klaim/klaim1_inline_editor_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/blocs/gen_klaim/klaim1list_bloc.dart';
import 'package:joss_app/blocs/gen_klaim/klaim1crud_bloc.dart';
import 'package:joss_app/pages/gen_klaim/mobile/widget/list_klaim_widget/timeline_card_widget.dart';

import '../../../../../blocs/gen_klaim/klaim1list_bloc.dart';
import '../../../../../widgets/apptheme/header_card.dart';
import 'klaim1_add_form_card.dart';
import 'klaim1_list_editor.dart';

class Klaim1InlineEditorPage extends StatefulWidget {
  const Klaim1InlineEditorPage({super.key});

  @override
  State<Klaim1InlineEditorPage> createState() => _Klaim1InlineEditorPageState();
}

class _Klaim1InlineEditorPageState extends State<Klaim1InlineEditorPage> {
  final _scrollCtr = ScrollController();
  final bool _showAddForm = false;
  bool _isSavingNew = false;
  final Map<String, bool> _isSavingById = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Klaim1ListBloc>().add(FetchKlaim1ListEvent());
    });
  }

  @override
  void dispose() {
    _scrollCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocListener<Klaim1CrudBloc, Klaim1CrudState>(
          listener: (context, state) {
            if (state.isSaved) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(successSnackBar('Data berhasil disimpan'));
              setState(() => _isSavingNew = false);
            } else if (state.hasFailure) {
              setState(() => _isSavingNew = false);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(errorSnackBar('Gagal menyimpan data'));
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeaderCard(
                  iconPath: "assets/icons/menu_lapor_klaim.svg",
                  title: "Lapor Klaim",
                  subtitle:
                      "Pilih kategori asuransi untuk keamanan Anda dan keluarga, Yuk!",
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: vPadding,
                  ),
                  decoration: const BoxDecoration(color: secondaryBlackColor),
                  child: Klaim1AddFormCard(
                    isSaving: _isSavingNew,
                    onSave: (record) {
                      setState(() => _isSavingNew = true);
                      context.read<Klaim1CrudBloc>().add(
                        Klaim1CrudTambahEvent(record: record),
                      );
                    },
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
