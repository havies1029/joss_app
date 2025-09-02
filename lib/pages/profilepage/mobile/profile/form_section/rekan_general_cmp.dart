import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:joss_app/blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralcmpcrud_model.dart';
import 'package:joss_app/models/combobox/combombentukcst_model.dart';
import 'package:joss_app/widgets/combobox/combombentukcst_widget.dart';
import 'package:joss_app/models/combobox/combombidang_model.dart';
import 'package:joss_app/widgets/combobox/combombidang_widget.dart';

class RekanGeneralCmp extends StatefulWidget {
  const RekanGeneralCmp({super.key});

  @override
  State<RekanGeneralCmp> createState() => _RekanGeneralCmpState();
}

class _RekanGeneralCmpState extends State<RekanGeneralCmp> {
  final _formKey = GlobalKey<FormState>();
  late MRekanGeneralCmpCrudBloc bloc;

  final TextEditingController fieldRekanNamaController = TextEditingController();
  ComboMBentukCstModel? fieldComboMBentukCst;
  ComboMBidangModel? fieldComboMBidang;

  bool isEditingSection = false;
  final List<String> errors = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      bloc.add(MRekanGeneralCmpCrudLihatEvent());
    });
  }

  @override
  void dispose() {
    fieldRekanNamaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<MRekanGeneralCmpCrudBloc>(context);

    return BlocConsumer<MRekanGeneralCmpCrudBloc, MRekanGeneralCmpCrudState>(
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          fieldRekanNamaController.text = state.record?.rekanNama ?? '';
          fieldComboMBentukCst = state.comboMBentukCst;
          fieldComboMBidang = state.comboMBidang;
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: _buildFormUI(),
        );
      },
    );
  }
  Widget _buildFormUI() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Informasi Perusahaan :",
                  style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(
                  isEditingSection ? Icons.check : Icons.edit,
                  color: isEditingSection ? null : Colors.red,
                ),
                tooltip: isEditingSection ? "Simpan" : "Ubah",
                onPressed: () {
                  if (isEditingSection) {
                    onSaveForm();
                  } else {
                    setState(() => isEditingSection = true);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildLabelText("Nama Badan Usaha", isRequired: true),
          const SizedBox(height: 6),
          _buildTextField(
            controller: fieldRekanNamaController,
            hintText: "Masukkan nama perusahaan",
          ),
          if (fieldRekanNamaController.text.trim().isEmpty && isEditingSection)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                "Nama perusahaan wajib dipilih",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          const SizedBox(height: 12),
          _buildLabelText("Bentuk Badan Usaha", isRequired: true),
          const SizedBox(height: 6),
          _buildStyledDropdown(
            child: isEditingSection
                ? buildFieldComboMBentukCst(
              labelText: 'Pilih',
              initItem: fieldComboMBentukCst,
              onChangedCallback: (value) {
                if (value != null) {
                  fieldComboMBentukCst = value;
                  bloc.add(ComboMBentukCstChangedEvent(comboMBentukCst: value));
                  removeError("Field bentuk usaha tidak boleh kosong.");
                }
              },
              onSaveCallback: (value) {
                if (value != null) fieldComboMBentukCst = value;
              },
              validatorCallback: (value) {
                if (value == null) addError("Field bentuk usaha tidak boleh kosong.");
              },
              comboKey: null,
            )
                : _buildDisabledDropdown(
              text: fieldComboMBentukCst?.bentukNama ?? 'Belum diisi',
            ),
          ),
          if (fieldComboMBentukCst == null && isEditingSection)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                "Badan usaha wajib dipilih",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          const SizedBox(height: 12),
          _buildLabelText("Bidang Usaha", isRequired: true),
          const SizedBox(height: 6),
          _buildStyledDropdown(
            child: isEditingSection
                ? buildFieldComboMBidang(
              labelText: 'Pilih',
              initItem: fieldComboMBidang,
              onChangedCallback: (value) {
                if (value != null) {
                  fieldComboMBidang = value;
                  bloc.add(ComboMBidangChangedEvent(comboMBidang: value));
                  removeError("Field bidang usaha tidak boleh kosong.");
                }
              },
              onSaveCallback: (value) {
                if (value != null) fieldComboMBidang = value;
              },
              validatorCallback: (value) {
                if (value == null) addError("Field bidang usaha tidak boleh kosong.");
              },
              comboKey: null,
            )
                : _buildDisabledDropdown(
              text: fieldComboMBidang?.bidangNama ?? 'Belum diisi',
            ),
          ),
          if (fieldComboMBidang == null && isEditingSection)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                "Bidang usaha wajib dipilih",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLabelText(String text, {bool isRequired = false}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
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
    int? maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: !isEditingSection,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: 'Satoshi', fontSize: 14, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        filled: true,
        fillColor: isEditingSection ? Colors.white : Colors.grey.shade50,
        alignLabelWithHint: true,
        isDense: true,
      ),
      style: const TextStyle(fontFamily: 'Satoshi', fontSize: 14, height: 1.3),
      textAlignVertical: TextAlignVertical.top,
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError("Field nama badan usaha tidak boleh kosong.");
          return "";
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError("Field nama badan usaha tidak boleh kosong.");
        }
      },
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

  Widget _buildDisabledDropdown({required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontFamily: 'Satoshi', fontSize: 14, color: Colors.black87),
      ),
    );
  }

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final record = MRekanGeneralCmpCrudModel(
        rekanNama: fieldRekanNamaController.text,
        mbentukcstId: fieldComboMBentukCst?.mbentukcstId,
        mbidangId: fieldComboMBidang?.mbidangId,
      );

      bloc.add(MRekanGeneralCmpCrudUbahEvent(record: record));

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
