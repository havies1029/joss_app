import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/calpar/calpar1crud_bloc.dart';
import 'package:joss_app/models/calpar/calpar1crud_model.dart';
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

import '../../../../repositories/combobox/combomjnscoverpar_repository.dart';
import '../../../../repositories/combobox/comborkonstruksiojk_repository.dart';
import '../../../../repositories/combobox/comborokupasi_repository.dart';

class Calpar1CrudFormPage extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;

  const Calpar1CrudFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Calpar1CrudFormPageFormState createState() => Calpar1CrudFormPageFormState();
}

class Calpar1CrudFormPageFormState extends State<Calpar1CrudFormPage> {
  final _calparform1key = GlobalKey<FormState>();
  ComboRKonstruksiojkModel? previousKonstruksi;
  final konstruksiKey = GlobalKey<DropdownSearchState<ComboRKonstruksiojkModel>>();

  //Controllers
  final fieldCoverBulanController = TextEditingController();
  ComboMJnscoverParModel? fieldComboMJnscoverPar;
  ComboRKonstruksiojkModel? fieldComboRKonstruksiojk;
  ComboROkupasiModel? fieldComboROkupasi;

  late final Calpar1CrudBloc calpar1Bloc;

  @override
  void initState() {
    super.initState();
    calpar1Bloc = context.read<Calpar1CrudBloc>();
    Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      calpar1Bloc.add(Calpar1CrudLihatEvent(recordId: widget.recordId!));
    }
  }

  @override
  void dispose() {
    fieldCoverBulanController.dispose();
    super.dispose();
  }

  String getKonstruksiSubtitle(String kelasNama) {
    switch (kelasNama) {
      case "Kelas Konstruksi 1":
        return "Bangunan permanen dengan struktur beton bertulang atau pasangan bata.";
      case "Kelas Konstruksi 2":
        return "Bangunan semi permanen, kombinasi bata dan kayu.";
      case "Kelas Konstruksi 3":
        return "Bangunan dengan dominasi material kayu atau mudah terbakar.";
      default:
        return "Deskripsi konstruksi tidak tersedia.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: pGrey,
      child: Column(
        children: [_buildHeader(), if (widget.isExpanded) _buildForm()],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: Text("Informasi Bangunan", style: bodyTextStyle(context)),
      trailing: AnimatedRotation(
        turns: widget.isExpanded ? 0.5 : 0,
        duration: const Duration(milliseconds: 250),
        child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
      ),
      onTap: () {
        widget.onToggle(!widget.isExpanded);
      },
    );
  }

  Widget _buildForm() {
    return BlocBuilder<Calpar1CrudBloc, Calpar1CrudState>(
      buildWhen: (prev, curr) => curr.isLoaded == true,
      builder: (context, state) {
        if (state.isLoaded && state.record != null) {
          _injectPayload(state.record!);
        }

        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Form(
            key: _calparform1key,
            child: Column(
              children: [
<<<<<<< HEAD
                // buildFieldCoverBulan(),
                // const SizedBox(height: 12),
=======
                buildFieldCoverBulan(),
                const SizedBox(height: 12),
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
                buildFieldMjnscoverparId(),
                const SizedBox(height: 12),
                buildFieldRkonstruksiojkId(),
                const SizedBox(height: 12),
                buildFieldRokupasiId(),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  void _injectPayload(Calpar1CrudModel record) {
    debugPrint("🔥 Injecting payload into Form1...");

    fieldCoverBulanController.text = record.coverBulan.toString();
    fieldComboMJnscoverPar = record.comboMJnscoverPar;
    fieldComboRKonstruksiojk = record.comboRKonstruksiojk;
    fieldComboROkupasi = record.comboROkupasi;
    previousKonstruksi = record.comboRKonstruksiojk;

    setState(() {});
  }

  Future<bool> validateAndReturn() async {
    return _calparform1key.currentState?.validate() ?? false;
  }

  Future<void> saveForm1() async {
    final record = Calpar1CrudModel(
      calpar1Id: widget.recordId!,
<<<<<<< HEAD
      coverBulan: int.tryParse(fieldCoverBulanController.text.replaceAll(",", "")) ?? 12,
=======
      coverBulan: int.parse(fieldCoverBulanController.text),
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
      mjnscoverparId: fieldComboMJnscoverPar?.mjnscoverparId,
      rkonstruksiojkId: fieldComboRKonstruksiojk?.rkonstruksiojkId,
      rokupasiId: fieldComboROkupasi?.rokupasiId,
    );

    if (widget.viewMode == "tambah") {
      debugPrint("ini tambah loh di trigger di form1");
      calpar1Bloc.add(Calpar1CrudTambahEvent(record: record));
    } else {
      debugPrint("ini ubah loh di trigger di form1");
      calpar1Bloc.add(Calpar1CrudUbahEvent(record: record));
    }
  }

<<<<<<< HEAD
  // // Fields
  // Widget buildFieldCoverBulan() => appTextField(
  //   label: "Lama Cover",
  //   controller: fieldCoverBulanController,
  //   keyboardType: TextInputType.number,
  //   inputFormatters: [
  //     FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
  //     ThousandsSeparatorInputFormatter(),
  //   ],
  //   validator: (v) {
  //     if (v == null || v.isEmpty) return kStringNullError;
  //     final clean = v.replaceAll(",", "");
  //     final angka = double.tryParse(clean);
  //     if (angka == null || angka <= 0) return kString0;
  //     return null;
  //   },
  // );
=======
  // Fields
  Widget buildFieldCoverBulan() => appTextField(
    label: "Lama Cover",
    controller: fieldCoverBulanController,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
      ThousandsSeparatorInputFormatter(),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final clean = v.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka <= 0) return kString0;
      return null;
    },
  );
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398

  Widget buildFieldMjnscoverparId() => ReusableComboBox<ComboMJnscoverParModel>(
    hintText: "Jenis Cover",
    initItem: fieldComboMJnscoverPar,
    dataLoader: () => ComboMJnscoverParRepository().getComboMJnscoverPar(),
    displayText: (i) => i.jenisNama,
    compareItems: (a, b) => a.mjnscoverparId == b.mjnscoverparId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMJnscoverPar = v,
    onSaveCallback: (value) => fieldComboMJnscoverPar = value,
  );

  Widget buildFieldRkonstruksiojkId() => ReusableComboBox<ComboRKonstruksiojkModel>(
    hintText: "Konstruksi",
    comboKey: konstruksiKey,
    initItem: fieldComboRKonstruksiojk,
    dataLoader: () => ComboRKonstruksiojkRepository().getComboRKonstruksiojk(),
    displayText: (i) => i.kelasNama,
    compareItems: (a, b) => a.rkonstruksiojkId == b.rkonstruksiojkId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (item) async {
      if (item == null) return;

      final subtitle = getKonstruksiSubtitle(item.kelasNama);

      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: formGrey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.kelasNama,
                  style: bodyTextStyle(context),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 2),

                Text(
                  subtitle,
                  style: bodyTextStyle(context, fontSize: 15).copyWith(color: hintGrey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                Text(
                  "Apakah Anda yakin ingin memilih kelas ini?",
                  style: bodyTextStyle(context, fontSize: 15).copyWith(color: hintGrey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 13),

                Row(
                  children: [
                    Expanded(
                      child: AppButton.primary(
                        text: "Tidak",
                        backgroundColor: sGrey,
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton.primary(
                        text: "Iya",
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
      if (confirm == true) {
        setState(() {
          fieldComboRKonstruksiojk = item;
          previousKonstruksi = item;
        });
      }
      else {
        setState(() {
          konstruksiKey.currentState?.clear();
          fieldComboRKonstruksiojk = null;
          previousKonstruksi = null;
        });
      }
    },

    onSaveCallback: (value) => fieldComboRKonstruksiojk = value,
  );

  Widget buildFieldRokupasiId() => ReusableComboBox<ComboROkupasiModel>(
    hintText: "Okupasi",
    initItem: fieldComboROkupasi,
    dataLoader: () => ComboROkupasiRepository().getComboROkupasi(""),
    displayText: (item) => '${item.kodeOjk} - ${item.okupasiDesc}',
    compareItems: (a, b) => a.rokupasiId == b.rokupasiId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboROkupasi = v,
    onSaveCallback: (value) => fieldComboROkupasi = value,
  );
}
