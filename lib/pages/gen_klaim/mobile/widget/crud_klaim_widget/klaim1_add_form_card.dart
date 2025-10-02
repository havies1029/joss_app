// // lib/pages/gen_klaim/widgets/klaim1_add_form_card.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:date_field/date_field.dart';
// import 'package:dropdown_search/dropdown_search.dart';
//
// import 'package:joss_app/common/constants.dart';
// import 'package:joss_app/models/gen_klaim/klaim1crud_model.dart';
// import 'package:joss_app/models/combobox/combormatauang_model.dart';
// import 'package:joss_app/models/combobox/combomstsclaim_model.dart';
// import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
// import 'package:joss_app/widgets/combobox/combomstsclaim_widget.dart';
//
// import '../../../../../repositories/combobox/combomstsclaim_repository.dart';
// import '../../../../../repositories/combobox/combormatauang_repository.dart';
//
// class Klaim1AddFormCard extends StatefulWidget {
//   final bool isSaving;
//   final VoidCallback onCancel;
//   final void Function(Klaim1CrudModel record) onSave;
//
//   const Klaim1AddFormCard({
//     super.key,
//     required this.onSave,
//     required this.onCancel,
//     this.isSaving = false,
//   });
//
//   @override
//   State<Klaim1AddFormCard> createState() => _Klaim1AddFormCardState();
// }
//
// class _Klaim1AddFormCardState extends State<Klaim1AddFormCard> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Controllers
//   final _insuredName = TextEditingController();
//   final _kejadianLokasi = TextEditingController();
//   final _klaimAmount = TextEditingController();
//
//   DateTime? _kejadianTgl;
//
//   final _mataUangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
//   ComboRMatauangModel? _rMatauang;
//
//   final _stsClaimKey = GlobalKey<DropdownSearchState<ComboMStsclaimModel>>();
//   ComboMStsclaimModel? _mStsclaim;
//
//   final _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
//
//   @override
//   void initState() {
//     super.initState();
//     _kejadianTgl = _today; // default hari ini
//   }
//
//   @override
//   void dispose() {
//     _insuredName.dispose();
//     _kejadianLokasi.dispose();
//     _klaimAmount.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       color: pGrey,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(cardBorderRadius),
//         side: const BorderSide(color: sGrey, width: 1.0),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Form(
//           key: _formKey,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header + Actions
//               Row(
//                 children: [
//                   Text('Tambah Klaim Baru',
//                       style: TextStyle(fontSize: getResponsiveFont(context, 20), fontWeight: FontWeight.w700)),
//                   const Spacer(),
//                   Tooltip(
//                     message: 'Simpan',
//                     child: ElevatedButton(
//                       onPressed: widget.isSaving ? null : _submit,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.all(12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                       child: widget.isSaving
//                           ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                           : const Icon(Icons.check, color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Tooltip(
//                     message: 'Batal',
//                     child: OutlinedButton(
//                       onPressed: widget.isSaving ? null : widget.onCancel,
//                       style: OutlinedButton.styleFrom(
//                         side: const BorderSide(color: primaryLightColor),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         padding: const EdgeInsets.all(12),
//                       ),
//                       child: const Icon(Icons.close, color: primaryLightColor, size: 20),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//
//               _twoCol(
//                 _fieldText('Nama Tertanggung', _insuredName, 'Nama Tertanggung'),
//                 _fieldText('Lokasi Kejadian', _kejadianLokasi, 'Lokasi Kejadian'),
//               ),
//
//               const SizedBox(height: 12),
//
//               _twoCol(
//                 _fieldTanggal(),
//                 _fieldAmountAndCurrency(),
//               ),
//
//               const SizedBox(height: 12),
//
//               // Status
//               // Text('Status Klaim', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
//               // FormField<ComboMStsclaimModel>(
//               //   validator: (_) => _mStsclaim == null ? 'Status harus dipilih' : null,
//               //   builder: (ffState) {
//               //     return Column(
//               //       crossAxisAlignment: CrossAxisAlignment.start,
//               //       children: [
//               //         // buildFieldComboMStsclaim(
//               //         //   comboKey: _stsClaimKey,
//               //         //   labelText: 'Pilih Status Klaim',
//               //         //   initItem: _mStsclaim,
//               //         //   onChangedCallback: (val) {
//               //         //     setState(() => _mStsclaim = val);
//               //         //     ffState.didChange(val);
//               //         //   },
//               //         //   onSaveCallback: (val) => _mStsclaim = val,
//               //         //   validatorCallback: (_) => null,
//               //         // ),
//               //         ReusableComboBox<ComboMStsclaimModel>(
//               //           hintText: "Status",
//               //           searchHintText: "Pilih Status Klaim",
//               //           comboKey: _stsClaimKey,
//               //           initItem: _mStsclaim,
//               //           dataLoader: () => ComboMStsclaimRepository().getComboMStsclaim(),
//               //           displayText: (item) => item.statusNama,
//               //           compareItems: (a, b) => a.mstsclaimId == b.mstsclaimId,
//               //           onChangedCallback: (val) {
//               //             setState(() => _mStsclaim = val);
//               //             ffState.didChange(val);
//               //           },
//               //           onSaveCallback: (val) => _mStsclaim = val,
//               //           validatorCallback: (value) {
//               //             if (value == null) {
//               //               return kStringNullError;
//               //             }
//               //             return null;
//               //           },
//               //         ),
//               //         if (ffState.hasError)
//               //           Padding(
//               //             padding: const EdgeInsets.only(top: 4),
//               //             child: Text(ffState.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
//               //           ),
//               //       ],
//               //     );
//               //   },
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _fieldText(String label, TextEditingController c, String hint) {
//     return appTextField(
//       label: label,
//       hint: 'Masukkan $hint',
//       controller: c,
//       validator: (v) =>
//       (v == null || v.trim().isEmpty) ? 'Tidak boleh kosong' : null,
//     );
//   }
//
//   Widget _fieldTanggal() {
//     final last = (_kejadianTgl != null && _kejadianTgl!.isAfter(_today)) ? _kejadianTgl! : _today;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Tanggal', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
//         AppDateField(
//           label: 'Tanggal',
//           initialValue: _kejadianTgl ?? _today,
//           firstDate: DateTime(2000, 1, 1),
//           lastDate: last,
//           validator: (dt) => (dt == null) ? 'Tanggal harus diisi' : null,
//           onChanged: (dt) => setState(() {
//             _kejadianTgl = DateTime(dt!.year, dt.month, dt.day);
//           }),
//         )
//       ],
//     );
//   }
//
//   Widget _fieldAmountAndCurrency() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Jumlah Klaim & Mata Uang', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
//         Row(
//           children: [
//             Expanded(
//                 flex: 2,
//                 child: appTextField(
//                   label: 'Jumlah Klaim',
//                   hint: 'cth: 10.000.000',
//                   controller: _klaimAmount,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     ThousandsFormatterId(),
//                   ],
//                   validator: (v) {
//                     final raw = v?.replaceAll('.', '').replaceAll(',', '') ?? '';
//                     if (raw.isEmpty) return 'Tidak boleh kosong';
//                     final parsed = double.tryParse(raw);
//                     if (parsed == null) return 'Format tidak valid';
//                     return null;
//                   },
//                 )
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               flex: 1,
//               child: FormField<ComboRMatauangModel>(
//                 validator: (_) => _rMatauang == null ? 'Wajib' : null,
//                 builder: (ffState) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ReusableComboBox<ComboRMatauangModel>(
//                         hintText: "Mata Uang",
//                         searchHintText: "Cari Mata Uang...",
//                         comboKey: _mataUangKey,
//                         initItem: _rMatauang,
//                         dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
//                         displayText: (item) => item.rmatauangNama,
//                         compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
//                         onChangedCallback: (val) {
//                           setState(() => _rMatauang = val);
//                           ffState.didChange(val);
//                         },
//                         showClearButton: false,
//                         onSaveCallback: (val) => _rMatauang = val,
//                         validatorCallback: (value) {
//                           if (value == null) {
//                             return kStringNullError;
//                           }
//                           return null;
//                         },
//                       ),
//                       if (ffState.hasError)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4),
//                           child: Text(ffState.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _twoCol(Widget a, Widget b) {
//     return LayoutBuilder(builder: (_, c) {
//       final wide = c.maxWidth >= 720;
//       if (!wide) return Column(children: [a, const SizedBox(height: 12), b]);
//       return Row(children: [Expanded(child: a), const SizedBox(width: 12), Expanded(child: b)]);
//     });
//   }
//
//   void _submit() {
//     if (!(_formKey.currentState?.validate() ?? false)) return;
//
//     final amountRaw = _klaimAmount.text.replaceAll('.', '').replaceAll(',', '');
//     final amount = double.tryParse(amountRaw) ?? 0;
//
//     final record = Klaim1CrudModel(
//       klaim1Id: '',
//       insuredName: _insuredName.text.trim(),
//       kejadianLokasi: _kejadianLokasi.text.trim(),
//       kejadianTgl: DateTime(_kejadianTgl!.year, _kejadianTgl!.month, _kejadianTgl!.day),
//       klaimAmount: amount,
//       kursId: _rMatauang?.rmatauangKode,
//       comboRMatauang: _rMatauang,
//       // lastStsclaimId: _mStsclaim?.mstsclaimId,
//       // comboMStsclaim: _mStsclaim,
//     );
//
//     widget.onSave(record);
//   }
// }
//
// /// Locale ID formatter + keep caret
// class ThousandsFormatterId extends TextInputFormatter {
//   final _nf = NumberFormat.decimalPattern('id');
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldV, TextEditingValue newV) {
//     final digits = newV.text.replaceAll(RegExp(r'[^0-9]'), '');
//     if (digits.isEmpty) {
//       return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
//     }
//     final oldDigitsBefore = _countDigitsBefore(oldV.text, oldV.selection.baseOffset);
//     final newDigitsBefore = _countDigitsBefore(newV.text, newV.selection.baseOffset);
//     final number = int.parse(digits);
//     final newText = _nf.format(number);
//     final targetDigitIndex = newDigitsBefore.clamp(0, digits.length);
//     final caretOffset = _offsetForDigitIndex(newText, targetDigitIndex);
//     return TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: caretOffset));
//   }
//   int _countDigitsBefore(String t, int off) { if (off <= 0) return 0; off = off.clamp(0, t.length); return RegExp(r'[0-9]').allMatches(t.substring(0, off)).length; }
//   int _offsetForDigitIndex(String f, int idx) { if (idx <= 0) return 0; int c = 0; for (int i = 0; i < f.length; i++) { if (RegExp(r'[0-9]').hasMatch(f[i])) { c++; if (c == idx) return i + 1; } } return f.length; }
// }






// lib/pages/gen_klaim/widgets/klaim1_add_form_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_klaim/klaim1crud_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combomstsclaim_model.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:joss_app/widgets/combobox/combomstsclaim_widget.dart';

import '../../../../../repositories/combobox/combomstsclaim_repository.dart';
import '../../../../../repositories/combobox/combormatauang_repository.dart';

class Klaim1AddFormCard extends StatefulWidget {
  final bool isSaving;
  final VoidCallback onCancel;
  final void Function(Klaim1CrudModel record) onSave;

  const Klaim1AddFormCard({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.isSaving = false,
  });

  @override
  State<Klaim1AddFormCard> createState() => _Klaim1AddFormCardState();
}

class _Klaim1AddFormCardState extends State<Klaim1AddFormCard> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _insuredName = TextEditingController();
  final _kejadianLokasi = TextEditingController();
  final _klaimAmount = TextEditingController();

  DateTime? _kejadianTgl;

  final _mataUangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
  ComboRMatauangModel? _rMatauang;

  final _stsClaimKey = GlobalKey<DropdownSearchState<ComboMStsclaimModel>>();
  ComboMStsclaimModel? _mStsclaim;

  final _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    _kejadianTgl = _today; // default hari ini
  }

  @override
  void dispose() {
    _insuredName.dispose();
    _kejadianLokasi.dispose();
    _klaimAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Card isi form
        Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          color: pGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardBorderRadius),
            side: const BorderSide(color: sGrey, width: 1.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Tambah Klaim Baru',
                    style: TextStyle(
                      fontSize: getResponsiveFont(context, 20),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _twoCol(
                    _fieldText('Nama Tertanggung', _insuredName, 'Nama Tertanggung'),
                    _fieldText('Lokasi Kejadian', _kejadianLokasi, 'Lokasi Kejadian'),
                  ),

                  const SizedBox(height: 12),

                  _twoCol(
                    _fieldTanggal(),
                    _fieldAmountAndCurrency(),
                  ),

                  const SizedBox(height: 12),

                  // (opsional: tambahin Status Klaim di sini kalau mau diaktifin lagi)
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Tombol simpan di luar card
        AppButton.iconLeft(
          text: 'Lapor',
          backgroundColor: primaryColor,
          icon: const Icon(Icons.save, color: Colors.white),
          onPressed: widget.isSaving ? null : _submit,
        ),
      ],
    );
  }


  Widget _fieldText(String label, TextEditingController c, String hint) {
    return appTextField(
      label: label,
      hint: 'Masukkan $hint',
      controller: c,
      validator: (v) =>
      (v == null || v.trim().isEmpty) ? 'Tidak boleh kosong' : null,
    );
  }

  Widget _fieldTanggal() {
    final last = (_kejadianTgl != null && _kejadianTgl!.isAfter(_today)) ? _kejadianTgl! : _today;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tanggal', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
        AppDateField(
          label: 'Tanggal',
          initialValue: _kejadianTgl ?? _today,
          firstDate: DateTime(2000, 1, 1),
          lastDate: last,
          validator: (dt) => (dt == null) ? 'Tanggal harus diisi' : null,
          onChanged: (dt) => setState(() {
            _kejadianTgl = DateTime(dt!.year, dt.month, dt.day);
          }),
        )
      ],
    );
  }

  Widget _fieldAmountAndCurrency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jumlah Klaim & Mata Uang', style: TextStyle(fontSize: getResponsiveFont(context, 18))),
        Row(
          children: [
            Expanded(
                flex: 2,
                child: appTextField(
                  label: 'Jumlah Klaim',
                  hint: 'cth: 10.000.000',
                  controller: _klaimAmount,
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
                )
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: FormField<ComboRMatauangModel>(
                validator: (_) => _rMatauang == null ? 'Wajib' : null,
                builder: (ffState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableComboBox<ComboRMatauangModel>(
                        hintText: "Mata Uang",
                        comboKey: _mataUangKey,
                        initItem: _rMatauang,
                        dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
                        displayText: (item) => item.rmatauangSimbol,
                        compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
                        onChangedCallback: (val) {
                          setState(() => _rMatauang = val);
                          ffState.didChange(val);
                        },
                        showClearButton: false,
                        onSaveCallback: (val) => _rMatauang = val,
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

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amountRaw = _klaimAmount.text.replaceAll('.', '').replaceAll(',', '');
    final amount = double.tryParse(amountRaw) ?? 0;

    final record = Klaim1CrudModel(
      klaim1Id: '',
      insuredName: _insuredName.text.trim(),
      kejadianLokasi: _kejadianLokasi.text.trim(),
      kejadianTgl: DateTime(_kejadianTgl!.year, _kejadianTgl!.month, _kejadianTgl!.day),
      klaimAmount: amount,
      kursId: _rMatauang?.rmatauangKode,
      comboRMatauang: _rMatauang,
      // lastStsclaimId: _mStsclaim?.mstsclaimId,
      // comboMStsclaim: _mStsclaim,
    );

    widget.onSave(record);
  }
}

/// Locale ID formatter + keep caret
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