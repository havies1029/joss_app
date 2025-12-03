import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
import 'package:joss_app/models/gen_calmv/calmv1crud_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/repositories/combobox/combommvgrupojk_repository.dart';
import 'package:joss_app/repositories/combobox/combommvjnscover_repository.dart';
import 'package:joss_app/repositories/combobox/combomwilayah_repository.dart';


import '../../../../models/combobox/combommvpakai_model.dart';
import '../../../../models/combobox/combormatauang_model.dart';
import '../../../../repositories/combobox/combommvpakai_repository.dart';
import '../../../../repositories/combobox/combormatauang_repository.dart';


class CalmvForm1Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;

  const CalmvForm1Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
  });

  @override
  State<CalmvForm1Section> createState() => CalmvForm1SectionState();
}

class CalmvForm1SectionState extends State<CalmvForm1Section> {
  final _calmvform1key = GlobalKey<FormState>();

  // Controllers
  final fieldCoverBulanController = TextEditingController();
  final fieldCurrIdController = TextEditingController();
  final fieldHargaController = TextEditingController();

  ComboMMvgrupOjkModel? fieldComboMMvgrupOjk;
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  ComboMWilayahModel? fieldComboMWilayah;
  ComboRMatauangModel? fieldComboUang;
  ComboMMvpakaiModel? fieldComboMMvpakai;
  // final comboMMvpakaiKey = GlobalKey<DropdownSearchState<ComboMMvpakaiModel>>();

  String selectedYear = "";

  late final Calmv1CrudBloc calmv1Bloc;

  @override
  void initState() {
    super.initState();
    calmv1Bloc = context.read<Calmv1CrudBloc>();
    Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      calmv1Bloc.add(Calmv1CrudLihatEvent(recordId: widget.recordId!));
    }
  }

  @override
  void dispose() {
    fieldCoverBulanController.dispose();
    fieldCurrIdController.dispose();
    fieldHargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          _buildHeader(),
          if (widget.isExpanded) _buildForm(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: Text("Data Kendaraan", style: bodyTextStyle(context)),
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
    return BlocBuilder<Calmv1CrudBloc, Calmv1CrudState>(
      buildWhen: (prev, curr) => curr.isLoaded == true,
      builder: (context, state) {
        if (state.isLoaded && state.record != null) {
          _injectPayload(state.record!);
        }

        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Form(
            key: _calmvform1key,
            child: Column(
              children: [
                _buildComboMMvgrupOjk(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(child: _buildComboMMvjnscover()),
                    const SizedBox(width: 8),
                    Flexible(child: _buildHarga()),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(child: _buildComboCurddId()),
                    const SizedBox(width: 8),
                    Flexible(child: buildFieldComboTahun()),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(child: _buildFieldMmvpakaiId()),
                    const SizedBox(width: 8),
                    Flexible(child: _buildComboMWilayah()),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  void _injectPayload(Calmv1CrudModel record) {
    debugPrint("🔥 Injecting payload into Form1...");

    // Text Controllers
    fieldCoverBulanController.text = record.coverBulan.toString();
    fieldCurrIdController.text = record.currId.toString();
    fieldHargaController.text = record.harga.toString();
    selectedYear = record.thnBuat.toString();

    // Dropdown Values
    fieldComboMMvgrupOjk = record.comboMMvgrupOjk;
    fieldComboMMvjnscover = record.comboMMvjnscover;
    fieldComboMWilayah = record.comboMWilayah;

    // Currency combo (jaga-jaga)
    // fieldComboUang = record.currId.toString();
    // Kalau backend punya field lain untuk currency,
    // ganti ke record.comboMmataUang / record.comboCurrId
    // sesuai design API

    setState(() {});
  }

  Future<bool> validateAndReturn() async {
    return _calmvform1key.currentState?.validate() ?? false;
  }


  Future<void> saveForm1() async {
    final record = Calmv1CrudModel(
      calmv1Id: widget.recordId!,
      harga: double.tryParse(fieldHargaController.text.replaceAll(",", "")) ?? 0,
      currId: fieldComboUang?.rmatauangKode ?? "",
      coverBulan: int.tryParse(fieldCoverBulanController.text.replaceAll(",", "")) ?? 12,
      thnBuat: int.tryParse(selectedYear) ?? 0,
      mmvgrupojkId: fieldComboMMvgrupOjk?.mmvgrupojkId,
      mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
      mmvpakaiId: fieldComboMMvpakai?.mmvpakaiId,
      mwilayahId: fieldComboMWilayah?.mwilayahId,
    );

    if (widget.viewMode == "tambah") {
      debugPrint("ini tambah loh di trigger di form1");
      calmv1Bloc.add(Calmv1CrudTambahEvent(record: record));
    } else {
      debugPrint("ini ubah loh di trigger di form1");
      calmv1Bloc.add(Calmv1CrudUbahEvent(record: record));
    }

  }

  // --- UI COMPONENTS (sama seperti punyamu) ---
  Widget _buildComboMMvgrupOjk() => ReusableComboBox<ComboMMvgrupOjkModel>(
    hintText: "Jenis Kendaraan",
    initItem: fieldComboMMvgrupOjk,
    dataLoader: () => ComboMMvgrupOjkRepository().getComboMMvgrupOjk(),
    displayText: (i) => i.grupNama,
    compareItems: (a, b) => a.mmvgrupojkId == b.mmvgrupojkId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMMvgrupOjk = v,
    onSaveCallback: (value) => fieldComboMMvgrupOjk = value,
  );

  Widget _buildComboMMvjnscover() => ReusableComboBox<ComboMMvjnscoverModel>(
    hintText: "Jenis Cover",
    initItem: fieldComboMMvjnscover,
    dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
    displayText: (i) => i.coverName,
    compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMMvjnscover = v,
    onSaveCallback: (value) => fieldComboMMvjnscover = value,
  );

  Widget _buildComboMWilayah() => ReusableComboBox<ComboMWilayahModel>(
    hintText: "Wilayah",
    initItem: fieldComboMWilayah,
    dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
    displayText: (i) => i.wilayahNama,
    compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMWilayah = v,
    onSaveCallback: (value) => fieldComboMWilayah = value,
  );

  Widget _buildComboCurddId() => ReusableComboBox<ComboRMatauangModel>(
    hintText: "Mata Uang",
    initItem: fieldComboUang,
    dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
    displayText: (item) => item.rmatauangNama,
    compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboUang = v,
    onSaveCallback: (value) => fieldComboUang = value,
  );

  Widget _buildFieldMmvpakaiId() => ReusableComboBox<ComboMMvpakaiModel>(
    hintText: "Penggunaan",
    initItem: fieldComboMMvpakai,
    dataLoader: () => ComboMMvpakaiRepository().getComboMMvpakai(),
    displayText: (item) => item.pakaiNama,
    compareItems: (a, b) => a.mmvpakaiId == b.mmvpakaiId,
    validatorCallback: (v) => v == null ? kStringNullError : null,
    onChangedCallback: (v) => fieldComboMMvpakai = v,
    onSaveCallback: (value) => fieldComboMMvpakai = value,
  );

  Widget buildFieldComboTahun() {
    // Buat list tahun dari sekarang → 1980
    final yearNow = DateTime.now().year;
    final years = List<String>.generate(
      yearNow - 1980 + 1,
          (i) => (yearNow - i).toString(),
    );

    return ReusableComboBox<String>(
      hintText: "Tahun Pembuatan",
      initItem: selectedYear.isNotEmpty ? selectedYear : null, // kalau mode ubah
      dataLoader: () async => years,
      displayText: (item) => item,
      compareItems: (a, b) => a == b,

      // Validator
      validatorCallback: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        return null;
      },

      onChangedCallback: (value) {
        selectedYear = value ?? "";
      },

      onSaveCallback: (value) {
        selectedYear = value ?? "";
      },
    );
  }

  Widget _buildHarga() => appTextField(
    label: "Harga Kendaraan",
    controller: fieldHargaController,
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



}
