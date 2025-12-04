// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../blocs/regpar/regpar1crud_bloc.dart';
// import '../../../../common/constants.dart';
// import '../../../../models/regpar/regpar1crud_model.dart';
//
// class RegparForm1Section extends StatefulWidget {
//   final String viewMode;
//   final String? calmv1Id;
//   final String? recordId;
//   final bool isExpanded;
//   final Function(bool) onToggle;
//
//   const RegparForm1Section({
//     super.key,
//     required this.viewMode,
//     required this.isExpanded,
//     required this.onToggle,
//     this.calmv1Id,
//     this.recordId,
//   });
//
//   @override
//   State<RegparForm1Section> createState() => RegparForm1SectionState();
// }
//
//
// class RegparForm1SectionState extends State<RegparForm1Section> {
//   final _regparform1key = GlobalKey<FormState>();
//
//   // Controllers
//   final fieldTtgAlamatController = TextEditingController();
//   final fieldTtgNamaController = TextEditingController();
//
//   late final Regpar1CrudBloc regpar1Bloc;
//
//   @override
//   void initState() {
//     super.initState();
//     regpar1Bloc = context.read<Regpar1CrudBloc>();
//     Future.microtask(_loadData);
//   }
//
//   void _loadData() {
//     if (widget.viewMode == "ubah" && widget.recordId != null) {
//       regpar1Bloc.add(Regpar1CrudLihatEvent(recordId: widget.recordId!));
//     }
//   }
//
//
//   @override
//   void dispose() {
//     fieldTtgAlamatController.dispose();
//     fieldTtgNamaController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<Regpar1CrudBloc, Regpar1CrudState>(
//       listenWhen: (prev, curr) =>
//       prev.isLoaded != curr.isLoaded && curr.isLoaded == true,
//       listener: (context, state) {
//         if (state.record != null) {
//           _injectPayload(state.record!);
//         }
//       },
//       child: Card(
//         color: pGrey,
//         child: Column(
//           children: [
//             _buildHeader(),
//             if (widget.isExpanded) _buildForm(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _injectPayload(Regpar1CrudModel record) {
//     debugPrint("🔥 [Form2] Injecting payload...");
//
//     // Numeric Controllers
//     fieldTtgNamaController.text = record.ttgNama.toString();
//     fieldTtgAlamatController.text = record.ttgAlamat.toString();;
//
//     setState(() {});
//   }
//
//   Widget _buildHeader() {
//     return ListTile(
//       title: Text('Data Tertanggung', style: bodyTextStyle(context)),
//       trailing: AnimatedRotation(
//         turns: widget.isExpanded ? 0.5 : 0.0,
//         duration: const Duration(milliseconds: 250),
//         child: SvgPicture.asset('assets/icons/dropdown.svg', width: 16),
//       ),
//       onTap: () => widget.onToggle(!widget.isExpanded),
//     );
//   }
//
//   Widget _buildForm(){
//     return Padding(
//       padding: const EdgeInsets.all(15),
//       child: Form(
//         key: _regparform1key,
//         child: Column(
//           children: [
//             buildFieldTtgAlamat(),
//             const SizedBox(height: hPadding),
//             buildFieldTtgNama(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<bool> validateAndReturn() async {
//     return _regparform1key.currentState?.validate() ?? false;
//   }
//
//   Future<void> saveForm1() async {
//     final record = Regpar1CrudModel(
//       regpar1Id: widget.recordId ??'',
//       ttgAlamat: fieldTtgAlamatController.text,
//       ttgNama: fieldTtgNamaController.text,
//     );
//
//     if (widget.viewMode == "tambah") {
//       debugPrint("ini tambah loh di trigger di regmvform1");
//       regpar1Bloc.add(Regpar1CrudTambahEvent(record: record));
//     } else {
//       debugPrint("ini ubah loh di trigger di regmvform1");
//       regpar1Bloc.add(Regpar1CrudUbahEvent(record: record));
//     }
//
//   }
//
//   Widget buildFieldTtgAlamat() => appTextField(
//     label: "Nama Tertanggung",
//     controller: fieldTtgNamaController,
//     keyboardType: TextInputType.text,
//     inputFormatters: [
//       FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
//     ],
//     validator: (v) {
//       if (v == null || v.isEmpty) return kStringNullError;
//       return null;
//     },
//   );
//
//   Widget buildFieldTtgNama() => appTextField(
//     label: "Alamat Tertanggung",
//     controller: fieldTtgAlamatController,
//     keyboardType: TextInputType.text,
//     inputFormatters: [
//       FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
//     ],
//     validator: (v) {
//       if (v == null || v.isEmpty) return kStringNullError;
//       return null;
//     },
//   );
//
//
//
// }