// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:string_validator/string_validator.dart';
//
//
// import '../../../blocs/regpar/regpar1crud_bloc.dart';
// import '../../../blocs/regpar/regpar2form_bloc.dart';
// import '../../../blocs/regpar/regpar3form_bloc.dart';
// import '../../../blocs/regpar/regpar4form_bloc.dart';
// import '../../../blocs/regpar/regpar5form_bloc.dart';
// import '../../../blocs/regpar/regpar6cari_bloc.dart';
// import '../../../blocs/regpar/regpar6form_bloc.dart';
// import '../../../blocs/regpar/regpar_upload_foto_object_bloc.dart';
// import '../../../common/constants.dart';
// import '../../../common/thousand_separator_input_formatter.dart';
// import '../../../models/combobox/combomjnscoverpar_model.dart';
// import '../../../models/combobox/combomkabzonagempa_model.dart';
// import '../../../models/combobox/combomkecamatan_model.dart';
// import '../../../models/combobox/combomkelurahan_model.dart';
// import '../../../models/combobox/combomkota_model.dart';
// import '../../../models/combobox/combompropinsi_model.dart';
// import '../../../models/combobox/combomwilayah_model.dart';
// import '../../../models/combobox/comborkonstruksiojk_model.dart';
// import '../../../models/combobox/combormatauang_model.dart';
// import '../../../models/combobox/comborokupasi_model.dart';
// import '../../../models/regpar/regpar1crud_model.dart';
// import '../../../models/regpar/regpar2form_model.dart';
// import '../../../models/regpar/regpar3form_model.dart';
// import '../../../models/regpar/regpar4form_model.dart';
// import '../../../models/regpar/regpar5form_model.dart';
// import '../../../models/regpar/regpar6cari_model.dart';
// import '../../../models/regpar/regpar6form_model.dart';
// import '../../../repositories/combobox/combomkabzonagempa_repository.dart';
// import '../../../repositories/combobox/combomkecamatan_repository.dart';
// import '../../../repositories/combobox/combomkelurahan_repository.dart';
// import '../../../repositories/combobox/combomkota_repository.dart';
// import '../../../repositories/combobox/combompropinsi_repository.dart';
// import '../../../repositories/combobox/combomwilayah_repository.dart';
// import '../../../repositories/combobox/comborkonstruksiojk_repository.dart';
// import '../../../repositories/combobox/combormatauang_repository.dart';
// import '../../../repositories/combobox/comborokupasi_repository.dart';
// import '../../../widgets/apptheme/custom_progress_bar.dart';
// import '../../../widgets/apptheme/header_card_polis.dart';
// import '../../base/base_background_sidepage.dart';
// import 'konfirmasi_regpar_page.dart';
//
// class RegparFormMainRemake extends StatefulWidget {
//   final String? regpar1Id;
//   final String? calpar1Id;
//
//   const RegparFormMainRemake({
//     required this.regpar1Id,
//     required this.calpar1Id,
//     super.key,
//   });
//
//   @override
//   State<RegparFormMainRemake> createState() => _RegparFormMainRemakeState();
// }
//
// class _RegparFormMainRemakeState extends State<RegparFormMainRemake> {
//   List<bool> expanded = [false, false, false, false, false, false];
//
//   String? regpar1Id;
//   String? regpar2Id;
//   String? regpar3Id;
//   String? regpar4Id;
//   String? regpar5Id;
//   String? regpar6Id;
//
//   Regpar1CrudBloc? regpar1crudBloc;
//   Regpar2FormBloc? regpar2formBloc;
//   Regpar3FormBloc? regpar3formBloc;
//   Regpar4FormBloc? regpar4formBloc;
//
//   Regpar5FormBloc? regpar5formBloc;
//   bool _form5HasError = false;
//   String? _form5ErrorText;
//
//   Regpar6FormBloc? regpar6formBloc;
//
//
//   Regpar1CrudModel? form1Record;
//   Regpar2FormModel? form2Record;
//   Regpar3FormModel? form3Record;
//   Regpar4FormModel? form4Record;
//   Regpar5FormModel? form5Record;
//   Regpar6FormModel? form6Record;
//
//
//   String cleanNum(num value) {
//     final f = NumberFormat("#,###", "en_US");
//     return f.format(value);
//   }
//
//   double getProgressValue() {
//     final openedCount = expanded.where((v) => v).length;
//     return openedCount / 6;
//   }
//
//   //form1
//   final fieldTtgAlamatController = TextEditingController();
//   final fieldTtgNamaController = TextEditingController();
//   //form1
//
//   //form2
//   final fieldObjectAlamatController = TextEditingController();
//   final fieldCoverLamaController = TextEditingController();
//   final fieldPolisAkhirController = TextEditingController();
//   final fieldPolisMulaiController = TextEditingController();
//
//   ComboRKonstruksiojkModel? fieldComboRKonstruksiojk;
//   final comboRKonstruksiojkKey = GlobalKey<DropdownSearchState<ComboRKonstruksiojkModel>>();
//   ComboROkupasiModel? fieldComboROkupasi;
//   final comboROkupasiKey = GlobalKey<DropdownSearchState<ComboROkupasiModel>>();
//   ComboMKecamatanModel? fieldComboMKecamatan;
//   final comboMKecamatanKey = GlobalKey<DropdownSearchState<ComboMKecamatanModel>>();
//   ComboMKelurahanModel? fieldComboMKelurahan;
//   final comboMKelurahanKey = GlobalKey<DropdownSearchState<ComboMKelurahanModel>>();
//   ComboMKotaModel? fieldComboMKota;
//   final comboMKotaKey = GlobalKey<DropdownSearchState<ComboMKotaModel>>();
//   ComboMPropinsiModel? fieldComboMPropinsi;
//   final comboMPropinsiKey = GlobalKey<DropdownSearchState<ComboMPropinsiModel>>();
//   //form2
//
//   //form3
//   final fieldIsEqController = TextEditingController();
//   final fieldIsFlexasController = TextEditingController();
//   final fieldIsOtherController = TextEditingController();
//   final fieldIsRsmdccController = TextEditingController();
//   final fieldIsTsfwdController = TextEditingController();
//   ComboMKabZonaGempaModel? fieldComboMKabZonaGempa;
//   final comboMKabZonaGempaKey = GlobalKey<DropdownSearchState<ComboMKabZonaGempaModel>>();
//   ComboMJnscoverParModel? fieldComboMJnscoverPar;
//   final comboMJnscoverParKey = GlobalKey<DropdownSearchState<ComboMJnscoverParModel>>();
//   ComboMWilayahModel? fieldComboMWilayah;
//   final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();
//   //form3
//
//   //form4
//   final fieldSiBuildingController = TextEditingController();
//   final fieldSiContentController = TextEditingController();
//   final fieldSiMachineryController = TextEditingController();
//   final fieldSiOtherController = TextEditingController();
//   final fieldSiStockController = TextEditingController();
//   ComboRMatauangModel? fieldComboRMatauang;
//   final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
//   //form4
//
//
//   //form5
//   final fieldDiskonNilaiController = TextEditingController();
//   final fieldDiskonPersenController = TextEditingController();
//   final fieldPremiEqvetController = TextEditingController();
//   final fieldPremiNetController = TextEditingController();
//   final fieldPremiOtherController = TextEditingController();
//   final fieldPremiParController = TextEditingController();
//   final fieldPremiRsmdccController = TextEditingController();
//   final fieldPremiTotalController = TextEditingController();
//   final fieldPremiTsfwdController = TextEditingController();
//   //form5
//
//   //form6
//   List<Uint8List> _imagesRegpar6 = [];
//   List<String> _fileNamesRegpar6 = [];
//   List<Regpar6CariModel> _serverPhotosRegpar6 = [];
//   final Set<String> _deletingServerIdsRegpar6 = {};
//   //form6
//
//
//   @override
//   void initState() {
//     super.initState();
//     final regpar1 = context.read<Regpar1CrudBloc>().state.record?.regpar1Id ?? "";
//     regpar1Id = widget.regpar1Id ?? regpar1;
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final now = DateTime.now();
//       final today = DateTime(now.year, now.month, now.day);
//
//       context.read<PolisTanggalBloc>().add(PolisMulaiChanged(today));
//     });
//   }
//
//   @override
//   void dispose() {
//     // form1
//     fieldTtgAlamatController.dispose();
//     fieldTtgNamaController.dispose();
//
//     // form2
//     fieldObjectAlamatController.dispose();
//     fieldCoverLamaController.dispose();
//     fieldPolisAkhirController.dispose();
//     fieldPolisMulaiController.dispose();
//
//     // form3
//     fieldIsEqController.dispose();
//     fieldIsFlexasController.dispose();
//     fieldIsOtherController.dispose();
//     fieldIsRsmdccController.dispose();
//     fieldIsTsfwdController.dispose();
//
//     // form4
//     fieldSiBuildingController.dispose();
//     fieldSiContentController.dispose();
//     fieldSiMachineryController.dispose();
//     fieldSiOtherController.dispose();
//     fieldSiStockController.dispose();
//
//     // form5
//     fieldDiskonNilaiController.dispose();
//     fieldDiskonPersenController.dispose();
//     fieldPremiEqvetController.dispose();
//     fieldPremiNetController.dispose();
//     fieldPremiOtherController.dispose();
//     fieldPremiParController.dispose();
//     fieldPremiRsmdccController.dispose();
//     fieldPremiTotalController.dispose();
//     fieldPremiTsfwdController.dispose();
//
//     super.dispose();
//   }
//
//   void refreshForm1({required String? recordId}) {
//     if (recordId == null || recordId.isEmpty) return;
//     context.read<Regpar1CrudBloc>().add(
//       Regpar1CrudLihatEvent(recordId: recordId),
//     );
//   }
//
//   void refreshForm2({required String? recordId}) {
//     if (recordId == null || recordId.isEmpty) return;
//     context.read<Regpar2FormBloc>().add(
//       Regpar2FormLihatEvent(recordId: recordId),
//     );
//   }
//
//   void refreshForm3({required String? recordId}) {
//     if (recordId == null || recordId.isEmpty) return;
//     context.read<Regpar3FormBloc>().add(
//       Regpar3FormLihatEvent(recordId: recordId),
//     );
//   }
//
//   void refreshForm4({required String? recordId}) {
//     if (recordId == null || recordId.isEmpty) return;
//     context.read<Regpar4FormBloc>().add(
//       Regpar4FormLihatEvent(recordId: recordId),
//     );
//   }
//
//   void refreshForm5({required String? recordId}) {
//     if (recordId == null || recordId.isEmpty) return;
//     context.read<Regpar5FormBloc>().add(
//       Regpar5FormLihatEvent(recordId: recordId),
//     );
//   }
//
//   void refreshForm6({required String? recordId}) {
//     if (recordId == null || recordId.isEmpty) return;
//     context.read<Regpar6CariBloc>().add(
//       RefreshRegpar6CariEvent(regpar1Id: recordId),
//     );
//   }
//
//   void _payloadform1(Regpar1CrudModel record) {
//     if (fieldTtgAlamatController.text.trim().isEmpty) {
//       fieldTtgAlamatController.text = record.ttgAlamat;
//     }
//
//     if (fieldTtgNamaController.text.trim().isEmpty) {
//       fieldTtgNamaController.text = record.ttgNama;
//     }
//   }
//
//   void _payloadform2(Regpar2FormModel record) {
//     // text field
//     if (fieldObjectAlamatController.text.trim().isEmpty) {
//       fieldObjectAlamatController.text = record.objectAlamat ?? '';
//     }
//
//     if (fieldPolisMulaiController.text.trim().isEmpty) {
//       fieldPolisMulaiController.text = record.polisMulai.toIso8601String();
//     }
//
//     if (fieldPolisAkhirController.text.trim().isEmpty) {
//       fieldPolisAkhirController.text = record.polisAkhir.toIso8601String();
//     }
//
//     // dropdown & combo state
//     setState(() {
//       if (fieldComboMKecamatan == null && record.comboMKecamatan != null) {
//         fieldComboMKecamatan = record.comboMKecamatan;
//       }
//
//       if (fieldComboMKelurahan == null && record.comboMKelurahan != null) {
//         fieldComboMKelurahan = record.comboMKelurahan;
//       }
//
//       if (fieldComboMKota == null && record.comboMKota != null) {
//         fieldComboMKota = record.comboMKota;
//       }
//
//       if (fieldComboMPropinsi == null && record.comboMPropinsi != null) {
//         fieldComboMPropinsi = record.comboMPropinsi;
//       }
//
//       if (fieldComboRKonstruksiojk == null && record.comboRKonstruksiojk != null) {
//         fieldComboRKonstruksiojk = record.comboRKonstruksiojk;
//       }
//
//       if (fieldComboROkupasi == null && record.comboROkupasi != null) {
//         fieldComboROkupasi = record.comboROkupasi;
//       }
//     });
//   }
//
//   void _payloadform3(Regpar3FormModel record) {
//     // bool -> text controller
//     if (fieldIsEqController.text.trim().isEmpty && record.isEq != null) {
//       fieldIsEqController.text = record.isEq.toString();
//     }
//
//     if (fieldIsFlexasController.text.trim().isEmpty && record.isFlexas != null) {
//       fieldIsFlexasController.text = record.isFlexas.toString();
//     }
//
//     if (fieldIsOtherController.text.trim().isEmpty && record.isOther != null) {
//       fieldIsOtherController.text = record.isOther.toString();
//     }
//
//     if (fieldIsRsmdccController.text.trim().isEmpty && record.isRsmdcc != null) {
//       fieldIsRsmdccController.text = record.isRsmdcc.toString();
//     }
//
//     if (fieldIsTsfwdController.text.trim().isEmpty && record.isTsfwd != null) {
//       fieldIsTsfwdController.text = record.isTsfwd.toString();
//     }
//
//     // dropdown / combo
//     setState(() {
//       if (fieldComboMKabZonaGempa == null && record.comboMKabZonaGempa != null) {
//         fieldComboMKabZonaGempa = record.comboMKabZonaGempa;
//       }
//
//       if (fieldComboMJnscoverPar == null && record.comboMJnscoverPar != null) {
//         fieldComboMJnscoverPar = record.comboMJnscoverPar;
//       }
//
//       if (fieldComboMWilayah == null && record.comboMWilayah != null) {
//         fieldComboMWilayah = record.comboMWilayah;
//       }
//     });
//   }
//
//   void _payloadform4(Regpar4FormModel record) {
//     if (fieldSiBuildingController.text.trim().isEmpty) {
//       fieldSiBuildingController.text = record.siBuilding.toString();
//     }
//
//     if (fieldSiContentController.text.trim().isEmpty) {
//       fieldSiContentController.text = record.siContent.toString();
//     }
//
//     if (fieldSiMachineryController.text.trim().isEmpty) {
//       fieldSiMachineryController.text = record.siMachinery.toString();
//     }
//
//     if (fieldSiOtherController.text.trim().isEmpty) {
//       fieldSiOtherController.text = record.siOther.toString();
//     }
//
//     if (fieldSiStockController.text.trim().isEmpty) {
//       fieldSiStockController.text = record.siStock.toString();
//     }
//
//     setState(() {
//       if (fieldComboRMatauang == null && record.comboRMatauang != null) {
//         fieldComboRMatauang = record.comboRMatauang;
//       }
//     });
//   }
//
//   void _payloadform5(Regpar5FormModel record) {
//     fieldDiskonNilaiController.text = record.diskonNilai.toString();
//     fieldDiskonPersenController.text = record.diskonPersen.toString();
//     fieldPremiEqvetController.text = record.premiEqvet.toString();
//     fieldPremiNetController.text = record.premiNet.toString();
//     fieldPremiOtherController.text = record.premiOther.toString();
//     fieldPremiParController.text = record.premiPar.toString();
//     fieldPremiRsmdccController.text = record.premiRsmdcc.toString();
//     fieldPremiTotalController.text = record.premiTotal.toString();
//     fieldPremiTsfwdController.text = record.premiTsfwd.toString();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseBackgroundSidePage(
//       title: "Kendaraan",
//       blocListeners: [
//         BlocListener<Regpar1CrudBloc, Regpar1CrudState>(
//           listener: (context, state) {
//             if (state.isSaved && !state.hasFailure && state.record != null) {
//               setState(() {
//                 regpar1Id = state.record!.regpar1Id;
//               });
//             }
//             if (state.isLoaded && !state.hasFailure && state.record != null) {
//               _payloadform1(state.record!);
//             }
//           },
//         ),
//
//         BlocListener<Regpar2FormBloc, Regpar2FormState>(
//           listener: (context, state) {
//             if (state.isSaved && !state.hasFailure && state.record != null) {
//               setState(() {
//                 regpar2Id = state.record!.regpar2Id;
//               });
//             }
//             if (state.isLoaded && !state.hasFailure && state.record != null) {
//               _payloadform2(state.record!);
//             }
//           },
//         ),
//
//         BlocListener<Regpar3FormBloc, Regpar3FormState>(
//           listener: (context, state) {
//             if (state.isSaved && !state.hasFailure && state.record != null) {
//               setState(() {
//                 regpar3Id = state.record!.regpar3Id;
//               });
//             }
//             if (state.isLoaded && !state.hasFailure && state.record != null) {
//               _payloadform3(state.record!);
//             }
//           },
//         ),
//
//         //hahh? bug?
//         BlocListener<Regpar4FormBloc, Regpar4FormState>(
//           listener: (context, state) {
//             if (state.isSaved && !state.hasFailure && state.record != null) {
//               setState(() {
//                 //buggk ada regpar4Id?
//                 regpar4Id = state.record!.regpar1Id;
//               });
//             }
//             if (state.isLoaded && !state.hasFailure && state.record != null) {
//               _payloadform4(state.record!);
//             }
//           },
//         ),
//
//
//         BlocListener<Regpar5FormBloc, Regpar5FormState>(
//           listener: (context, state) {
//             if (state.isSaved && !state.hasFailure && state.record != null) {
//               setState(() {
//                 regpar5Id = state.record!.regpar5Id;
//               });
//             }
//             if (state.isLoaded && !state.hasFailure && state.record != null) {
//               _payloadform5(state.record!);
//             }
//           },
//         ),
//
//         // server list update
//         BlocListener<Regpar6FormBloc, Regpar6FormState>(
//           listener: (context, state) {
//             if (state.isSaved) {
//               setState(() => _serverPhotosRegpar6 = List.from(state.items));
//             }
//           },
//         ),
//
//         // upload flow
//         BlocListener<RegparUploadFotoObjectBloc, RegparUploadFotoObjectState>(
//           listener: (context, state) {
//             if (state is UploadFotoObjectListPreview) {
//               // cache untuk submit/delete preview
//               setState(() {
//                 _imagesRegpar6 = List.from(state.images);
//                 _fileNamesRegpar6 = List.from(state.fileNames);
//               });
//             }
//
//             if (state is UploadFotoObjectSuccess) {
//               if (regpar1Id != null && regpar1Id!.isNotEmpty) {
//                 refreshForm5(recordId: regpar1Id);
//               }
//             }
//
//             if (state is UploadFotoObjectFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.error),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//         ),
//
//         // delete server (state hanya flag)
//         BlocListener<Regpar6FormBloc, Regpar6FormState>(
//           listener: (context, state) {
//             // kalau ada aksi hapus berhasil → clear pending + refresh
//             if (state.isSaved) {
//               _deletingServerIdsRegpar6.clear();
//               if (regpar1Id != null && regpar1Id!.isNotEmpty) {
//                 refreshForm6(recordId: regpar1Id);
//               }
//             }
//
//             // kalau gagal → clear pending + refresh (rollback by refresh)
//             if (state.hasFailure) {
//               _deletingServerIdsRegpar6.clear();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Gagal menghapus foto. Mengambil ulang data..."),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//               if (regpar1Id != null && regpar1Id!.isNotEmpty) {
//                 refreshForm5(recordId: regpar1Id);
//               }
//             }
//           },
//         ),
//       ],
//
//       child: _buildForm(),
//     );
//   }
//
//   Widget _buildForm() {
//     final bool hasForm5Record =
//         context.read<Regpar5FormBloc>().state.record != null;
//     return Scaffold(
//       backgroundColor: secondaryBlackColor,
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: hPadding * 1.5),
//
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
//               child: const FormSectionHeader(
//                 iconPath: "assets/icons/kendaraan.svg",
//                 title: "Kendaraan",
//                 subtitle: "Isi detail kendaraan, pilih pertanggungan, dan hitung premi secara otomatis.",
//               ),
//             ),
//
//             const SizedBox(height: hPadding * 1.5),
//
//             CustomProgressBar(
//               progress: getProgressValue(),
//               horizontalPadding: hPadding * 1.5,
//               barColor: primaryColor,
//               borderRadius: cardBorderRadius,
//             ),
//
//             const SizedBox(height: hPadding * 1.5),
//
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: hPadding),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Form1Page(
//                     context: context,
//                     title: "Data Kendaraan",
//                     isExpanded: expanded[0],
//                     onToggle: (v) => setState(() => expanded[0] = v),
//                     onRefresh: () {
//                       if (regpar1Id != null && regpar1Id!.isNotEmpty) {
//                         refreshForm1(recordId: regpar1Id);
//                       }
//                     },
//                     child: Column(
//                       children: [
//                         buildFieldTtgAlamat(),
//                         const SizedBox(height: hPadding),
//                         buildFieldTtgNama(),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: hPadding),
//
//                   Form2Page(
//                     context: context,
//                     title: "Pertanggungan",
//                     isExpanded: expanded[1],
//                     onToggle: (v) => setState(() => expanded[1] = v),
//                     onRefresh: () {
//                       if (regpar1Id != null && regpar1Id!.isNotEmpty) {
//                         refreshForm2(recordId: regpar1Id);
//                       }
//                     },
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Flexible(child: buildFieldPolisMulai()),
//                             const SizedBox(width: hPadding,),
//                             Flexible(child: buildFieldPolisBerakhir()),
//                           ],
//                         ),
//                         const SizedBox(height: hPadding,),
//                         const SizedBox(width: hPadding,),
//                         buildFieldRkonstruksiojkId(),
//                         const SizedBox(height: hPadding),
//                         buildFieldRokupasiId(),
//                         const SizedBox(height: hPadding),
//                         buildFieldObjectAlamat(),
//                         const SizedBox(height: hPadding),
//                         buildFieldObjectPropinsiId(),
//                         const SizedBox(height: hPadding),
//                         buildFieldObjectKotaId(),
//                         const SizedBox(height: hPadding),
//                         buildFieldObjectKecamatanId(),
//                         const SizedBox(height: hPadding),
//                         buildFieldObjectKelurahanId(),
//                         const SizedBox(height: 15),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: hPadding),
//
//                   Form3Page(
//                     context: context,
//                     title: "Premi",
//                     isExpanded: expanded[2],
//                     onToggle: (v) => setState(() => expanded[2] = v),
//                     onRefresh: () {
//                       if (regpar1Id != null && regpar1Id!.isNotEmpty) {
//                         refreshForm3(recordId: regpar1Id);
//                       }
//                     },
//                     child: Column(
//                       children: [
//                         buildFieldMjnscoverparId(),
//                         const SizedBox(height: hPadding),
//                         Text(
//                           "Jenis asuransi All Risk mencakup:",
//                           style: bodyTextStyle(context).copyWith(
//                             color: primaryLightColor,
//                             fontSize: getResponsiveFont(context, 16),
//                           ),
//                         ),
//                         const SizedBox(height: hPadding),
//
//                         Row(
//                           children: [
//                             Flexible(child: buildFieldIsFlexas()),
//                             const SizedBox(width: 8),
//                             Flexible(child: buildFieldIsEq()),
//                           ],
//                         ),
//                         const SizedBox(height: hPadding),
//
//                         Row(
//                           children: [
//                             Flexible(child: buildFieldIsRsmdcc()),
//                             const SizedBox(width: 8),
//                             Flexible(child: buildFieldIsTsfwd()),
//                           ],
//                         ),
//                         const SizedBox(height: hPadding),
//
//                         // Row(
//                         //   children: [
//                         //     Flexible(child: buildFieldRateRsmdcc()),
//                         //     const SizedBox(width: 8),
//                         //     Flexible(child: buildFieldRateTotal()),
//                         //   ],
//                         // ),
//                         // const SizedBox(height: hPadding),
//
//                         Row(
//                           children: [
//                             Flexible(child: buildFieldIsOther()),
//                             const SizedBox(width: 8),
//                             const Flexible(child: SizedBox.shrink()),
//                           ],
//                         ),
//                         const SizedBox(height: hPadding),
//                         buildFieldMwilayahId(),
//                         const SizedBox(height: hPadding),
//                         buildFieldKab2zonagempaId(),
//                         const SizedBox(height: 15),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: hPadding),
//
//                   Form6Page(
//                     context: context,
//                     title: "Upload Foto Mobil",
//                     isExpanded: expanded[4],
//                     onToggle: (v) => setState(() => expanded[4] = v),
//                     onRefresh: () {
//                       if (regpar1Id != null && regpar1Id!.isNotEmpty) {
//                         refreshForm5(recordId: regpar1Id);
//                       }
//                     },
//                     child: Column(
//                       children: [
//                         _buildBodyForm5(),
//                         const SizedBox(height: 15),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: hPadding),
//
//                   buildButtonHitungPremi(),
//
//                   const SizedBox(height: hPadding),
//
//                   Form5Page(
//                     context: context,
//                     title: "Premi",
//                     isExpanded: expanded[6],
//                     onToggle: (v) => setState(() => expanded[6] = v),
//                     child: (hasForm6Record)
//                         ? Column(
//                       children: [
//                         buildFieldPremiNet(),
//                         const SizedBox(height: hPadding),
//                         buildFieldPremiDiskon(),
//                         const SizedBox(height: hPadding),
//                         buildFieldPremiSubtotal(),
//                       ],
//                     )
//                         : const SizedBox(
//                       height: 40,
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text("Klik Hitung Premi untuk melihat hasil."),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: hPadding),
//
//                   if (hasForm5Record) ...[
//                     AppButton.iconRight(
//                       text: "Lanjutkan",
//                       icon: Icon(Icons.arrow_forward),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => KonfirmasiRegParPage(
//                               recordId: regpar1Id ?? '',
//                               viewMode: 'ubah',
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//
//                   const SizedBox(height: 25),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget Form1Page({
//     required BuildContext context,
//     required bool isExpanded,
//     required ValueChanged<bool> onToggle,
//     required Widget child,
//     VoidCallback? onRefresh,
//     String title = "Form 1",
//   }) {
//     return Card(
//       color: pGrey,
//       child: Column(
//         children: [
//           ListTile(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//             title: Text(title, style: bodyTextStyle(context)),
//             trailing: AnimatedRotation(
//               turns: isExpanded ? 0.5 : 0,
//               duration: const Duration(milliseconds: 250),
//               child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
//             ),
//             onTap: () {
//               onToggle(!isExpanded);
//               onRefresh?.call();
//             },
//
//           ),
//           if (isExpanded)
//             Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
//               child: child,
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget Form2Page({
//     required BuildContext context,
//     required bool isExpanded,
//     required ValueChanged<bool> onToggle,
//     required Widget child,
//     VoidCallback? onRefresh,
//     String title = "Form 2",
//   }) {
//     return Card(
//       color: pGrey,
//       child: Column(
//         children: [
//           ListTile(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//             title: Text(title, style: bodyTextStyle(context)),
//             trailing: AnimatedRotation(
//               turns: isExpanded ? 0.5 : 0,
//               duration: const Duration(milliseconds: 250),
//               child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
//             ),
//             onTap: () {
//               onToggle(!isExpanded);
//               onRefresh?.call();
//             },
//
//           ),
//           if (isExpanded)
//             Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
//               child: child,
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget Form3Page({
//     required BuildContext context,
//     required bool isExpanded,
//     required ValueChanged<bool> onToggle,
//     required Widget child,
//     VoidCallback? onRefresh,
//     String title = "Form 3",
//   }) {
//     return Card(
//       color: pGrey,
//       child: Column(
//         children: [
//           ListTile(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//             title: Text(title, style: bodyTextStyle(context)),
//             trailing: AnimatedRotation(
//               turns: isExpanded ? 0.5 : 0,
//               duration: const Duration(milliseconds: 250),
//               child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
//             ),
//             onTap: () {
//               onToggle(!isExpanded);
//               onRefresh?.call();
//             },
//
//           ),
//           if (isExpanded)
//             Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
//               child: child,
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget Form4Page({
//     required BuildContext context,
//     required bool isExpanded,
//     required ValueChanged<bool> onToggle,
//     required Widget child,
//     VoidCallback? onRefresh,
//     String title = "Form 4",
//   }) {
//     return Card(
//       color: pGrey,
//       child: Column(
//         children: [
//           ListTile(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//             title: Text(title, style: bodyTextStyle(context)),
//             trailing: AnimatedRotation(
//               turns: isExpanded ? 0.5 : 0,
//               duration: const Duration(milliseconds: 250),
//               child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
//             ),
//             onTap: () {
//               onToggle(!isExpanded);
//               onRefresh?.call();
//             },
//
//           ),
//           if (isExpanded)
//             Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
//               child: child,
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget Form5Page({
//     required BuildContext context,
//     required bool isExpanded,
//     required ValueChanged<bool> onToggle,
//     required Widget child,
//     VoidCallback? onRefresh,
//     String title = "Form 5",
//   }) {
//     return Card(
//       color: pGrey,
//       child: Column(
//         children: [
//           ListTile(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//             title: Text(title, style: bodyTextStyle(context)),
//             trailing: AnimatedRotation(
//               turns: isExpanded ? 0.5 : 0,
//               duration: const Duration(milliseconds: 250),
//               child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
//             ),
//             onTap: () {
//               onToggle(!isExpanded);
//               onRefresh?.call();
//             },
//           ),
//           if (isExpanded)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 15),
//               child: child,
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget Form6Page({
//     required BuildContext context,
//     required bool isExpanded,
//     required ValueChanged<bool> onToggle,
//     required Widget child,
//     VoidCallback? onRefresh,
//     String title = "Form 5",
//   }) {
//     return Card(
//       color: pGrey,
//       child: Column(
//         children: [
//           ListTile(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 15),
//             title: Text(title, style: bodyTextStyle(context)),
//             trailing: AnimatedRotation(
//               turns: isExpanded ? 0.5 : 0,
//               duration: const Duration(milliseconds: 250),
//               child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
//             ),
//             onTap: () {
//               onToggle(!isExpanded);
//               onRefresh?.call();
//             },
//
//           ),
//           if (isExpanded)
//             Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
//               child: child,
//             ),
//         ],
//       ),
//     );
//   }
//
//
//
//   //form1
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
// //form1
//
//   //form2
//   Widget buildFieldPolisMulai() {
//     return AppDateField(
//       label: 'Tanggal Mulai',
//       initialValue: kejadianMulaiTgl ?? _today,
//       firstDate: _today,
//       lastDate: DateTime(2100),
//       validator: (dt) => dt == null ? kStringNullError : null,
//       onChanged: (dt) {
//         if (dt == null) return;
//         setState(() {
//           kejadianMulaiTgl = DateTime(dt.year, dt.month, dt.day);
//           kejadianBerakhirTgl = addOneYearSafe(kejadianMulaiTgl!);
//         });
//       },
//     );
//   }
//   Widget buildFieldPolisBerakhir() {
//     return AppDateField(
//       label: 'Tanggal Berakhir',
//       enabled: false,
//
//       // realtime mengikuti variabel state
//       initialValue: kejadianBerakhirTgl
//           ?? addOneYearSafe(kejadianMulaiTgl ?? _today),
//
//       firstDate: _today,
//       lastDate: DateTime(2100, 1, 1),
//       validator: (dt) => dt == null ? kStringNullError : null,
//     );
//   }
//
//
//   Widget buildFieldRkonstruksiojkId() => ReusableComboBox<ComboRKonstruksiojkModel>(
//     hintText: "Kelas Konstruksi",
//     initItem: fieldComboRKonstruksiojk,
//     dataLoader: () => ComboRKonstruksiojkRepository().getComboRKonstruksiojk(),
//     displayText: (item) => item.kelasNama,
//     compareItems: (a, b) => a.rkonstruksiojkId == b.rkonstruksiojkId,
//     validatorCallback: (v) => v == null ? kStringNullError : null,
//     onChangedCallback: (v) => fieldComboRKonstruksiojk = v,
//     onSaveCallback: (value) => fieldComboRKonstruksiojk = value,
//   );
//
//   Widget buildFieldRokupasiId() => ReusableComboBox<ComboROkupasiModel>(
//     hintText: "Okupasi",
//     comboKey: comboROkupasiKey,
//     initItem: fieldComboROkupasi,
//     dataLoader: () => ComboROkupasiRepository().getComboROkupasi(fieldComboRKonstruksiojk?.rkonstruksiojkId ?? ""),
//     displayText: (item) => item.okupasiDesc,
//     compareItems: (a, b) => a.rokupasiId == b.rokupasiId,
//     validatorCallback: (v) => v == null ? kStringNullError : null,
//     onChangedCallback: (v) {
//       if (v != null){
//         removeError(error: kStringNullError);
//         regpar2Bloc.add(ComboROkupasiChangedEvent(comboROkupasi: v)
//         );
//       }
//       fieldComboROkupasi = v;
//     },
//     onSaveCallback: (value) => fieldComboROkupasi = value,
//   );
//
//   Widget buildFieldObjectAlamat() => appTextField(
//     label: "Alamat Rumah",
//     controller: fieldObjectAlamatController,
//     keyboardType: TextInputType.text,
//     inputFormatters: [
//       FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
//     ],
//     validator: (v) {
//       if (v == null || v.isEmpty) return kAddressNullError;
//       return null;
//     },
//   );
//
//   Widget buildFieldObjectPropinsiId() => ReusableComboBox<ComboMPropinsiModel>(
//     hintText: "Provinsi",
//     comboKey: comboMPropinsiKey,
//     initItem: fieldComboMPropinsi,
//     dataLoader: () => ComboMPropinsiRepository().getComboMPropinsi(""),
//     displayText: (item) => item.propinsiNama,
//     compareItems: (a, b) => a.mpropinsiId == b.mwilayahId,
//     validatorCallback: (v) => v == null ? kStringNullError : null,
//     onChangedCallback: (v) {
//       if (v != null){
//         removeError(error: kStringNullError);
//         regpar2Bloc.add(ComboMPropinsiChangedEvent(comboMPropinsi: v)
//         );
//         comboMKotaKey.currentState?.clear();
//         comboMKecamatanKey.currentState?.clear();
//         comboMKelurahanKey.currentState?.clear();
//       }
//       fieldComboMPropinsi = v;
//     },
//     onSaveCallback: (value) => fieldComboMPropinsi = value,
//   );
//
//   Widget buildFieldObjectKotaId() => ReusableComboBox<ComboMKotaModel>(
//     hintText: "Kota",
//     comboKey: comboMKotaKey,
//     initItem: fieldComboMKota,
//     dataLoader: () => ComboMKotaRepository().getComboMKota(fieldComboMPropinsi?.mpropinsiId ?? ""),
//     displayText: (item) => item.kotaDesc,
//     compareItems: (a, b) => a.mkotaId == b.mkotaId,
//     validatorCallback: (v) => v == null ? kStringNullError : null,
//     onChangedCallback: (v) {
//       if (v != null){
//         removeError(error: kStringNullError);
//         regpar2Bloc.add(ComboMKotaChangedEvent(comboMKota: v)
//         );
//         comboMKecamatanKey.currentState?.clear();
//         comboMKelurahanKey.currentState?.clear();
//       }
//       fieldComboMKota = v;
//     },
//     onSaveCallback: (value) => fieldComboMKota = value,
//   );
//
//   Widget buildFieldObjectKecamatanId() => ReusableComboBox<ComboMKecamatanModel>(
//     hintText: "Kecamatan",
//     comboKey: comboMKecamatanKey,
//     initItem: fieldComboMKecamatan,
//     dataLoader: () => ComboMKecamatanRepository().getComboMKecamatan(fieldComboMKota?.mkotaId ?? ""),
//     displayText: (item) => item.kecamatanNama,
//     compareItems: (a, b) => a.mkecamatanId == b.mkecamatanId,
//     validatorCallback: (v) => v == null ? kStringNullError : null,
//     onChangedCallback: (v) {
//       if (v != null){
//         removeError(error: kStringNullError);
//         regpar2Bloc.add(ComboMKecamatanChangedEvent(comboMKecamatan: v)
//         );
//       }
//       comboMKelurahanKey.currentState?.clear();
//       fieldComboMKecamatan = v;
//     },
//     onSaveCallback: (value) => fieldComboMKecamatan = value,
//   );
//
//   Widget buildFieldObjectKelurahanId() => ReusableComboBox<ComboMKelurahanModel>(
//     hintText: "Kelurahan",
//     comboKey: comboMKelurahanKey,
//     initItem: fieldComboMKelurahan,
//     dataLoader: () => ComboMKelurahanRepository().getComboMKelurahan(fieldComboMKecamatan?.mkecamatanId ?? ""),
//     displayText: (item) => item.kelurahanNama,
//     compareItems: (a, b) => a.mkelurahanId == b.mkelurahanId,
//     validatorCallback: (v) => v == null ? kStringNullError : null,
//     onChangedCallback: (v) {
//       if (v != null){
//         removeError(error: kStringNullError);
//         regpar2Bloc.add(ComboMKelurahanChangedEvent(comboMKelurahan: v)
//         );
//       }
//       fieldComboMKelurahan = v;
//     },
//     onSaveCallback: (value) => fieldComboMKelurahan = value,
//   );
//   //form2
//
//
// //form3
//
//   Widget buildFieldMwilayahId() => ReusableComboBox<ComboMWilayahModel>(
//     hintText: "Wilayah",
//     initItem: fieldComboMWilayah,
//     dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
//     displayText: (i) => i.wilayahNama,
//     compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
//     validatorCallback: (v) => v == null ? kStringNullError : null,
//     onChangedCallback: (v) => fieldComboMWilayah = v,
//     onSaveCallback: (value) => fieldComboMWilayah = value,
//   );
//
//
//   Widget buildFieldKab2zonagempaId() => ReusableComboBox<ComboMKabZonaGempaModel>(
//     hintText: "Zona gempa Bumi",
//     initItem: fieldComboMKabZonaGempa,
//     dataLoader: () => ComboMKabZonaGempaRepository().getComboMKabZonaGempa(fieldComboMWilayah?.mwilayahId ?? ""),
//     displayText: (i) => i.kabupaten,
//     compareItems: (a, b) => a.mkabzonagempaId == b.mkabzonagempaId,
//     validatorCallback: (v) => v == null ? kStringNullError : null,
//     onChangedCallback: (v) => fieldComboMKabZonaGempa = v,
//     onSaveCallback: (value) => fieldComboMKabZonaGempa = value,
//   );
//
//
//   Widget  buildFieldIsEq() => CheckboxWidget(
//     rightLabel: "Gempa Bumi",
//     initialValue: toBoolean(fieldIsEqController.text),
//     callback: (v) => fieldIsEqController.text = v.toString(),
//     leftLabel: "",
//   );
//
//   Widget buildFieldIsFlexas() => CheckboxWidget(
//     leftLabel: "",
//     rightLabel: "Kebakaran/Petir",
//     initialValue: toBoolean(fieldIsFlexasController.text),
//     callback: (v) => fieldIsFlexasController.text = v.toString(),
//   );
//
//   Widget buildFieldIsOther() => CheckboxWidget(
//     leftLabel: "",
//     rightLabel: "Lain-Lain",
//     initialValue: toBoolean(fieldIsOtherController.text),
//     callback: (v) => fieldIsOtherController.text = v.toString(),
//   );
//
//   Widget buildFieldIsRsmdcc() => CheckboxWidget(
//     leftLabel: "",
//     rightLabel: "Kerusuhan",
//     initialValue: toBoolean(fieldIsRsmdccController.text),
//     callback: (v) => fieldIsRsmdccController.text = v.toString(),
//   );
//
//   Widget buildFieldIsTsfwd() => CheckboxWidget(
//     leftLabel: "",
//     rightLabel: "Banjir",
//     initialValue: toBoolean(fieldIsTsfwdController.text),
//     callback: (v) => fieldIsTsfwdController.text = v.toString(),
//   );
// //form3
//
// //form4
//   Widget _buildComboCurddId() => ReusableComboBox<ComboRMatauangModel>(
//     hintText: "Mata Uang",
//     initItem: fieldComboRMatauang,
//     dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
//     displayText: (item) => item.rmatauangNama,
//     compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
//     validatorCallback: (v) => v == null ? kStringNullError : null,
//     onChangedCallback: (v) => fieldComboRMatauang = v,
//     onSaveCallback: (value) => fieldComboRMatauang = value,
//   );
//
//   Widget buildFieldSiBuilding() => appTextField(
//     label: "Bangunan",
//     controller: fieldSiBuildingController,
//     keyboardType: TextInputType.number,
//     inputFormatters: [
//       FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
//       ThousandsSeparatorInputFormatter(),
//     ],
//     validator: (v) {
//       if (v == null || v.isEmpty) return kStringNullError;
//       final clean = v.replaceAll(",", "");
//       final angka = double.tryParse(clean);
//       if (angka == null || angka <= 0) return kString0;
//       return null;
//     },
//   );
//
//   Widget buildFieldSiContent() => appTextField(
//     label: "Inventaris",
//     controller: fieldSiContentController,
//     keyboardType: TextInputType.number,
//     inputFormatters: [
//       FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
//       ThousandsSeparatorInputFormatter(),
//     ],
//     validator: (v) {
//       if (v == null || v.isEmpty) return kStringNullError;
//       final clean = v.replaceAll(",", "");
//       final angka = double.tryParse(clean);
//       if (angka == null || angka <= 0) return kString0;
//       return null;
//     },
//   );
//
//   Widget buildFieldSiMachinery() => appTextField(
//     label: "Mesin",
//     controller: fieldSiMachineryController,
//     keyboardType: TextInputType.number,
//     inputFormatters: [
//       FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
//       ThousandsSeparatorInputFormatter(),
//     ],
//     validator: (v) {
//       if (v == null || v.isEmpty) return kStringNullError;
//       final clean = v.replaceAll(",", "");
//       final angka = double.tryParse(clean);
//       if (angka == null || angka <= 0) return kString0;
//       return null;
//     },
//   );
//
//   Widget buildFieldSiOther() => appTextField(
//     label: "Total",
//     controller: fieldSiOtherController,
//     keyboardType: TextInputType.number,
//     inputFormatters: [
//       FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
//       ThousandsSeparatorInputFormatter(),
//     ],
//     validator: (v) {
//       if (v == null || v.isEmpty) return kStringNullError;
//       final clean = v.replaceAll(",", "");
//       final angka = double.tryParse(clean);
//       if (angka == null || angka <= 0) return kString0;
//       return null;
//     },
//   );
//
//   Widget buildFieldSiStock() => appTextField(
//     label: "Stok",
//     controller: fieldSiStockController,
//     keyboardType: TextInputType.number,
//     inputFormatters: [
//       FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
//       ThousandsSeparatorInputFormatter(),
//     ],
//     validator: (v) {
//       if (v == null || v.isEmpty) return kStringNullError;
//       final clean = v.replaceAll(",", "");
//       final angka = double.tryParse(clean);
//       if (angka == null || angka <= 0) return kString0;
//       return null;
//     },
//   );
// //form4
//
//
// }