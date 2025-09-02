import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpajakcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpajakcrud_model.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/widgets/combobox/combomkota_widget.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/widgets/combobox/combompropinsi_widget.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/widgets/combobox/comborkodepos_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';

class MRekanPajakFormBody extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const MRekanPajakFormBody({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  State<MRekanPajakFormBody> createState() => _MRekanPajakFormBodyState();
}

class _MRekanPajakFormBodyState extends State<MRekanPajakFormBody> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  late MRekanPajakCrudBloc bloc;

  final fieldAlamat1Controller = TextEditingController();
  final fieldNpwpNoController = TextEditingController();

  ComboMKotaModel? fieldComboMKota;
  final comboMKotaKey = GlobalKey<DropdownSearchState<ComboMKotaModel>>();

  ComboMPropinsiModel? fieldComboMPropinsi;
  final comboMPropinsiKey = GlobalKey<DropdownSearchState<ComboMPropinsiModel>>();

  ComboRKodeposModel? fieldComboRKodepos;
  final comboRKodeposKey = GlobalKey<DropdownSearchState<ComboRKodeposModel>>();

  bool isEditingSection = false;

  final TextStyle labelStyle = const TextStyle(fontWeight: FontWeight.w500);
  final TextStyle hintStyle = const TextStyle(fontFamily: 'Satoshi', fontSize: 14, color: Colors.grey);
  final TextStyle textStyle = const TextStyle(fontFamily: 'Satoshi', fontSize: 14);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      bloc = BlocProvider.of<MRekanPajakCrudBloc>(context);
      if (widget.viewMode == "ubah") {
        bloc.add(MRekanPajakCrudLihatEvent(recordId: widget.recordId));
      }
    });
  }

  @override
  void dispose() {
    fieldAlamat1Controller.dispose();
    fieldNpwpNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<MRekanPajakCrudBloc>(context);

    return BlocListener<MRekanPajakCrudBloc, MRekanPajakCrudState>(
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          setState(() {
            fieldAlamat1Controller.text = state.record!.alamat1;
            fieldNpwpNoController.text = state.record!.npwpNo;
            fieldComboMPropinsi = state.comboMPropinsi;
            fieldComboMKota = state.comboMKota;
            fieldComboRKodepos = state.comboRKodepos;
          });
        }
      },
      child: Container(
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
                    child: Text("Informasi Pajak", style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: Icon(
                      isEditingSection ? Icons.check : Icons.edit,
                      color: isEditingSection ? null : Colors.red, // Merah saat belum edit
                    ),
                    onPressed: () {
                      if (isEditingSection) {
                        _onSaveForm();
                      } else {
                        setState(() => isEditingSection = true);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (errors.isNotEmpty) FormError(errors: errors, key: null,),

              _buildLabelText("Alamat", isRequired: true),
              const SizedBox(height: 6),
              _buildStyledTextField(
                controller: fieldAlamat1Controller,
                hintText: "Masukkan alamat lengkap",
                maxLines: 2,
              ),
              if (fieldAlamat1Controller.text.trim().isEmpty && isEditingSection)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "Alamat wajib dpilih",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 12),
              _buildLabelText("Propinsi", isRequired: true),
              const SizedBox(height: 6),
              _buildStyledDropdown(child: _buildFieldMPropinsiDropdown()),
              if (fieldComboMPropinsi == null && isEditingSection)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "Propinsi wajib dpilih",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 12),
              _buildLabelText("Kota", isRequired: true),
              const SizedBox(height: 6),
              _buildStyledDropdown(child: _buildFieldMKotaDropdown()),
              if (fieldComboMKota == null && isEditingSection)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "Kota wajib dpilih",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 12),
              _buildLabelText("Kode Pos", isRequired: true),
              const SizedBox(height: 6),
              _buildStyledDropdown(child: _buildFieldRKodeposDropdown()),
              if (fieldComboRKodepos == null && isEditingSection)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "Kode Pos wajib dpilih",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 12),
              _buildLabelText("NPWP No", isRequired: true),
              const SizedBox(height: 6),
              _buildStyledTextField(
                controller: fieldNpwpNoController,
                hintText: "Masukkan NPWP",
              ),
              if (fieldNpwpNoController.text.trim().isEmpty && isEditingSection)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "NPWP wajib dpilih",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
  Widget _buildLabelText(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Satoshi',
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


  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: !isEditingSection,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontFamily: 'Satoshi', fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: 'Satoshi', fontSize: 14, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade400),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: isEditingSection ? Colors.white : Colors.grey.shade50,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Field tidak boleh kosong' : null,
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
        style: const TextStyle(
          fontFamily: 'Satoshi',
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }


  Widget _buildFieldMPropinsiDropdown() {
    return isEditingSection
        ? buildFieldComboMPropinsi(
      comboKey: comboMPropinsiKey,
      labelText: 'Pilih',
      initItem: fieldComboMPropinsi,
      onChangedCallback: (value) {
        if (value != null) {
          setState(() {
            fieldComboMPropinsi = value;
            fieldComboMKota = null;
            fieldComboRKodepos = null;
          });
          bloc.add(ComboMPropinsiChangedEvent(comboMPropinsi: value));
        }
      },
      onSaveCallback: (value) => fieldComboMPropinsi = value,
      validatorCallback: (_) {},
    )
        : _buildDisabledDropdown(text: fieldComboMPropinsi?.propinsiNama ?? 'Belum diisi');
  }

  Widget _buildFieldMKotaDropdown() {
    return isEditingSection
        ? buildFieldComboMKota(
      comboKey: comboMKotaKey,
      labelText: 'Pilih',
      initItem: fieldComboMKota,
      propinsiId: fieldComboMPropinsi?.mpropinsiId ?? '',
      onChangedCallback: (value) {
        if (value != null) {
          setState(() {
            fieldComboMKota = value;
            fieldComboRKodepos = null;
          });
          bloc.add(ComboMKotaChangedEvent(comboMKota: value));
        }
      },
      onSaveCallback: (value) => fieldComboMKota = value,
      validatorCallback: (_) {},
    )
        : _buildDisabledDropdown(text: fieldComboMKota?.kotaDesc ?? 'Belum diisi');
  }

  Widget _buildFieldRKodeposDropdown() {
    return isEditingSection
        ? buildFieldComboRKodepos(
      comboKey: comboRKodeposKey,
      labelText: 'Pilih',
      initItem: fieldComboRKodepos,
      kotaId: fieldComboMKota?.mkotaId ?? '',
      onChangedCallback: (value) {
        if (value != null) {
          setState(() => fieldComboRKodepos = value);
          bloc.add(ComboRKodeposChangedEvent(comboRKodepos: value));
        }
      },
      onSaveCallback: (value) => fieldComboRKodepos = value,
      validatorCallback: (_) {},
    )
        : _buildDisabledDropdown(text: fieldComboRKodepos?.kodeposNo ?? 'Belum diisi');
  }

  void _onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final record = MRekanPajakCrudModel(
        alamat1: fieldAlamat1Controller.text,
        mkotaId: fieldComboMKota?.mkotaId,
        mpropinsiId: fieldComboMPropinsi?.mpropinsiId,
        npwpNo: fieldNpwpNoController.text,
        rkodeposId: fieldComboRKodepos?.rkodeposId,
        mrekanpajakId: widget.viewMode == "ubah" ? bloc.state.record?.mrekanpajakId ?? '' : '',
      );

      if (widget.viewMode == "tambah") {
        bloc.add(MRekanPajakCrudTambahEvent(record: record));
      } else {
        bloc.add(MRekanPajakCrudUbahEvent(record: record));
      }

      setState(() => isEditingSection = false);
    }
  }
}
