// lib/pages/gen_klaim/widgets/klaim1_list_editor.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/models/gen_klaim/klaim1crud_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combomstsclaim_model.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:joss_app/widgets/combobox/combomstsclaim_widget.dart';
import 'package:joss_app/blocs/gen_klaim/klaim1list_bloc.dart';

import '../../../../../repositories/combobox/combomstsclaim_repository.dart';
import '../../../../../repositories/combobox/combormatauang_repository.dart';

class Klaim1ListEditor extends StatefulWidget {
  final Map<String, bool> isSavingById;
  final void Function(String id, Klaim1CrudModel record) onSaveExisting;
  final void Function(String id) onDelete;
  final void Function(String id) onView;

  const Klaim1ListEditor({
    super.key,
    required this.isSavingById,
    required this.onSaveExisting,
    required this.onDelete,
    required this.onView,
  });

  @override
  State<Klaim1ListEditor> createState() => _Klaim1ListEditorState();
}

class _RowCtrls {
  final formKey = GlobalKey<FormState>();
  final insuredName = TextEditingController();
  final kejadianLokasi = TextEditingController();
  final klaimAmount = TextEditingController();
  DateTime? kejadianTgl;

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

class _Klaim1ListEditorState extends State<Klaim1ListEditor> {
  final Map<String, _RowCtrls> _rowCtrls = {};
  final _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void dispose() {
    for (final c in _rowCtrls.values) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Klaim1ListBloc, Klaim1ListState>(
      buildWhen: (p, c) => p.items != c.items || p.status != c.status,
      builder: (context, state) {

        debugPrint("📢 Klaim1ListState update:");
        debugPrint("Status: ${state.status}");
        debugPrint("Jumlah items: ${state.items.length}");

        for (final item in state.items) {
          debugPrint(
              "👉 ID: ${item.klaim1Id}, "
                  "Nama: ${item.insuredName}, "
                  "Lokasi: ${item.kejadianLokasi}, "
                  "Tanggal: ${item.kejadianTgl}, "
                  "Amount: ${item.klaimAmount}, "
                  "Mata Uang: ${item.rmatauangNama}, "
                  "Status: ${item.statusNama}"
          );
        }
        if (state.status == ListStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Gagal memuat data Klaim'),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.read<Klaim1ListBloc>().add(FetchKlaim1ListEvent()),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        }

        _ensureRowControllers(state);

        if (state.items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: const [
                Icon(Icons.receipt_long_outlined, size: 48, color: sGrey),
                SizedBox(height: 8),
                Text('Belum ada data Klaim', style: TextStyle(color: sGrey)),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, idx) {
            final item = state.items[idx];
            final ctrls = _rowCtrls[item.klaim1Id]!;
            final saving = widget.isSavingById[item.klaim1Id] ?? false;

            return Card(
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
                      Row(
                        children: [
                          Text('Edit Klaim',
                              style: TextStyle(fontSize: getResponsiveFont(context, 20), fontWeight: FontWeight.w700)),
                          const Spacer(),
                          Tooltip(
                            message: 'Lihat detail klaim',
                            child: OutlinedButton.icon(
                              onPressed: () => widget.onView(item.klaim1Id),
                              icon: const Icon(Icons.visibility_outlined, size: 18),
                              label: const Text('View'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryLightColor,
                                side: const BorderSide(color: primaryLightColor),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                            ),
                          ),
                          // const SizedBox(width: 8),
                          // Tooltip(
                          //   message: 'Simpan',
                          //   child: ElevatedButton(
                          //     onPressed: saving ? null : () => _saveExisting(item.klaim1Id, ctrls),
                          //     style: ElevatedButton.styleFrom(
                          //       padding: const EdgeInsets.all(12),
                          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          //     ),
                          //     child: saving
                          //         ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          //         : const Icon(Icons.check, color: Colors.white),
                          //   ),
                          // ),
                          // const SizedBox(width: 8),
                          // Tooltip(
                          //   message: 'Hapus',
                          //   child: OutlinedButton(
                          //     onPressed: () => _confirmDelete(context, item.klaim1Id),
                          //     style: OutlinedButton.styleFrom(
                          //       side: const BorderSide(color: pRed),
                          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          //       padding: const EdgeInsets.all(12),
                          //     ),
                          //     child: const Icon(Icons.delete, color: pRed, size: 20),
                          //   ),
                          // ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      _twoCol(
                        appTextField(
                          label: "Nama Tertanggung",
                          hint: "Masukkan Nama Tertanggung",
                          controller: ctrls.insuredName,
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Tidak boleh kosong' : null,
                        ),
                        appTextField(
                          label: "Lokasi Kejadian",
                          hint: "Masukkan Lokasi Kejadian",
                          controller: ctrls.kejadianLokasi,
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Tidak boleh kosong' : null,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _twoCol(
                        _fieldTanggal(ctrls),
                        _fieldAmountAndCurrency(ctrls),
                      ),

                      const SizedBox(height: 12),

                      Text('Status Klaim', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
                      FormField<ComboMStsclaimModel>(
                        validator: (_) => ctrls.mStsclaim == null ? 'Status harus dipilih' : null,
                        builder: (ffState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // buildFieldComboMStsclaim(
                              //   comboKey: ctrls.stsClaimKey,
                              //   labelText: 'Pilih Status Klaim',
                              //   initItem: ctrls.mStsclaim,
                              //   onChangedCallback: (val) {
                              //     setState(() => ctrls.mStsclaim = val);
                              //     ffState.didChange(val);
                              //   },
                              //   onSaveCallback: (val) => ctrls.mStsclaim = val,
                              //   validatorCallback: (_) => null,
                              // ),
                              ReusableComboBox<ComboMStsclaimModel>(
                                hintText: "Status",
                                searchHintText: "Pilih Status Klaim",
                                comboKey: ctrls.stsClaimKey,
                                initItem: ctrls.mStsclaim,
                                dataLoader: () => ComboMStsclaimRepository().getComboMStsclaim(),
                                displayText: (item) => item.statusNama,
                                compareItems: (a, b) => a.mstsclaimId == b.mstsclaimId,
                                isEnabled: false,
                                onChangedCallback: (val) {
                                  setState(() => ctrls.mStsclaim = val);
                                  ffState.didChange(val);
                                },
                                onSaveCallback: (val) => ctrls.mStsclaim = val,
                                validatorCallback: (value) {
                                  if (value == null) {
                                    return kStringNullError;
                                  }
                                  return null;
                                },
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
          },
        );
      },
    );
  }

  void _ensureRowControllers(Klaim1ListState state) {
    if (state.items.isEmpty) {
      _rowCtrls.clear();
      return;
    }
    for (final item in state.items) {
      if (!_rowCtrls.containsKey(item.klaim1Id)) {
        final c = _RowCtrls();
        c.insuredName.text = item.insuredName ?? '';
        c.kejadianLokasi.text = item.kejadianLokasi ?? '';
        c.klaimAmount.text = (item.klaimAmount == null || item.klaimAmount == 0)
            ? ''
            : NumberFormat.decimalPattern('id').format(item.klaimAmount);
        c.kejadianTgl = item.kejadianTgl ?? _today;
        c.rMatauang = ComboRMatauangModel(rmatauangKode: item.kursId, rmatauangNama: item.rmatauangNama);
        c.mStsclaim = ComboMStsclaimModel(mstsclaimId: item.lastStsclaimId, statusNama: item.statusNama);
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

  Widget _fieldTanggal(_RowCtrls ctrls) {
    final last = (ctrls.kejadianTgl != null && ctrls.kejadianTgl!.isAfter(_today)) ? ctrls.kejadianTgl! : _today;

    return AppDateField(
      label: 'Tanggal Kejadian',
      hint: 'Pilih tanggal',
      initialValue: ctrls.kejadianTgl ?? _today,
      firstDate: DateTime(2000, 1, 1),
      lastDate: last,
      validator: (dt) => (dt == null) ? 'Tanggal harus diisi' : null,
      onChanged: (dt) {
        setState(() {
          ctrls.kejadianTgl = DateTime(dt!.year, dt.month, dt.day);
        });
      },
    );
  }

  Widget _fieldAmountAndCurrency(_RowCtrls ctrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jumlah Klaim & Mata Uang', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: appTextField(
                label: "Jumlah Klaim",
                hint: "cth: 10.000.000",
                controller: ctrls.klaimAmount,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandsFormatterId(),
                ],
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
                      // buildFieldComboRMatauang(
                      //   comboKey: ctrls.mataUangKey,
                      //   labelText: 'Mata Uang',
                      //   initItem: ctrls.rMatauang,
                      //   onChangedCallback: (val) {
                      //     setState(() => ctrls.rMatauang = val);
                      //     ffState.didChange(val);
                      //   },
                      //   onSaveCallback: (val) => ctrls.rMatauang = val,
                      //   validatorCallback: (_) => null,
                      // ),
                      ReusableComboBox<ComboRMatauangModel>(
                        hintText: "Mata Uang",
                        searchHintText: "Cari Mata Uang...",
                        comboKey: ctrls.mataUangKey,
                        initItem: ctrls.rMatauang,
                        dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
                        displayText: (item) => item.rmatauangNama,
                        compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
                        isEnabled: false,
                        onChangedCallback: (val) {
                          setState(() => ctrls.rMatauang = val);
                          ffState.didChange(val);
                        },
                        showClearButton: false,
                        onSaveCallback: (val) => ctrls.rMatauang = val,
                        validatorCallback: (value) {
                          if (value == null) {
                            return kStringNullError;
                          }
                          return null;
                        },
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

  Widget _twoCol(Widget a, Widget b) {
    return LayoutBuilder(builder: (_, c) {
      final wide = c.maxWidth >= 720;
      if (!wide) return Column(children: [a, const SizedBox(height: 12), b]);
      return Row(children: [Expanded(child: a), const SizedBox(width: 12), Expanded(child: b)]);
    });
  }

  void _saveExisting(String id, _RowCtrls c) {
    if (!(c.formKey.currentState?.validate() ?? false)) return;

    final amountRaw = c.klaimAmount.text.replaceAll('.', '').replaceAll(',', '');
    final amount = double.tryParse(amountRaw) ?? 0;

    final record = Klaim1CrudModel(
      klaim1Id: id,
      insuredName: c.insuredName.text.trim(),
      kejadianLokasi: c.kejadianLokasi.text.trim(),
      kejadianTgl: DateTime((c.kejadianTgl ?? _today).year, (c.kejadianTgl ?? _today).month, (c.kejadianTgl ?? _today).day),
      klaimAmount: amount,
      kursId: c.rMatauang?.rmatauangKode,
      comboRMatauang: c.rMatauang,
      lastStsclaimId: c.mStsclaim?.mstsclaimId,
      comboMStsclaim: c.mStsclaim,
    );

    widget.onSaveExisting(id, record);
  }

  void _confirmDelete(BuildContext context, String recordId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ShowDialogHapusWidget(
        onHapusFunction: (id) => widget.onDelete(id),
        recordId: recordId,
      ),
    ).then((_) {
      context.read<Klaim1ListBloc>().add(CloseDialogKlaim1ListEvent());
    });
  }
}

/// Copied same as add-form (bisa dipindah ke shared file kalau mau).
class ThousandsFormatterId extends TextInputFormatter {
  final _nf = NumberFormat.decimalPattern('id');
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldV, TextEditingValue newV) {
    final digits = newV.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    }
    final oldDigitsBefore = _countDigitsBefore(oldV.text, oldV.selection.baseOffset);
    final newDigitsBefore = _countDigitsBefore(newV.text, newV.selection.baseOffset);
    final number = int.parse(digits);
    final newText = _nf.format(number);
    final targetDigitIndex = newDigitsBefore.clamp(0, digits.length);
    final caretOffset = _offsetForDigitIndex(newText, targetDigitIndex);
    return TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: caretOffset));
  }
  int _countDigitsBefore(String t, int off) { if (off <= 0) return 0; off = off.clamp(0, t.length); return RegExp(r'[0-9]').allMatches(t.substring(0, off)).length; }
  int _offsetForDigitIndex(String f, int idx) { if (idx <= 0) return 0; int c = 0; for (int i = 0; i < f.length; i++) { if (RegExp(r'[0-9]').hasMatch(f[i])) { c++; if (c == idx) return i + 1; } } return f.length; }
}