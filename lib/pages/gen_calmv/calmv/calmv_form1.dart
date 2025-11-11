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

import '../../../blocs/reusable_connection_flow/reusable_connection_flow_bloc.dart';
import '../../../blocs/reusable_connection_flow/reusable_connection_flow_state.dart';

class CalmvForm1Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;

  /// Exposed key (opsional, untuk trigger save dari luar)
  final GlobalKey<CalmvForm1SectionState>? externalKey;

  const CalmvForm1Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.externalKey,
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
  final comboMMvgrupOjkKey = GlobalKey<DropdownSearchState<ComboMMvgrupOjkModel>>();

  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  final comboMMvjnscoverKey = GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();

  ComboMWilayahModel? fieldComboMWilayah;
  final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();

  late final Calmv1CrudBloc calmv1CrudBloc;
  String? _localCalmv1Id;

  @override
  void initState() {
    super.initState();
    calmv1CrudBloc = context.read<Calmv1CrudBloc>();
    _localCalmv1Id = widget.recordId;
    Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      calmv1CrudBloc.add(Calmv1CrudLihatEvent(recordId: widget.recordId!));
    }
  }

  bool validateFormFields() {
    final isValid = _formKey1.currentState?.validate() ?? false;
    final flow = context.read<ReusableConnectionFlow>();
    flow.markForm1Valid(isValid);
    return isValid;
  }

  Future<void> autoSaveWithFlow() async {
    final flow = context.read<ReusableConnectionFlow>();
    flow.markForm1Saving();
    _autoSaveIfNeeded();
  }


  /// ✅ Public function (bisa dipanggil parent)
  Future<bool> saveAndDispatch() async {
    if (!_formKey1.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(errorSnackBar("Lengkapi Data Kendaraan terlebih dahulu"));
      return false;
    }
    _formKey1.currentState!.save();
    _autoSaveIfNeeded();
    return true;
  }

  @override
  void dispose() {
    fieldCoverBulanController.dispose();
    fieldCurrIdController.dispose();
    fieldHargaController.dispose();
    fieldThnBuatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flow = context.read<ReusableConnectionFlow>();

    return BlocListener<Calmv1CrudBloc, Calmv1CrudState>(
      listener: (context, state) {
        if (state.isSaved && !state.hasFailure) {
          final calmv1Id = state.record?.calmv1Id ?? '';
          setState(() {
            _localCalmv1Id = calmv1Id;
          });

          /// 🔹 laporkan ke flow mediator
          flow.markForm1Saved(calmv1Id);
          flow.moveTo("form2");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Data kendaraan disimpan (ID: $calmv1Id)')),
          );
        }

        if (state.hasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Gagal menyimpan data kendaraan')),
          );
        }

        if (state.isLoaded && state.record != null) {
          final r = state.record!;
          fieldCoverBulanController.text = r.coverBulan.toString();
          fieldCurrIdController.text = r.currId;
          fieldHargaController.text = NumberFormat("#,###").format(r.harga);
          fieldThnBuatController.text = r.thnBuat.toString();
          fieldComboMMvgrupOjk = state.comboMMvgrupOjk;
          fieldComboMMvjnscover = state.comboMMvjnscover;
          fieldComboMWilayah = state.comboMWilayah;
        }
      },
      child: Card(
        color: pGrey,
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              title: Text('Data Kendaraan', style: bodyTextStyle(context)),
              trailing: AnimatedRotation(
                turns: widget.isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: SvgPicture.asset('assets/icons/dropdown.svg',
                    width: 16, height: 16),
              ),
              onTap: () async {
                final willCollapse = widget.isExpanded;

                // 🔹 Jika user menutup form, lakukan auto-save
                if (willCollapse) {
                  if (!_formKey1.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar("Lengkapi Data Kendaraan terlebih dahulu"),
                    );
                    return;
                  }
                  _autoSaveIfNeeded();
                }

                widget.onToggle(!widget.isExpanded);
              },
            ),
            if (widget.isExpanded)
              Padding(
                padding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Form(
                  key: _formKey1,
                  child: Column(
                    children: [
                      _buildComboMMvgrupOjk(),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(flex: 1, child: _buildComboMMvjnscover()),
                          const SizedBox(width: 8),
                          Flexible(flex: 1, child: _buildHarga()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(flex: 1, child: _buildCurrId()),
                          const SizedBox(width: 8),
                          Flexible(flex: 1, child: _buildThnBuat()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildComboMWilayah(),
                      const SizedBox(height: 12),
                      _buildCoverBulan(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Combo builders ---
  Widget _buildComboMMvgrupOjk() => ReusableComboBox<ComboMMvgrupOjkModel>(
    comboKey: comboMMvgrupOjkKey,
    hintText: "Jenis Kendaraan",
    initItem: fieldComboMMvgrupOjk,
    dataLoader: () => ComboMMvgrupOjkRepository().getComboMMvgrupOjk(),
    displayText: (item) => item.grupNama,
    compareItems: (a, b) => a.mmvgrupojkId == b.mmvgrupojkId,
    onChangedCallback: (value) {
      if (value != null) {
        // 🔒 pastikan state tetap menyimpan object model
        setState(() {
          fieldComboMMvgrupOjk = ComboMMvgrupOjkModel(
            mmvgrupojkId: value.mmvgrupojkId,
            grupNama: value.grupNama, // simpan juga name-nya
          );
        });
        calmv1CrudBloc.add(
          ComboMMvgrupOjkChangedEvent(comboMMvgrupOjk: value),
        );
        // context.read<ReusableConnectionFlow>().resetForm1Status();
      }
    },
    onSaveCallback: (value) => fieldComboMMvgrupOjk = value,
    validatorCallback: (value) =>
    value == null ? kStringNullError : null,
  );

  Widget _buildComboMMvjnscover() => ReusableComboBox<ComboMMvjnscoverModel>(
    comboKey: comboMMvjnscoverKey,
    hintText: "Jenis Cover",
    initItem: fieldComboMMvjnscover,
    dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
    displayText: (item) => item.coverName,
    compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
    onChangedCallback: (value) {
      if (value != null) {
        setState(() {
          fieldComboMMvjnscover = ComboMMvjnscoverModel(
            mmvjnscoverId: value.mmvjnscoverId,
            coverName: value.coverName,
          );
        });
        calmv1CrudBloc.add(
          ComboMMvjnscoverChangedEvent(comboMMvjnscover: value),
        );
      }
    },
    onSaveCallback: (value) => fieldComboMMvjnscover = value,
    validatorCallback: (value) =>
    value == null ? kStringNullError : null,
  );

  Widget _buildComboMWilayah() => ReusableComboBox<ComboMWilayahModel>(
    comboKey: comboMWilayahKey,
    hintText: "Wilayah",
    initItem: fieldComboMWilayah,
    dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
    displayText: (item) => item.wilayahNama,
    compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
    onChangedCallback: (value) {
      if (value != null) {
        setState(() {
          fieldComboMWilayah = ComboMWilayahModel(
            mwilayahId: value.mwilayahId,
            wilayahNama: value.wilayahNama,
          );
        });
        calmv1CrudBloc.add(
          ComboMWilayahChangedEvent(comboMWilayah: value),
        );
      }
    },
    onSaveCallback: (value) => fieldComboMWilayah = value,
    validatorCallback: (value) =>
    value == null ? kStringNullError : null,
  );

  Widget _buildThnBuat() => appTextField(
    label: 'Tahun Buat',
    controller: fieldThnBuatController,
    keyboardType: TextInputType.number,
    inputFormatters: [ThousandsSeparatorInputFormatter()],
    validator: (v) => (v == null || v.isEmpty) ? kStringNullError : null,
  );

  Widget _buildCoverBulan() => appTextField(
    label: "Lama Cover",
    hint: "0",
    controller: fieldCoverBulanController,
    keyboardType: TextInputType.number,
    suffix: Text("bulan", style: bodyTextStyle(context)),
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final clean = v.replaceAll(",", "");
      final lama = int.tryParse(clean);
      if (lama == null || lama <= 0)
        return "Lama cover harus lebih dari 0 bulan";
      if (lama > 120) return "Lama cover maksimal 120 bulan";
      return null;
    },
  );

  Widget _buildCurrId() => appTextField(
    label: 'Currency',
    controller: fieldCurrIdController,
    validator: (v) => (v == null || v.isEmpty) ? kStringNullError : null,
  );

  Widget _buildHarga() => appTextField(
    label: "Harga Kendaraan",
    controller: fieldHargaController,
    keyboardType: TextInputType.number,
    suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      final clean = v.replaceAll(",", "");
      final harga = double.tryParse(clean);
      if (harga == null || harga <= 0) return kString0;
      return null;
    },
  );

  // --- Auto Save Logic ---
  void _autoSaveIfNeeded() {
    try {
      // Gunakan _localCalmv1Id yang selalu update setelah insert sukses
      final currentId = _localCalmv1Id ?? widget.recordId ?? '';
      debugPrint("🧩 [Form1] Mulai auto-save, currentId=$currentId");

      final record = Calmv1CrudModel(
        calmv1Id: currentId,
        harga: double.tryParse(fieldHargaController.text.replaceAll(',', '')) ?? 0,
        currId: fieldCurrIdController.text,
        coverBulan: int.tryParse(fieldCoverBulanController.text.replaceAll(',', '')) ?? 0,
        thnBuat: int.tryParse(fieldThnBuatController.text.replaceAll(',', '')) ?? 0,
        mmvgrupojkId: fieldComboMMvgrupOjk?.mmvgrupojkId,
        mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
        mwilayahId: fieldComboMWilayah?.mwilayahId,
      );

      final isTambah = currentId.isEmpty;
      debugPrint("🧱 [Form1] Record dibuat: ${record.toJson()}");
      debugPrint("🧱 [Form1] Mode = ${isTambah ? 'TAMBAH' : 'UBAH'}");

      final event = isTambah
          ? Calmv1CrudTambahEvent(record: record)
          : Calmv1CrudUbahEvent(record: record);
      calmv1CrudBloc.add(event);

      // ✅ Kalau mode tambah, pantau hasilnya lewat listener
      // Listener akan simpan ID di _localCalmv1Id otomatis
    } catch (e) {
      debugPrint("❌ [Form1] ERROR auto-save: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal auto-save data kendaraan: $e')),
      );
    }
  }

  void debugPrintForm1Values([String contextTag = ""]) {
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    debugPrint("🔎 [Form1 Debug] $contextTag");

    debugPrint("fieldHargaController.text        = ${fieldHargaController.text}");
    debugPrint("fieldCurrIdController.text       = ${fieldCurrIdController.text}");
    debugPrint("fieldCoverBulanController.text   = ${fieldCoverBulanController.text}");
    debugPrint("fieldThnBuatController.text      = ${fieldThnBuatController.text}");

    debugPrint("ComboMMvgrupOjk:");
    debugPrint("   ▶ id   = ${fieldComboMMvgrupOjk?.mmvgrupojkId}");
    debugPrint("   ▶ name = ${fieldComboMMvgrupOjk?.grupNama}");

    debugPrint("ComboMMvjnscover:");
    debugPrint("   ▶ id   = ${fieldComboMMvjnscover?.mmvjnscoverId}");
    debugPrint("   ▶ name = ${fieldComboMMvjnscover?.coverName}");

    debugPrint("ComboMWilayah:");
    debugPrint("   ▶ id   = ${fieldComboMWilayah?.mwilayahId}");
    debugPrint("   ▶ name = ${fieldComboMWilayah?.wilayahNama}");

    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  }

}
