import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:joss_app/widgets/combobox/combomstsclaim_widget.dart';

import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combomstsclaim_model.dart';

import 'package:joss_app/blocs/gen_klaim/klaim1list_bloc.dart';
import 'package:joss_app/blocs/gen_klaim/klaim1crud_bloc.dart';
import 'package:joss_app/models/gen_klaim/klaim1crud_model.dart';

import '../../klaim2list_list.dart';
import '../../klaim2list_main.dart';

/// =============================
///  KLAIM1 Inline Editor List
///  Layout & feel mengikuti Rekan PIC Inline Editor
///  Perbedaan: field & model mengikuti Klaim1 (insured, lokasi, tanggal, amount, mata uang, status)
///  + tombol View untuk menuju ke Klaim2ListMainPage
/// =============================
class Klaim1InlineEditorList extends StatefulWidget {
  const Klaim1InlineEditorList({super.key});

  @override
  State<Klaim1InlineEditorList> createState() => _Klaim1InlineEditorListState();
}

/// Bundle controller per baris
class _KlaimRowCtrls {
  final formKey = GlobalKey<FormState>();

  // Fields
  final insuredName = TextEditingController();
  final kejadianLokasi = TextEditingController();
  DateTime? kejadianTgl;
  final klaimAmount = TextEditingController();
  // Combos
  final mataUangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
  ComboRMatauangModel? rMatauang;

  final stsClaimKey = GlobalKey<DropdownSearchState<ComboMStsclaimModel>>();
  ComboMStsclaimModel? mStsclaim;

  void dispose() {
    insuredName.dispose();
    kejadianLokasi.dispose();
    klaimAmount.dispose();
  }
}

class _Klaim1InlineEditorListState extends State<Klaim1InlineEditorList> {
  late Klaim1ListBloc listBloc;
  late Klaim1CrudBloc crudBloc;
  final _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // Controllers utk item existing: key = klaim1Id
  final Map<String, _KlaimRowCtrls> _rowCtrls = {};
  // Controllers utk form tambah
  final _KlaimRowCtrls _newCtrls = _KlaimRowCtrls();

  final _scrollCtr = ScrollController();
  bool _showAddForm = false;
  bool _isSavingNew = false;
  final Map<String, bool> _isSavingById = {};

  @override
  void dispose() {
    for (final c in _rowCtrls.values) {
      c.dispose();
    }
    _newCtrls.dispose();
    _scrollCtr.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Klaim1ListBloc>().add(FetchKlaim1ListEvent());
    });
  }


  @override
  Widget build(BuildContext context) {
    listBloc = context.read<Klaim1ListBloc>();
    crudBloc = context.read<Klaim1CrudBloc>();

    // Layout avatar-like spacing mengikuti PIC screen
    const double avatarRadius = 50;
    const double avatarRingPadding = 3;
    const double avatarBorderWidth = 2;
    final double avatarDiameter = (avatarRadius + avatarRingPadding + avatarBorderWidth) * 2;
    const double overlayGap = 24;
    final double contentTopPadding = avatarDiameter + overlayGap;

    final content = BlocListener<Klaim1CrudBloc, Klaim1CrudState>(
      listener: (context, state) {
        if (state.isSaved) {
          listBloc.add(FetchKlaim1ListEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil disimpan')),
          );
          setState(() {
            _isSavingNew = false;
            _isSavingById.clear();
            _showAddForm = false;
          });
          _clearNewRow();
        }else if (state.hasFailure) {
          setState(() {
            _isSavingNew = false;
            _isSavingById.updateAll((_, __) => false);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan data')),
          );
        }
      },
      child: BlocBuilder<Klaim1ListBloc, Klaim1ListState>(
        builder: (context, state) {
          if (state.status == ListStatus.failure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal memuat data Klaim'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => listBloc.add(FetchKlaim1ListEvent()),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          _ensureRowControllers(state);

          return SingleChildScrollView(
            controller: _scrollCtr,
            padding: EdgeInsets.fromLTRB(hPadding, contentTopPadding + 8, hPadding, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header section
                Padding(
                  padding: EdgeInsets.only(bottom: fieldSpacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informasi Klaim",
                        style: TextStyle(
                          fontSize: getResponsiveFont(context, 22),
                          fontWeight: FontWeight.w600,
                          color: primaryLightColor,
                        ),
                      ),
                      Text(
                        "Data klaim utama: tertanggung, lokasi, tanggal kejadian, jumlah, mata uang, dan status.",
                        style: TextStyle(
                          fontSize: getResponsiveFont(context, 16),
                          color: sGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                if (state.items.isEmpty && !_showAddForm)
                  _emptyState()
                else if (state.items.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, idx) {
                      final item = state.items[idx];
                      final ctrls = _rowCtrls[item.klaim1Id]!;
                      final saving = _isSavingById[item.klaim1Id] ?? false;

                      return _buildEditorRowCard(
                        key: ValueKey('klaim-${item.klaim1Id}'),
                        title: 'Edit Klaim',
                        ctrls: ctrls,
                        isNew: false,
                        isSaving: saving,
                        onView: () => _goToKlaim2(item.klaim1Id),
                        onSave: saving ? null : () => _saveExisting(item.klaim1Id, ctrls),
                        onDelete: () => _confirmDelete(item.klaim1Id),
                      );
                    },
                  ),

                // Add form / button
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => SizeTransition(sizeFactor: anim, child: child),
                  child: _showAddForm
                      ? _buildEditorRowCard(
                    key: const ValueKey('add-form'),
                    title: 'Tambah Klaim Baru',
                    ctrls: _newCtrls,
                    isNew: true,
                    isSaving: _isSavingNew,
                    onView: null, // belum ada id saat add
                    onSave: _isSavingNew ? null : _saveNew,
                    onDelete: () {
                      setState(() {
                        _showAddForm = false;
                        _isSavingNew = false;
                      });
                      _clearNewRow();
                    },
                  )
                      : SizedBox(
                    key: const ValueKey('add-button'),
                    width: double.infinity,
                    height: 56,
                    child: AppButton.iconLeft(
                      text: 'Tambah Klaim',
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () async {
                        setState(() => _showAddForm = true);
                        await Future.delayed(const Duration(milliseconds: 50));
                        if (mounted) {
                          _scrollCtr.animateTo(
                            _scrollCtr.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      backgroundColor: primaryColor,
                      iconTextSpacing: 10,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Wrap ala side page (tanpa avatar overlay UI karena belum ada foto)
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: secondaryBlackColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20),
            ),
            border: Border(top: BorderSide(color: primaryColor, width: 4.0)),
          ),
          child: content,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          const Icon(Icons.receipt_long_outlined, size: 48, color: sGrey),
          const SizedBox(height: 8),
          Text('Belum ada data Klaim', style: TextStyle(color: sGrey)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: AppButton.iconLeft(
              text: 'Tambah Klaim Pertama',
              icon: const Icon(Icons.add),
              onPressed: () => setState(() => _showAddForm = true),
            ),
          )
        ],
      ),
    );
  }

  void _ensureRowControllers(Klaim1ListState state) {
    if (state.items.isEmpty) {
      _rowCtrls.clear();
      return;
    }
    for (final item in state.items) {
      if (!_rowCtrls.containsKey(item.klaim1Id)) {
        final c = _KlaimRowCtrls();
        c.insuredName.text = item.insuredName ?? '';
        c.kejadianLokasi.text = item.kejadianLokasi ?? '';
        c.klaimAmount.text = (item.klaimAmount == null || item.klaimAmount == 0)
            ? ''
            : NumberFormat("#,###").format(item.klaimAmount);
        try {
          c.kejadianTgl = item.kejadianTgl; // DateTime dari model list
        } catch (_) {}

        // combo prefill dari list model (kursId, rMATAUANGNAMA, lastStsclaimId, statusNama)
        c.rMatauang = ComboRMatauangModel(
          rmatauangKode: item.kursId,
          rmatauangNama: item.rMATAUANGNAMA,
        );
        c.mStsclaim = ComboMStsclaimModel(
          mstsclaimId: item.lastStsclaimId,
          statusNama: item.statusNama,
        );
        _rowCtrls[item.klaim1Id] = c;
      }
    }

    final ids = state.items.map((e) => e.klaim1Id).toSet();
    final remove = _rowCtrls.keys.where((id) => !ids.contains(id)).toList();
    for (final id in remove) {
      _rowCtrls[id]?.dispose();
      _rowCtrls.remove(id);
    }
  }

  Widget _buildEditorRowCard({
    Key? key,
    required String title,
    required _KlaimRowCtrls ctrls,
    required bool isNew,
    required VoidCallback? onSave,
    required VoidCallback onDelete,
    required VoidCallback? onView,
    bool isSaving = false,
  }) {
    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: pGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        side: const BorderSide(color: sGrey, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: ctrls.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + actions
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: getResponsiveFont(context, 20), fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),

                  if (onView != null)
                    Tooltip(
                      message: 'Lihat detail klaim',
                      child: OutlinedButton.icon(
                        onPressed: onView,
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: const Text('View'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryLightColor,
                          side: const BorderSide(color: primaryLightColor),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),

                  const SizedBox(width: 8),

                  // Save
                  Tooltip(
                    message: 'Simpan',
                    child: ElevatedButton(
                      onPressed: onSave,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: isSaving
                          ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.check, color: Colors.white),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Delete / Cancel
                  Tooltip(
                    message: isNew ? 'Batal' : 'Hapus',
                    child: OutlinedButton(
                      onPressed: onDelete,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isNew ? primaryLightColor : pRed),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: Icon(isNew ? Icons.close : Icons.delete, color: isNew ? primaryLightColor : pRed, size: 20),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Two-column responsive layout for bigger screens
              _twoCol(
                _fieldInsuredName(ctrls),
                _fieldKejadianLokasi(ctrls),
              ),

              const SizedBox(height: 12),

              _twoCol(
                _fieldTanggal(ctrls),
                _fieldAmountAndCurrency(ctrls),
              ),

              const SizedBox(height: 12),

              // Status
              Text('Status Klaim', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
              FormField<ComboMStsclaimModel>(
                validator: (_) => ctrls.mStsclaim == null ? 'Status harus dipilih' : null,
                builder: (ffState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildFieldComboMStsclaim(
                        comboKey: ctrls.stsClaimKey,
                        labelText: 'Pilih Status Klaim',
                        initItem: ctrls.mStsclaim,
                        onChangedCallback: (val) {
                          setState(() => ctrls.mStsclaim = val);
                          ffState.didChange(val);
                        },
                        onSaveCallback: (val) => ctrls.mStsclaim = val,
                        validatorCallback: (_) {},
                      ),
                      if (ffState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(ffState.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldInsuredName(_KlaimRowCtrls ctrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nama Tertanggung', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
        TextFormField(
          controller: ctrls.insuredName,
          decoration: customInputDecoration('Nama Tertanggung').copyWith(
            labelText: 'Nama Tertanggung',
            hintText: 'Masukkan nama tertanggung',
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Tidak boleh kosong' : null,
        ),
      ],
    );
  }

  Widget _fieldKejadianLokasi(_KlaimRowCtrls ctrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lokasi Kejadian', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
        TextFormField(
          controller: ctrls.kejadianLokasi,
          decoration: customInputDecoration('Lokasi Kejadian').copyWith(
            labelText: 'Lokasi Kejadian',
            hintText: 'Masukkan lokasi kejadian',
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Tidak boleh kosong' : null,
        ),
      ],
    );
  }

  Widget _fieldTanggal(_KlaimRowCtrls ctrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tanggal Kejadian', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
        DateTimeFormField(
          initialValue: ctrls.kejadianTgl ?? _today,             // ✅ default hari ini
          mode: DateTimeFieldPickerMode.date,
          dateFormat: DateFormat('yyyy-MM-dd'),
          firstDate: DateTime(2000, 1, 1),
          lastDate: _today,                                       // ✅ cegah pilih masa depan
          decoration: customInputDecoration('Tanggal Kejadian').copyWith(
            labelText: 'Tanggal Kejadian',
            hintText: 'Pilih tanggal',
            suffixIcon: const Icon(Icons.event),
          ),
          validator: (dt) => (dt == null) ? 'Tanggal harus diisi' : null,
          // Versi yang paling stabil untuk date_field:
          // onDateSelected: (dt) {
          //   setState(() {
          //     ctrls.kejadianTgl = DateTime(dt.year, dt.month, dt.day); // ✅ normalisasi
          //   });
          // },
          // Kalau kamu mau tetap pakai onChanged, boleh juga (pilih salah satu):
          onChanged: (dt) {
            if (dt == null) return;
            setState(() => ctrls.kejadianTgl = DateTime(dt.year, dt.month, dt.day));
          },
        ),
      ],
    );
  }

  Widget _fieldAmountAndCurrency(_KlaimRowCtrls ctrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jumlah Klaim & Mata Uang', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: ctrls.klaimAmount,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ThousandsFormatter(),
                ],
                decoration: customInputDecoration('Jumlah Kejadian').copyWith(
                  labelText: 'Jumlah Klaim',
                  hintText: 'cth: 10.000.000',
                ),
                validator: (v) {
                  final raw = v?.replaceAll('.', '').replaceAll(',', '') ?? '';
                  if (raw.isEmpty) return 'Tidak boleh kosong';
                  final parsed = double.tryParse(raw);
                  if (parsed == null) return 'Format tidak valid';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: FormField<ComboRMatauangModel>(
                validator: (_) => ctrls.rMatauang == null ? 'Wajib' : null,
                builder: (ffState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildFieldComboRMatauang(
                        comboKey: ctrls.mataUangKey,
                        labelText: 'Mata Uang',
                        initItem: ctrls.rMatauang,
                        onChangedCallback: (val) {
                          setState(() => ctrls.rMatauang = val);
                          ffState.didChange(val);
                        },
                        onSaveCallback: (val) => ctrls.rMatauang = val,
                        validatorCallback: (_) {},
                      ),
                      if (ffState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(ffState.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // === ACTIONS ===
  void _saveExisting(String recordId, _KlaimRowCtrls c) {
    if (!(c.formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSavingById[recordId] = true);

    final amountRaw = c.klaimAmount.text.replaceAll('.', '').replaceAll(',', '');
    final amount = double.tryParse(amountRaw) ?? 0;

    final record = Klaim1CrudModel(
      insuredName: c.insuredName.text.trim(),
      kejadianLokasi: c.kejadianLokasi.text.trim(),
      kejadianTgl: c.kejadianTgl ?? DateTime.now(),
      klaimAmount: amount,
      klaim1Id: recordId, // required by model
      kursId: c.rMatauang?.rmatauangKode, // map ke kursId
      comboRMatauang: c.rMatauang,
      lastStsclaimId: c.mStsclaim?.mstsclaimId,
      comboMStsclaim: c.mStsclaim,
    );
    crudBloc.add(Klaim1CrudUbahEvent(record: record));
  }

  void _saveNew() {
    final c = _newCtrls;
    if (!(c.formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSavingNew = true);

    final amountRaw = c.klaimAmount.text.replaceAll('.', '').replaceAll(',', '');
    final amount = double.tryParse(amountRaw) ?? 0;

    final record = Klaim1CrudModel(
      insuredName: c.insuredName.text.trim(),
      kejadianLokasi: c.kejadianLokasi.text.trim(),
      kejadianTgl: c.kejadianTgl ?? DateTime.now(),
      klaimAmount: amount,
      klaim1Id: '', // required in constructor → kosong saat add (server akan generate)
      kursId: c.rMatauang?.rmatauangKode,
      comboRMatauang: c.rMatauang,
      lastStsclaimId: c.mStsclaim?.mstsclaimId,
      comboMStsclaim: c.mStsclaim,
    );
    crudBloc.add(Klaim1CrudTambahEvent(record: record));
  }

  void _clearNewRow() {
    _newCtrls.insuredName.clear();
    _newCtrls.kejadianLokasi.clear();
    _newCtrls.klaimAmount.clear();
    _newCtrls.kejadianTgl = _today;
    _newCtrls.kejadianTgl = null;
    _newCtrls.rMatauang = null;
    _newCtrls.mStsclaim = null;
  }

  void _confirmDelete(String recordId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ShowDialogHapusWidget(
        onHapusFunction: (id) => crudBloc.add(Klaim1CrudHapusEvent(recordId: id)),
        recordId: recordId,
      ),
    ).then((_) {
      listBloc.add(CloseDialogKlaim1ListEvent());
    });
  }

  void _goToKlaim2(String klaim1Id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Klaim2ListPage(
        // sesuaikan ctor bila perlu
        // klaim1Id: klaim1Id,
      )),
    );
  }

  // Responsive helper (2 kolom di layar lebar)
  Widget _twoCol(Widget a, Widget b) {
    return LayoutBuilder(builder: (_, c) {
      final wide = c.maxWidth >= 720;
      if (!wide) return Column(children: [a, const SizedBox(height: 12), b]);
      return Row(children: [Expanded(child: a), const SizedBox(width: 12), Expanded(child: b)]);
    });
  }
}

/// Simple thousands separator formatter (ID style)
class _ThousandsFormatter extends TextInputFormatter {
  final _nf = NumberFormat("#,###");
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    }
    final number = int.parse(digits);
    final newText = _nf.format(number);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
