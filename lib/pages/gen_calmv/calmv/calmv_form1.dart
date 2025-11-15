// lib/pages/calmv/calmv_form1.dart
// (versi kamu + tambahan method di bawah)

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
import 'package:joss_app/models/gen_calmv/calmv1crud_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/repositories/combobox/combommvgrupojk_repository.dart';
import 'package:joss_app/repositories/combobox/combommvjnscover_repository.dart';
import 'package:joss_app/repositories/combobox/combomwilayah_repository.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

import '../../../blocs/reusable_connection_flow/flow_parent_cubit.dart';


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
  final _formKey1 = GlobalKey<FormState>();

  // Controllers
  final fieldCoverBulanController = TextEditingController();
  final fieldCurrIdController = TextEditingController();
  final fieldHargaController = TextEditingController();
  final fieldThnBuatController = TextEditingController();

  ComboMMvgrupOjkModel? fieldComboMMvgrupOjk;
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  ComboMWilayahModel? fieldComboMWilayah;

  late final Calmv1CrudBloc calmv1Bloc;
  String? _localCalmv1Id;

  @override
  void initState() {
    super.initState();
    calmv1Bloc = context.read<Calmv1CrudBloc>();
    _localCalmv1Id = widget.recordId;
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
    fieldThnBuatController.dispose();
    super.dispose();
  }

  void activate() {
    setState(() {});

    // Load ulang data HANYA saat card sedang dibuka
    if (_localCalmv1Id != null && widget.isExpanded) {
      calmv1Bloc.add(Calmv1CrudLihatEvent(recordId: _localCalmv1Id!));
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<Calmv1CrudBloc, Calmv1CrudState>(
      listener: (context, state) {
        // LOAD
        if (widget.isExpanded && state.isLoaded && state.record != null) {
          final r = state.record!;
          fieldCoverBulanController.text = r.coverBulan.toString();
          fieldCurrIdController.text = r.currId;
          fieldHargaController.text = NumberFormat("#,###").format(r.harga);
          fieldThnBuatController.text = r.thnBuat.toString();

          fieldComboMMvgrupOjk = state.comboMMvgrupOjk;
          fieldComboMMvjnscover = state.comboMMvjnscover;
          fieldComboMWilayah = state.comboMWilayah;
        }

        // SAVE SUCCESS
        if (state.isSaved && !state.hasFailure) {
          _localCalmv1Id = state.record?.calmv1Id;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data kendaraan disimpan!")),
          );

          // beritahu ibu kalau save sukses
          if (_localCalmv1Id != null) {
            context.read<FlowParentCubit>().onSaveResult(
              index: 0,
              id: _localCalmv1Id!,
            );
          }
        }

        // FAIL
        if (state.hasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal menyimpan data kendaraan")),
          );
        }
      },
      child: Card(
        color: pGrey,
        child: Column(
          children: [
            _buildHeader(),
            if (widget.isExpanded) _buildForm(),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Form(
        key: _formKey1,
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
                Flexible(child: _buildCurrId()),
                const SizedBox(width: 8),
                Flexible(child: _buildThnBuat()),
              ],
            ),
            const SizedBox(height: 12),
            _buildComboMWilayah(),
            const SizedBox(height: 12),
            _buildCoverBulan(),

            const SizedBox(height: 15),
            // AppButton.primary(
            //   text: "Simpan",
            //   onPressed: _saveForm,
            // ),
          ],
        ),
      ),
    );
  }

  // ========= DIPAKAI IBU =========

  Future<void> validateSelf() async {
    final isValid = _formKey1.currentState?.validate() ?? false;

    context.read<FlowParentCubit>().onValidationResult(
      index: 0,
      isValid: isValid,
    );
  }

  Future<void> saveSelf() async {
    _saveForm();
  }

  // ========= SAVE INTERNAL =========

  void _saveForm() {
    if (!_formKey1.currentState!.validate()) {
      context.read<FlowParentCubit>().onValidationResult(
        index: 0,
        isValid: false,
      );
      return;
    }

    final id = _localCalmv1Id ?? "";
    final record = Calmv1CrudModel(
      calmv1Id: id,
      harga: double.tryParse(fieldHargaController.text.replaceAll(",", "")) ?? 0,
      currId: fieldCurrIdController.text,
      coverBulan: int.tryParse(fieldCoverBulanController.text.replaceAll(",", "")) ?? 0,
      thnBuat: int.tryParse(fieldThnBuatController.text.replaceAll(",", "")) ?? 0,
      mmvgrupojkId: fieldComboMMvgrupOjk?.mmvgrupojkId,
      mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
      mwilayahId: fieldComboMWilayah?.mwilayahId,
    );

    final isTambah = id.isEmpty;

    calmv1Bloc.add(
      isTambah
          ? Calmv1CrudTambahEvent(record: record)
          : Calmv1CrudUbahEvent(record: record),
    );
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

  Widget _buildHarga() => appTextField(
    label: "Harga Kendaraan",
    controller: fieldHargaController,
    keyboardType: TextInputType.number,
    inputFormatters: [ThousandsSeparatorInputFormatter()],
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final clean = v.replaceAll(",", "");
      final angka = double.tryParse(clean);
      if (angka == null || angka <= 0) return kString0;
      return null;
    },
  );

  Widget _buildCurrId() => appTextField(
    label: "Currency",
    controller: fieldCurrIdController,
    validator: (v) => v == null || v.isEmpty ? kStringNullError : null,
  );

  Widget _buildThnBuat() => appTextField(
    label: "Tahun Buat",
    controller: fieldThnBuatController,
    keyboardType: TextInputType.number,
    validator: (v) => v == null || v.isEmpty ? kStringNullError : null,
  );

  Widget _buildCoverBulan() => appTextField(
    label: "Lama Cover",
    controller: fieldCoverBulanController,
    keyboardType: TextInputType.number,
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final clean = v.replaceAll(",", "");
      final lama = int.tryParse(clean);
      if (lama == null || lama <= 0) return "Harus lebih dari 0 bulan";
      if (lama > 120) return "Maksimal 120 bulan";
      return null;
    },
  );
}
