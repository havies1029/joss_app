import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_profile/mrekancontactcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekancontactcrud_model.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';

import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../common/app_data.dart';
import '../../../../../helper/indo_phone_result.dart';
import '../../../../../repositories/combobox/combomkota_repository.dart';
import '../../../../../repositories/combobox/combompropinsi_repository.dart';
import '../../../../../repositories/combobox/comborkodepos_repository.dart';
import '../../../../base/base_background_sidepage.dart';

class MRekanContactCrudFormPage extends StatefulWidget {
  const MRekanContactCrudFormPage({super.key});

  @override
  MRekanContactCrudFormPageFormState createState() =>
      MRekanContactCrudFormPageFormState();
}

class MRekanContactCrudFormPageFormState extends State<MRekanContactCrudFormPage> {
  late final MRekanContactCrudBloc mRekanContactCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  final fieldAlamat1Controller = TextEditingController();
  final fieldEmailController = TextEditingController();
  final fieldTelpController = TextEditingController();

  ComboMKotaModel? fieldComboMKota;
  final comboMKotaKey = GlobalKey<DropdownSearchState<ComboMKotaModel>>();
  ComboMPropinsiModel? fieldComboMPropinsi;
  final comboMPropinsiKey = GlobalKey<DropdownSearchState<ComboMPropinsiModel>>();
  ComboRKodeposModel? fieldComboRKodepos;
  final comboRKodeposKey = GlobalKey<DropdownSearchState<ComboRKodeposModel>>();

  late bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    mRekanContactCrudBloc = context.read<MRekanContactCrudBloc>();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
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
    return BaseBackgroundSidePage(
      title: "Kontak & Alamat",
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: constraints.maxHeight,
            color: secondaryBlackColor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),

                  child: BlocListener<MRekanContactCrudBloc, MRekanContactCrudState>(
                    listenWhen: (prev, curr) =>
                    curr.isLoaded == true || curr.isSaved == true,
                    listener: (context, state) {
                      if (state.isLoaded && state.record != null && _isFirstLoad) {
                        final contact = state.record!;

                        // =========================
                        // 1) TEXTFIELD: isi hanya kalau kosong
                        // =========================

                        if (fieldAlamat1Controller.text.trim().isEmpty) {
                          final alamat = (contact.alamat1).trim();
                          if (alamat.isNotEmpty) fieldAlamat1Controller.text = alamat;
                        }

                        final contactEmail = contact.email.trim();
                        final contactTelp  = contact.telp.trim();

                        final rekan = context.read<MRekan1CrudBloc>().state.record;
                        final rekanEmail = (rekan?.email ?? '').trim();
                        final rekanTelp  = (rekan?.telepon ?? '').trim();

                        if (fieldEmailController.text.trim().isEmpty) {

                          final userEmail = (AppData.user.email ?? '').trim();

                          if (contactEmail.isNotEmpty) {
                            fieldEmailController.text = contactEmail;

                          } else if (rekanEmail.isNotEmpty) {
                            fieldEmailController.text = rekanEmail;

                          } else if (userEmail.isNotEmpty) {
                            fieldEmailController.text = userEmail;
                          }
                        }

                        if (fieldTelpController.text.trim().isEmpty) {

                          final userTelp = (AppData.user.hp ?? '').trim();

                          if (contactTelp.isNotEmpty) {
                            fieldTelpController.text = contactTelp;

                          } else if (rekanTelp.isNotEmpty) {
                            fieldTelpController.text = rekanTelp;

                          } else if (userTelp.isNotEmpty) {
                            fieldTelpController.text = userTelp;
                          }
                        }

                        // =========================
                        // 2) DROPDOWN: isi hanya kalau belum dipilih user
                        // =========================

                        _injectPayload(state.record!);

                        _isFirstLoad = false;
                      }

                      if (state.isSaved && !state.hasFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          successSnackBar("Data berhasil disimpan!"),
                        );
                      }
                    },

                    child: _buildFormContent(context),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Kontak & Alamat",
            textAlign: TextAlign.start,
            style: headingStyle(context, fontSize: getResponsiveFont(context, 22))
                .copyWith(color: Colors.white),
          ),

          Text(
            "Gunakan email yang aktif dan alamat yang jelas.",
            style: bodyTextStyle(
              context,
              fontSize: getResponsiveFont(context, 16),
            ).copyWith(color: hintGrey),
          ),

          const SizedBox(height: vPadding),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: pGrey,
              border: Border.all(color: sGrey),
              borderRadius: BorderRadius.circular(cardBorderRadius),
            ),
            child: Column(
              children: [
                buildFieldEmail(),
                const SizedBox(height: vPadding),
                buildFieldAlamat1(),
                const SizedBox(height: vPadding),
                buildFieldTelp(),
                const SizedBox(height: vPadding),
                buildFieldMpropinsiId(),
                const SizedBox(height: vPadding),
                buildFieldMkotaId(),
                const SizedBox(height: vPadding),
                buildFieldRkodeposId(),
              ],
            ),
          ),

          const SizedBox(height: vPadding),
          AppButton.primary(text: "Simpan Perubahan", onPressed: onSaveForm),
        ],
      ),
    );
  }

  void _injectPayload(MRekanContactCrudModel record) {
    // fieldAlamat1Controller.text = record.alamat1;
    // fieldEmailController.text   = record.email;
    // fieldTelpController.text    = record.telp;

    fieldComboMKota     = record.comboMKota;
    fieldComboMPropinsi = record.comboMPropinsi;
    fieldComboRKodepos  = record.comboRKodepos;

    setState(() {});
  }


  void loadData() {
    mRekanContactCrudBloc.add(MRekanContactCrudLihatEvent());
  }

  Widget buildFieldEmail() => appTextField(
    label: "Email",
    controller: fieldEmailController,
    keyboardType: TextInputType.emailAddress,
    validator: (v) {
      final email = v?.trim() ?? "";
      if (email.isEmpty) {
        return kEmailNullError;
      }
      if (!emailValidatorRegExp.hasMatch(email)) {
        return "Format email tidak valid";
      }
      return null;
    },
  );

  Widget buildFieldTelp() => appTextField(
    label: "No. Telp Perusahaan",
    controller: fieldTelpController,
    keyboardType: TextInputType.phone,
    prefix: Text(
      "+62 | ",
      style: inputTextStyle(context, color: primaryLightColor),
    ),
    validator: (v) {
      final telp = v?.trim() ?? "";

      if (telp.isEmpty) {
        return kPhoneNumberNullError;
      }

      final res = IndoPhoneHelper.normalize(telp);

      if (!res.isValid) {
        return res.error ?? "Nomor HP tidak valid";
      }

      return null;
    },
  );

  Widget buildFieldAlamat1() => appTextField(
    label: "Alamat Rumah",
    controller: fieldAlamat1Controller,
    keyboardType: TextInputType.streetAddress,
    // inputFormatters: [
    //   FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
    // ],
    validator: (v) {
      if (v == null || v.isEmpty) return kAddressNullError;
      return null;
    },
  );

  Widget buildFieldMpropinsiId() => ReusableComboBox<ComboMPropinsiModel>(
    hintText: "Provinsi",
    comboKey: comboMPropinsiKey,
    initItem: fieldComboMPropinsi,
    dataLoader: () => ComboMPropinsiRepository().getComboMPropinsi(""),
    displayText: (item) => item.propinsiNama,
    compareItems: (a, b) => a.mpropinsiId == b.mpropinsiId,
    validatorCallback: (v) => v == null ? kStringProvinsiError : null,
    onChangedCallback: (v) {
      // if (v != null){
      //   mRekanContactCrudBloc.add(
      //     ComboMPropinsiChangedEvent(comboMPropinsi: v),
      //   );
      //   }
      fieldComboMPropinsi = v;

      fieldComboMKota = null;
      fieldComboRKodepos = null;

      comboMKotaKey.currentState?.clear();
      comboRKodeposKey.currentState?.clear();
    },
    onSaveCallback: (value) => fieldComboMPropinsi = value,
  );

  Widget buildFieldMkotaId() => ReusableComboBox<ComboMKotaModel>(
    hintText: "Kota",
    comboKey: comboMKotaKey,
    initItem: fieldComboMKota,
    dataLoader: () {
      return ComboMKotaRepository()
          .getComboMKota(fieldComboMPropinsi?.mpropinsiId ?? "");
    },
    displayText: (item) => item.kotaDesc,
    compareItems: (a, b) => a.mkotaId == b.mkotaId,
    validatorCallback: (v) => v == null ? kStringKotaError : null,
    onChangedCallback: (v) {
      if (v != null){
        // mRekanContactCrudBloc.add(ComboMKotaChangedEvent(comboMKota: v));
        comboRKodeposKey.currentState?.clear();
        fieldComboRKodepos = null;
      }

      fieldComboMKota = v;
    },
    onSaveCallback: (value) => fieldComboMKota = value,
  );

  Widget buildFieldRkodeposId() => ReusableComboBox<ComboRKodeposModel>(
    hintText: "Kodepos (Opsional)",
    comboKey: comboRKodeposKey,
    initItem: fieldComboRKodepos,
    dataLoader: () {
      return ComboRKodeposRepository()
          .getComboRKodepos(fieldComboMKota?.mkotaId ?? "", "");
    },

    displayText: (item) => item.kodeposNo,
    compareItems: (a, b) => a.rkodeposId == b.rkodeposId,
    validatorCallback: (v) => v == null ? kStringKodeposError : null,
    onChangedCallback: (v) {
      // if (v != null){
      //   mRekanContactCrudBloc.add(
      //     ComboRKodeposChangedEvent(comboRKodepos: v),
      //   );
      // }
      // fieldComboMKelurahan = v;
    },
    onSaveCallback: (value) => fieldComboRKodepos = value,
  );


  void onSaveForm() {
    final phoneRes = IndoPhoneHelper.normalize(
      fieldTelpController.text.trim(),
    );

    final telpNormalized = phoneRes.phone62 ?? "";

    MRekanContactCrudModel record = MRekanContactCrudModel(
      alamat1: fieldAlamat1Controller.text.trim(),
      email: fieldEmailController.text.trim(),
      mkotaId: fieldComboMKota?.mkotaId,
      mpropinsiId: fieldComboMPropinsi?.mpropinsiId,
      mrekancontact1Id: '',
      rkodeposId: fieldComboRKodepos?.rkodeposId,
      telp: telpNormalized,
    );

    record.mrekancontact1Id =
        mRekanContactCrudBloc.state.record!.mrekancontact1Id;

    mRekanContactCrudBloc.add(
      MRekanContactCrudUbahEvent(record: record),
    );
  }
}
