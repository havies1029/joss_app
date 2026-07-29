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

import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../common/app_data.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../helper/international_phone_result.dart';
import '../../../../../repositories/combobox/combomkota_repository.dart';
import '../../../../../repositories/combobox/combompropinsi_repository.dart';
import '../../../../../repositories/combobox/comborkodepos_repository.dart';
import '../../../../../widgets/apptheme/dropdown2.dart';
import '../../../../../widgets/apptheme/phone_number_field.dart';
import '../../../../base/base_background_sidepage.dart';

class MRekanContactCrudFormPage extends StatefulWidget {
  const MRekanContactCrudFormPage({super.key});

  @override
  MRekanContactCrudFormPageFormState createState() =>
      MRekanContactCrudFormPageFormState();
}

class MRekanContactCrudFormPageFormState
    extends State<MRekanContactCrudFormPage> {
  late final MRekanContactCrudBloc mRekanContactCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  final Map<String, String?> fieldErrors = {};
  bool isSaving = false;

  final fieldAlamat1Controller = TextEditingController();
  final fieldEmailController = TextEditingController();
  final fieldTelpController = TextEditingController();
  int fieldTelpCountryCode = InternationalPhoneHelper.defaultCountryCode;

  ComboMKotaModel? fieldComboMKota;
  final comboMKotaKey = GlobalKey<DropdownSearchState<ComboMKotaModel>>();
  ComboMPropinsiModel? fieldComboMPropinsi;
  final comboMPropinsiKey =
      GlobalKey<DropdownSearchState<ComboMPropinsiModel>>();
  ComboRKodeposModel? fieldComboRKodepos;
  final comboRKodeposKey = GlobalKey<DropdownSearchState<ComboRKodeposModel>>();

  bool _isFirstLoad = true;
  bool _isLoadingInitialData = true;

  @override
  void initState() {
    super.initState();
    mRekanContactCrudBloc = context.read<MRekanContactCrudBloc>();

    mRekanContactCrudBloc.add(MRekanContactCrudResetStatusEvent());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
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
            child: BlocListener<MRekanContactCrudBloc, MRekanContactCrudState>(
              listenWhen: (prev, curr) =>
                  prev.isLoaded != curr.isLoaded ||
                  prev.isSaved != curr.isSaved,
              listener: _handleCrudState,
              child: _isLoadingInitialData
                  ? const LoadingIndicator()
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 20,
                          ),
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

  void _handleCrudState(
    BuildContext context,
    MRekanContactCrudState state,
  ) {
    if (state.isLoaded && _isFirstLoad) {
      if (state.record != null) {
        final contact = state.record!;

        if (fieldAlamat1Controller.text.trim().isEmpty) {
          final alamat = contact.alamat1.trim();
          if (alamat.isNotEmpty) {
            fieldAlamat1Controller.text = alamat;
          }
        }

        final contactEmail = contact.email.trim();
        final contactTelp = contact.telp.trim();

        final rekan = context.read<MRekan1CrudBloc>().state.record;
        final rekanEmail = (rekan?.email ?? '').trim();
        final rekanTelp = (rekan?.telepon ?? '').trim();

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
            _setPhoneFieldFromRaw(contactTelp);
          } else if (rekanTelp.isNotEmpty) {
            _setPhoneFieldFromRaw(rekanTelp);
          } else if (userTelp.isNotEmpty) {
            _setPhoneFieldFromRaw(userTelp);
          }
        }

        _injectPayload(contact);
      }

      if (mounted) {
        setState(() {
          _isFirstLoad = false;
          _isLoadingInitialData = false;
        });
      }
    }

    if (state.isSaved) {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }

      if (!state.hasFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          successSnackBar("Data berhasil disimpan!"),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar("Data gagal disimpan!"),
        );
      }

      context
          .read<MRekanContactCrudBloc>()
          .add(MRekanContactCrudResetStatusEvent());
    }
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
            style: headingStyle(
              context,
              fontSize: getResponsiveFont(context, 22),
            ).copyWith(color: Colors.white),
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
          AppButton.primary(
            text: "Simpan Perubahan",
            isLoading: isSaving,
            backgroundColor: isSaving ? secondaryBlackColor : primaryColor,
            onPressed: isSaving
                ? null
                : () async {
                    await onSaveForm();
                  },
          )
        ],
      ),
    );
  }

  void _injectPayload(MRekanContactCrudModel record) {
    fieldComboMKota = record.comboMKota;
    fieldComboMPropinsi = record.comboMPropinsi;
    fieldComboRKodepos = record.comboRKodepos;
  }

  void _setPhoneFieldFromRaw(String rawPhone) {
    final digits = InternationalPhoneHelper.clean(rawPhone);
    final detected = InternationalPhoneHelper.detectCountry(digits);
    fieldTelpCountryCode =
        detected?.dialCode ?? InternationalPhoneHelper.defaultCountryCode;
    fieldTelpController.text = InternationalPhoneHelper.toNationalInput(
      rawPhone,
      countryCode: fieldTelpCountryCode,
    );
  }

  void loadData() {
    if (mounted) {
      setState(() {
        _isLoadingInitialData = true;
      });
    }

    mRekanContactCrudBloc.add(MRekanContactCrudLihatEvent());
  }

  bool validateContactForm() {
    clearErrs();

    bool ok = true;

    final email = fieldEmailController.text.trim();
    if (email.isEmpty) {
      setErr('email', kEmailNullError);
      ok = false;
    } else if (!emailValidatorRegExp.hasMatch(email)) {
      setErr('email', "Format email tidak valid");
      ok = false;
    }

    final alamat = fieldAlamat1Controller.text.trim();
    if (alamat.isEmpty) {
      setErr('alamat1', kAddressNullError);
      ok = false;
    }

    final telp = fieldTelpController.text.trim();
    if (telp.isEmpty) {
      setErr('telp', kPhoneNumberNullError);
      ok = false;
    } else {
      final res = InternationalPhoneHelper.normalize(
        telp,
        countryCode: fieldTelpCountryCode,
      );
      if (!res.isValid) {
        setErr('telp', res.error ?? 'Nomor telepon tidak valid');
        ok = false;
      }
    }

    if (fieldComboMPropinsi == null) {
      setErr('provinsi', kStringProvinsiError);
      ok = false;
    }

    if (fieldComboMKota == null) {
      setErr('kota', kStringKotaError);
      ok = false;
    }

    return ok;
  }

  Widget buildFieldEmail() => appTextField(
        label: "Email",
        controller: fieldEmailController,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        errorText: err('email'),
        validator: (_) => err('email'),
        onChanged: (v) {
          final email = v.trim();
          if (email.isNotEmpty && emailValidatorRegExp.hasMatch(email)) {
            clearErr('email');
          }
        },
      );

  Widget buildFieldTelp() {
    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;

    final jenisClientLabel = switch (mjenisClient) {
      '10' => 'Individu',
      '20' => 'Perusahaan',
      _ => 'Perusahaan',
    };

    return AppPhoneNumberField(
      label: 'No. Telp $jenisClientLabel',
      controller: fieldTelpController,
      countryCode: fieldTelpCountryCode,
      onCountryCodeChanged: (value) {
        setState(() {
          fieldTelpCountryCode = value;
        });
        clearErr('telp');
      },
      errorText: err('telp'),
      validator: (_) => err('telp'),
      onChanged: (v) {
        final telp = v.trim();
        if (telp.isNotEmpty &&
            InternationalPhoneHelper.normalize(
              telp,
              countryCode: fieldTelpCountryCode,
            ).isValid) {
          clearErr('telp');
        }
      },
    );
  }

  Widget buildFieldAlamat1() => appTextField(
        label: "Alamat Rumah",
        controller: fieldAlamat1Controller,
        keyboardType: TextInputType.streetAddress,
        errorText: err('alamat1'),
        validator: (_) => err('alamat1'),
        onChanged: (v) {
          if (v.trim().isNotEmpty) clearErr('alamat1');
        },
      );

  Widget buildFieldMpropinsiId() => ReusableComboBoxV2<ComboMPropinsiModel>(
        hintText: "Provinsi",
        comboKey: comboMPropinsiKey,
        initItem: fieldComboMPropinsi,
        loader: (q) =>
            ComboMPropinsiRepository().getComboMPropinsi(q.searchText),
        displayText: (item) => item.propinsiNama,
        compareItems: (a, b) => a.mpropinsiId == b.mpropinsiId,
        validatorCallback: (v) => v == null ? kStringProvinsiError : null,
        errorText: err('provinsi'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMPropinsi = v;
            fieldComboMKota = null;
            fieldComboRKodepos = null;
          });
          if (v != null) clearErr('provinsi');
        },
        onSaveCallback: (value) => fieldComboMPropinsi = value,
      );

  Widget buildFieldMkotaId() => ReusableComboBoxV2<ComboMKotaModel>(
        hintText: "Kota",
        comboKey: comboMKotaKey,
        initItem: fieldComboMKota,
        isEnabled: fieldComboMPropinsi != null,
        dependencyKey: fieldComboMPropinsi?.mpropinsiId,
        params: {
          "mpropinsiId": fieldComboMPropinsi?.mpropinsiId ?? "",
        },
        loader: (q) {
          final mpropinsiId = q.get<String>("mpropinsiId") ?? "";

          return ComboMKotaRepository().getComboMKota(mpropinsiId);
        },
        displayText: (item) => item.kotaDesc,
        compareItems: (a, b) => a.mkotaId == b.mkotaId,
        validatorCallback: (v) => v == null ? kStringKotaError : null,
        errorText: err('kota'),
        onChangedCallback: (v) {
          setState(() {
            fieldComboMKota = v;
            fieldComboRKodepos = null;
          });
          if (v != null) clearErr('kota');
        },
        onSaveCallback: (value) => fieldComboMKota = value,
      );

  Widget buildFieldRkodeposId() => ReusableComboBoxV2<ComboRKodeposModel>(
        hintText: "Kodepos (Opsional)",
        comboKey: comboRKodeposKey,
        initItem: fieldComboRKodepos,
        showClearButton: true,
        isEnabled: fieldComboMKota != null,
        dependencyKey: fieldComboMKota?.mkotaId,

        params: {
          "mkotaId": fieldComboMKota?.mkotaId ?? "",
        },

        loader: (q) {
          final mkotaId = q.get<String>("mkotaId") ?? "";

          return ComboRKodeposRepository().getComboRKodepos(
            mkotaId,
            q.searchText,
          );
        },

        displayText: (item) => item.kodeposNo,
        compareItems: (a, b) => a.rkodeposId == b.rkodeposId,

        //validatorCallback: (v) => v == null ? kStringKodeposError : null,

        onChangedCallback: (v) {
          setState(() {
            fieldComboRKodepos = v;
          });
        },

        onSaveCallback: (value) => fieldComboRKodepos = value,
      );

  Future<void> onSaveForm() async {
    if (!validateContactForm()) return;
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final phoneRes = InternationalPhoneHelper.normalize(
      fieldTelpController.text.trim(),
      countryCode: fieldTelpCountryCode,
    );

    final telpNormalized = phoneRes.phone ?? "";

    if (mounted) {
      setState(() {
        isSaving = true;
      });
    }

    final currentRecord = mRekanContactCrudBloc.state.record;

    final record = MRekanContactCrudModel(
      alamat1: fieldAlamat1Controller.text.trim(),
      email: fieldEmailController.text.trim(),
      mkotaId: fieldComboMKota?.mkotaId,
      mpropinsiId: fieldComboMPropinsi?.mpropinsiId,
      mrekancontact1Id: currentRecord?.mrekancontact1Id ?? '',
      rkodeposId: fieldComboRKodepos?.rkodeposId,
      telp: telpNormalized,
      comboMKota: fieldComboMKota,
      comboMPropinsi: fieldComboMPropinsi,
      comboRKodepos: fieldComboRKodepos,
    );

    mRekanContactCrudBloc.add(
      MRekanContactCrudUbahEvent(record: record),
    );
  }

  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }

  void clearErrs() {
    setState(() => fieldErrors.clear());
  }
}
