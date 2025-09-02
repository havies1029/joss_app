import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:joss_app/blocs/gen_profile/mrekanbankcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanbankcrud_model.dart';
import 'package:joss_app/blocs/gen_profile/mrekan1crud_bloc.dart';

import 'package:joss_app/models/combobox/combombank_model.dart';
import 'package:joss_app/widgets/combobox/combombank_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';

class RekanBank extends StatefulWidget {
  final String? initialRecordId;

  const RekanBank({super.key, this.initialRecordId});

  @override
  RekanBankState createState() => RekanBankState();
}

class RekanBankState extends State<RekanBank> {
  late MRekanBankCrudBloc mRekanBankCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  final fieldMrekan1IdController = TextEditingController();
  final fieldRekNamaController = TextEditingController();
  final fieldRekNoController = TextEditingController();

  final comboMBankKey = GlobalKey<DropdownSearchState<ComboMBankModel>>();
  ComboMBankModel? fieldComboMBank;

  bool isEditingSection = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      mRekanBankCrudBloc = context.read<MRekanBankCrudBloc>();
      mRekanBankCrudBloc = context.read<MRekanBankCrudBloc>();
      final rekan1State = context.read<MRekan1CrudBloc>().state;

      final defaultRekanId = rekan1State.record?.mrekan1Id ?? '';
      final rekanNama = rekan1State.record?.rekanNama ?? 'lenomind1@gmail.com';

      fieldMrekan1IdController.text = defaultRekanId;

      final idToLoad = widget.initialRecordId ?? rekanNama;

      // Contoh log (opsional)
      // debugPrint('[initState] Rekan ID: $defaultRekanId');
      // debugPrint('[initState] Rekan Nama: $rekanNama');
      // debugPrint('[initState] idToLoad: $idToLoad');

      if (idToLoad.isNotEmpty) {
        // debugPrint("📨 Kirim LihatEvent manual dengan ID: $idToLoad");
        mRekanBankCrudBloc.add(MRekanBankCrudLihatEvent(recordId: idToLoad));
      } else {
        // debugPrint("⚠️ Tidak kirim LihatEvent karena initialRecordId kosong");
      }
    });

  }


  @override
  void dispose() {
    fieldMrekan1IdController.dispose();
    fieldRekNamaController.dispose();
    fieldRekNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MRekanBankCrudBloc, MRekanBankCrudState>(
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          fieldMrekan1IdController.text = state.record!.mrekan1Id;
          fieldRekNamaController.text = state.record!.rekNama;
          fieldRekNoController.text = state.record!.rekNo;
          fieldComboMBank = state.record!.comboMBank;
        }

        // ⏱ REFRESH ulang data jika sudah disimpan
        if (state.isSaved) {
          final currentId = state.record?.mrekanbankId;
          if (currentId != null && currentId.isNotEmpty) {
            // debugPrint("🔁 Refresh ulang setelah simpan, id: $currentId");
            context.read<MRekanBankCrudBloc>().add(MRekanBankCrudLihatEvent(recordId: currentId));

            // ⛔️ Cegah loop: reset status setelah trigger
            Future.delayed(Duration(milliseconds: 100), () {
              context.read<MRekanBankCrudBloc>().add(MRekanBankCrudResetStatusEvent());
            });
          }
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Informasi Rekening :",
                        style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isEditingSection ? Icons.check : Icons.edit,
                        color: isEditingSection ? null : Colors.red, // merah hanya saat edit mode = false
                      ),
                      onPressed: () {
                        if (isEditingSection) {
                          onSaveForm(state);
                        } else {
                          setState(() => isEditingSection = true);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _buildLabel("Rekening Bank", isRequired: true),
                _buildStyledDropdown(
                  child: isEditingSection
                      ? buildFieldComboMBank(
                    comboKey: comboMBankKey,
                    labelText: "Pilih Bank",
                    initItem: fieldComboMBank,
                    onChangedCallback: (value) {
                      if (value != null) {
                        setState(() => fieldComboMBank = value);
                        context.read<MRekanBankCrudBloc>().add(ComboMBankChangedEvent(comboMBank: value));
                        removeError("Bank wajib dipilih");
                      }
                    },
                    onSaveCallback: (value) => fieldComboMBank = value,
                    validatorCallback: (value) {
                      if (value == null) addError("Bank wajib dipilih");
                    },
                  )
                      : _buildDisabledDropdown(fieldComboMBank?.bankNama ?? "Belum diisi"),
                ),
                if (fieldComboMBank == null && isEditingSection)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      "Bank wajib dipilih.",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                _buildLabel("Nama Rekening", isRequired: true),
                _buildTextField(
                  controller: fieldRekNamaController,
                  hintText: "Masukkan nama pemilik rekening",
                  maxLines: 2,
                  errorKey: "Nama rekening wajib dpilih",
                ),
                if (fieldRekNamaController.text.trim().isEmpty && isEditingSection)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      "Nama rekening wajib dpilih",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                _buildLabel("No. Rekening", isRequired: true),
                _buildTextField(
                  controller: fieldRekNoController,
                  hintText: "Masukkan nomor rekening",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  errorKey: "Nomor rekening wajib dipilih",
                ),
                if (fieldRekNoController.text.trim().isEmpty && isEditingSection)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      "Nomor rekening wajib dipilih",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),


                // if (errors.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 12),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: errors
                //           .map((e) => Text(e, style: const TextStyle(color: Colors.red, fontSize: 12)))
                //           .toList(),
                //     ),
                //   ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          if (isRequired)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    required String errorKey,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: !isEditingSection,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: 'Satoshi', fontSize: 14, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue.shade400)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        filled: true,
        fillColor: isEditingSection ? Colors.white : Colors.grey.shade50,
        isDense: true,
      ),
      style: const TextStyle(fontFamily: 'Satoshi', fontSize: 14),
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(errorKey);
          return "";
        }
        return null;
      },
        onChanged: (value) {
          if (value != null) {
            setState(() => fieldComboMBank = value as ComboMBankModel?);
          }
        }
    );
  }

  Widget _buildStyledDropdown({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: child,
    );
  }

  Widget _buildDisabledDropdown(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontFamily: 'Satoshi', fontSize: 14, color: Colors.black87)),
    );
  }

  void onSaveForm(MRekanBankCrudState state) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final isNew = state.record == null || state.record!.mrekanbankId.isEmpty;

      final record = MRekanBankCrudModel(
        mrekan1Id: context.read<MRekan1CrudBloc>().state.record?.mrekan1Id ?? '',
        mrekanbankId: isNew ? '' : state.record!.mrekanbankId,
        rekNama: fieldRekNamaController.text,
        rekNo: fieldRekNoController.text,
        mbankId: fieldComboMBank?.mbankId ?? '',
        comboMBank: fieldComboMBank,
      );


      print("✅ mrekan1Id yang dikirim: '${record.mrekan1Id}' (${record.mrekan1Id.runtimeType})");
      print("📤 Full JSON: ${record.toJson()}");

      mRekanBankCrudBloc.add(MRekanBankCrudUbahEvent(record: record));

      setState(() => isEditingSection = false);
    }
  }

  void addError(String error) {
    if (!errors.contains(error)) {
      setState(() => errors.add(error));
    }
  }

  void removeError(String error) {
    if (errors.contains(error)) {
      setState(() => errors.remove(error));
    }
  }
}
