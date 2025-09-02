import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_profile/mrekancontactcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekancontactcrud_model.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/widgets/combobox/combomkota_widget.dart';
import 'package:joss_app/widgets/combobox/combompropinsi_widget.dart';
import 'package:joss_app/widgets/combobox/comborkodepos_widget.dart';

import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';

class RekanContact extends StatefulWidget {
  const RekanContact({super.key});

  @override
  State<RekanContact> createState() => _RekanContactState();
}

// Bagian import tetap, tidak perlu diubah

class _RekanContactState extends State<RekanContact> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  final comboMPropinsiKey = GlobalKey<DropdownSearchState<ComboMPropinsiModel>>();
  final comboMKotaDropdownKey = GlobalKey<DropdownSearchState<ComboMKotaModel>>();
  final comboRKodeposDropdownKey = GlobalKey<DropdownSearchState<ComboRKodeposModel>>();

  Key? comboMKotaKey;
  Key? comboRKodeposKey;

  final TextEditingController fieldAlamat1Controller = TextEditingController();
  final TextEditingController fieldEmailController = TextEditingController();
  final TextEditingController fieldTelpController = TextEditingController();
  bool _hasInitializedFields = false; // ⬅️ TAMBAHKAN DI STATE

  ComboMKotaModel? fieldComboMKota;
  ComboMPropinsiModel? fieldComboMPropinsi;
  ComboRKodeposModel? fieldComboRKodepos;

  bool isEditingSection = false;
  late MRekanContactCrudBloc bloc;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      bloc = context.read<MRekanContactCrudBloc>();

      final rekan1State = context.read<MRekan1CrudBloc>().state;
      final defaultRekanId = rekan1State.record?.mrekan1Id ?? '';
      final rekanNama = rekan1State.record?.rekanNama ?? 'unknown';

      final email = rekan1State.record?.email ?? '';
      final telepon = rekan1State.record?.telepon ?? 'unknown';

      debugPrint('[RekanContact] Rekan ID: $defaultRekanId');
      debugPrint('[RekanContact] Rekan Nama: $rekanNama');
      debugPrint('[RekanContact] Rekan Email: $email');
      debugPrint('[RekanContact] Rekan Telepon: $telepon');

      if (defaultRekanId.isNotEmpty) {
        // debugPrint("📨 Kirim MRekanContactCrudLihatEvent dengan ID: $defaultRekanId");
        bloc.add(MRekanContactCrudLihatEvent());
      } else {
        // debugPrint("⚠️ Tidak kirim LihatEvent karena ID kosong");
      }
    });
  }


  @override
  void dispose() {
    fieldAlamat1Controller.dispose();
    fieldEmailController.dispose();
    fieldTelpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<MRekanContactCrudBloc>(context);

    return BlocConsumer<MRekanContactCrudBloc, MRekanContactCrudState>(
      listener: (context, state) {
        final rekan1 = context.read<MRekan1CrudBloc>().state.record;
        // final authLocal = context.read<AuthLocalCubit>().state;
        // final lastEmail = authLocal.lastLoginEmail?.trim() ?? '';
        // // print("🧩 DEBUG rekan1Bloc data:");
        // debugPrint("🧩 DEBUG lastEmail dari AuthLocalCubit: $lastEmail");
        // // print("   - Telepon: ${rekan1?.telepon}");

        final isStateKosong = state.record == null;
        final isSemuaKosong = state.record?.email.isEmpty != false &&
            state.record?.telp.isEmpty != false &&
            state.record?.alamat1.isEmpty != false;

        // if (state.isLoaded && !_hasInitializedFields) {
        //   if (!isStateKosong && !isSemuaKosong) {
        //     // ✅ Utama: dari Contact
        //     fieldAlamat1Controller.text = state.record!.alamat1;
        //     fieldEmailController.text = state.record!.email;
        //     fieldTelpController.text = state.record!.telp;
        //     fieldComboMKota = state.record!.comboMKota;
        //     fieldComboMPropinsi = state.record!.comboMPropinsi;
        //     fieldComboRKodepos = state.record!.comboRKodepos;
        //   } else if (lastEmail.isNotEmpty) {
        //     // ✅ Fallback: dari AuthLocalCubit
        //     fieldEmailController.text = lastEmail;
        //   } else if (rekan1 != null) {
        //     // ✅ Fallback terakhir: dari MRekan1
        //     fieldEmailController.text = rekan1.email ?? '';
        //     fieldTelpController.text = rekan1.telepon ?? '';
        //   }
        //   _hasInitializedFields = true;
        // }
        fieldAlamat1Controller.text = state.record!.alamat1;
        fieldEmailController.text = state.record!.email;
        fieldTelpController.text = state.record!.telp;
        fieldComboMKota = state.record!.comboMKota;
        fieldComboMPropinsi = state.record!.comboMPropinsi;
        fieldComboRKodepos = state.record!.comboRKodepos;
      },
      builder: (context, state) {
        return _buildFormUI();
      },
    );
  }


  Widget _buildFormUI() {
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
                  child: Text("Kontak Klien :", style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: Icon(
                    isEditingSection ? Icons.check : Icons.edit,
                    color: isEditingSection ? null : Colors.red,
                  ),
                  onPressed: () => isEditingSection
                      ? onSaveForm()
                      : setState(() => isEditingSection = true),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildLabel("Email", isRequired: true),
            _buildTextField(
              controller: fieldEmailController,
              hintText: "contoh@mail.com",
              keyboardType: TextInputType.emailAddress,
              errorKey: "Email wajib dipilih",
            ),
            if (fieldEmailController.text.trim().isEmpty && isEditingSection)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "Email wajib dipilih",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            _buildLabel("No. HP", isRequired: true),
            _buildTextField(
              controller: fieldTelpController,
              hintText: "Contoh: 6283388774644",
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              errorKey: "Nomor HP wajib dipilih",
            ),
            if (fieldTelpController.text.trim().isEmpty && isEditingSection)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "Nomor HP wajib dipilih",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            _buildLabel("Alamat", isRequired: true),
            _buildTextField(
              controller: fieldAlamat1Controller,
              hintText: "Masukkan alamat lengkap",
              maxLines: 2,
              errorKey: "Alamat wajib dipilih",
            ),
            if (fieldAlamat1Controller.text.trim().isEmpty && isEditingSection)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "Alamat wajib dipilih",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            _buildLabel("Provinsi", isRequired: true),
            _buildStyledDropdown(
              child: isEditingSection
                  ? buildFieldComboMPropinsi(
                comboKey: comboMPropinsiKey,
                labelText: "Pilih",
                initItem: fieldComboMPropinsi,
                onChangedCallback: (value) {
                  if (value != null) {
                    setState(() {
                      fieldComboMPropinsi = value;
                      fieldComboMKota = null;
                      fieldComboRKodepos = null;
                      comboMKotaKey = UniqueKey();
                      comboRKodeposKey = UniqueKey();
                    });

                    comboMKotaDropdownKey.currentState?.clear();
                    comboRKodeposDropdownKey.currentState?.clear();

                    bloc.add(ComboMPropinsiChangedEvent(comboMPropinsi: value));
                    removeError("Provinsi wajib dipilih");
                  }
                },
                onSaveCallback: (value) => fieldComboMPropinsi = value,
                validatorCallback: (value) {
                  if (value == null) addError("Provinsi wajib dipilih");
                },
              )
                  : _buildDisabledDropdown(fieldComboMPropinsi?.propinsiNama ?? 'Belum diisi'),
            ),
            if (fieldComboMPropinsi == null && isEditingSection)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "Provinsi wajib dipilih",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            _buildLabel("Kota", isRequired: true),
            _buildStyledDropdown(
              child: isEditingSection
                  ? buildFieldComboMKota(
                key: comboMKotaKey,
                comboKey: comboMKotaDropdownKey,
                initItem: fieldComboMKota,
                propinsiId: fieldComboMPropinsi?.mpropinsiId ?? "",
                onChangedCallback: (value) {
                  if (value != null) {
                    setState(() {
                      fieldComboMKota = value;
                      fieldComboRKodepos = null;
                      comboRKodeposKey = UniqueKey();
                    });

                    comboRKodeposDropdownKey.currentState?.clear();
                    bloc.add(ComboMKotaChangedEvent(comboMKota: value));
                    removeError("Kota wajib dipilih");
                  }
                },
                onSaveCallback: (value) => fieldComboMKota = value,
                validatorCallback: (value) {
                  if (value == null) addError("Kota wajib dipilih");
                },
                labelText: 'Pilih',
              )
                  : _buildDisabledDropdown(fieldComboMKota?.kotaDesc ?? 'Belum diisi'),
            ),
            if (fieldComboMKota == null && isEditingSection)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "Kota wajib dipilih",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            _buildLabel("Kode Pos", isRequired: true),
            _buildStyledDropdown(
              child: isEditingSection
                  ? buildFieldComboRKodepos(
                key: comboRKodeposKey,
                comboKey: comboRKodeposDropdownKey,
                initItem: fieldComboRKodepos,
                kotaId: fieldComboMKota?.mkotaId ?? "",
                onChangedCallback: (value) {
                  if (value != null) {
                    fieldComboRKodepos = value;
                    bloc.add(ComboRKodeposChangedEvent(comboRKodepos: value));
                    removeError("Kode pos wajib dpilih");
                  }
                },
                onSaveCallback: (value) => fieldComboRKodepos = value,
                validatorCallback: (value) {
                  if (value == null) addError("Kode pos wajib dpilih");
                },
                labelText: 'Pilih',
              )
                  : _buildDisabledDropdown(fieldComboRKodepos?.kodeposNo ?? 'Belum diisi'),
            ),
            if (fieldComboRKodepos == null && isEditingSection)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "Kode pos wajib dpilih",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            // if (errors.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 12),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: errors.map((e) => Text(e, style: const TextStyle(color: Colors.red, fontSize: 12))).toList(),
            //     ),
            //   ),
          ],
        ),
      ),
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
        if (value.isNotEmpty) {
          removeError(errorKey);
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

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final record = MRekanContactCrudModel(
        alamat1: fieldAlamat1Controller.text,
        email: fieldEmailController.text,
        mkotaId: fieldComboMKota?.mkotaId,
        mpropinsiId: fieldComboMPropinsi?.mpropinsiId,
        mrekancontact1Id: bloc.state.record?.mrekancontact1Id ?? '',
        rkodeposId: fieldComboRKodepos?.rkodeposId,
        telp: fieldTelpController.text,
      );

      bloc.add(MRekanContactCrudUbahEvent(record: record));
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
