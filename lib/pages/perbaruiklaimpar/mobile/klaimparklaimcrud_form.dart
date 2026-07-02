import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/repositories/combobox/combomjenisrugi_repository.dart';
import 'package:joss_app/blocs/perbaruiklaimpar/klaimparklaimcrud_bloc.dart';
import 'package:joss_app/models/combobox/combomjenisrugi_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import '../../../helper/phone_number_result.dart';
import '../../../widgets/apptheme/dropdown2.dart';
import '../../../widgets/combobox/combormatauang_widget.dart';
import '../../perbaruiklaimmv/mobile/klaimmvklaimcrud_form.dart';

class KlaimparklaimcrudFormPage extends StatefulWidget {
  final String cobGroupId;
  final String viewMode;
  final String recordId;
  final GlobalKey<FormState> formKey;

  const KlaimparklaimcrudFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    required this.cobGroupId,
    required this.formKey,
  });

  @override
  KlaimparklaimcrudFormPageFormState createState() =>
      KlaimparklaimcrudFormPageFormState();
}

class KlaimparklaimcrudFormPageFormState
    extends State<KlaimparklaimcrudFormPage> {
  late KlaimparklaimcrudBloc klaimparklaimcrudBloc;

  final fieldDolController = TextEditingController();
  final fieldKeteranganController = TextEditingController();
  final fieldLaporAsuransiController = TextEditingController();
  final fieldLaporJpsController = TextEditingController();

  ComboMJenisrugiModel? fieldComboMJenisrugi;
  final comboMJenisrugiKey =
      GlobalKey<DropdownSearchState<ComboMJenisrugiModel>>();

  ComboRMatauangModel? fieldComboRMatauang;
  final comboRMatauangKey =
      GlobalKey<DropdownSearchState<ComboRMatauangModel>>();

  final fieldKlaimAmountController = TextEditingController();
  final fieldPenyebabController = TextEditingController();
  final fieldPicEmailController = TextEditingController();
  final fieldPicJabatanController = TextEditingController();
  final fieldPicNamaController = TextEditingController();
  final fieldPicTelpController = TextEditingController();

  bool isPolisJps = false;

  final fieldCobNamaController = TextEditingController();

  final Map<String, String?> fieldErrors = {};

  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() {
      fieldErrors[key] = msg;
    });
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() {
      fieldErrors.remove(key);
    });
  }

  void clearErrsByPrefix(String prefix) {
    setState(() {
      fieldErrors.removeWhere((k, _) => k.startsWith(prefix));
    });
  }

  bool validateForm() {
    clearErrsByPrefix('form.');

    bool ok = true;

    if (!_isEmptyOrValidDate(fieldDolController.text)) {
      setErr('form.dol', 'Format tanggal tidak valid');
      ok = false;
    }

    if (!_isEmptyOrValidDate(fieldLaporJpsController.text)) {
      setErr('form.laporJps', 'Format tanggal tidak valid');
      ok = false;
    }

    if (!isPolisJps) {
      if (!_isEmptyOrValidDate(fieldLaporAsuransiController.text)) {
        setErr('form.laporAsuransi', 'Format tanggal tidak valid');
        ok = false;
      }
    }

    final picNama = fieldPicNamaController.text.trim();
    if (picNama.isEmpty) {
      setErr('form.picNama', kStringNullError);
      ok = false;
    }

    final picJabatan = fieldPicJabatanController.text.trim();
    if (picJabatan.isEmpty) {
      setErr('form.picJabatan', kStringNullError);
      ok = false;
    }

    final email = fieldPicEmailController.text.trim();
    if (email.isEmpty) {
      setErr('form.picEmail', kEmailNullError);
      ok = false;
    } else if (!emailValidatorRegExp.hasMatch(email)) {
      setErr('form.picEmail', 'Format email tidak valid');
      ok = false;
    }

    final telp = fieldPicTelpController.text.trim();

    if (telp.isEmpty) {
      setErr('form.picTelp', kPhoneNumberNullError);
      ok = false;
    } else {
      if (!PhoneNumberHelper.isValid(telp)) {
        setErr('form.picTelp', "Nomor telepon tidak valid");
        ok = false;
      }
    }

    if (fieldComboMJenisrugi == null) {
      setErr(
        'form.mjenisrugiId',
        "Field ComboMJenisrugi tidak boleh kosong.",
      );
      ok = false;
    }

    final penyebab = fieldPenyebabController.text.trim();
    if (penyebab.isEmpty) {
      setErr('form.penyebab', kStringNullError);
      ok = false;
    }

    final keterangan = fieldKeteranganController.text.trim();
    if (keterangan.isEmpty) {
      setErr('form.keterangan', kStringNullError);
      ok = false;
    }

    if (fieldComboRMatauang == null) {
      setErr('form.currId', kStringNullError);
      ok = false;
    }

    final klaimAmount = parseAmount(fieldKlaimAmountController.text);
    if (klaimAmount <= 0) {
      setErr('form.klaimAmount', kStringNullError);
      ok = false;
    }

    return ok;
  }

  void syncFormToBloc() {
    klaimparklaimcrudBloc.add(FieldDolChangedEvent(
      dol: _parseOptionalDate(fieldDolController.text),
    ));

    klaimparklaimcrudBloc.add(FieldLaporJpsChangedEvent(
      laporJps: _parseOptionalDate(fieldLaporJpsController.text),
    ));

    klaimparklaimcrudBloc.add(FieldLaporAsuransiChangedEvent(
      laporAsuransi: isPolisJps
          ? null
          : _parseOptionalDate(fieldLaporAsuransiController.text),
    ));

    klaimparklaimcrudBloc.add(FieldPicNamaChangedEvent(
      picNama: fieldPicNamaController.text.trim(),
    ));

    klaimparklaimcrudBloc.add(FieldPicJabatanChangedEvent(
      picJabatan: fieldPicJabatanController.text.trim(),
    ));

    klaimparklaimcrudBloc.add(FieldPicEmailChangedEvent(
      picEmail: fieldPicEmailController.text.trim(),
    ));

    klaimparklaimcrudBloc.add(FieldPicTelpChangedEvent(
      picTelp: fieldPicTelpController.text.trim(),
    ));

    if (fieldComboMJenisrugi != null) {
      klaimparklaimcrudBloc.add(
        ComboMJenisrugiChangedEvent(comboMJenisrugi: fieldComboMJenisrugi!),
      );
    }

    if (fieldComboRMatauang != null) {
      klaimparklaimcrudBloc.add(
        ComboRMatauangChangedEvent(comboRMatauang: fieldComboRMatauang!),
      );
    }

    klaimparklaimcrudBloc.add(FieldKlaimAmountChangedEvent(
      klaimAmount: parseAmount(fieldKlaimAmountController.text),
    ));

    klaimparklaimcrudBloc.add(FieldPenyebabChangedEvent(
      penyebab: fieldPenyebabController.text.trim(),
    ));

    klaimparklaimcrudBloc.add(FieldKeteranganChangedEvent(
      keterangan: fieldKeteranganController.text.trim(),
    ));
  }

  bool runFullValidation() {
    final ok = validateForm();
    widget.formKey.currentState?.validate();

    if (ok) {
      syncFormToBloc();
    }

    return ok;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  void dispose() {
    fieldDolController.dispose();
    fieldKeteranganController.dispose();
    fieldLaporAsuransiController.dispose();
    fieldLaporJpsController.dispose();
    fieldPenyebabController.dispose();
    fieldPicEmailController.dispose();
    fieldPicJabatanController.dispose();
    fieldPicNamaController.dispose();
    fieldPicTelpController.dispose();
    fieldCobNamaController.dispose();
    fieldKlaimAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    klaimparklaimcrudBloc = BlocProvider.of<KlaimparklaimcrudBloc>(context);

    return BlocConsumer<KlaimparklaimcrudBloc, KlaimparklaimcrudState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                if (widget.cobGroupId == "10003") ...[
                  buildFieldCobNama(),
                  const SizedBox(height: hPadding),
                ],
                Row(
                  children: [
                    Flexible(child: buildFieldDol()),
                    const SizedBox(width: 8),
                    Flexible(child: buildFieldLaporJps()),
                  ],
                ),
                const SizedBox(height: hPadding),
                buildFieldLaporAsuransi(),
                const SizedBox(height: hPadding),
                buildFieldPicNama(),
                const SizedBox(height: hPadding),
                buildFieldPicJabatan(),
                const SizedBox(height: hPadding),
                buildFieldPicEmail(),
                const SizedBox(height: hPadding),
                buildFieldPicTelp(),
                const SizedBox(height: hPadding),
                buildFieldMjenisrugiId(),
                const SizedBox(height: hPadding),
                buildFieldKlaimAmount(),
                const SizedBox(height: hPadding),
                buildFieldPenyebab(),
                const SizedBox(height: hPadding),
                buildFieldKeterangan(),
                const SizedBox(height: hPadding),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.isLoaded) {
          if (state.record != null) {
            fieldDolController.text = _dateToText(state.record!.dol);
            fieldKeteranganController.text = state.record!.keterangan;
            fieldLaporAsuransiController.text =
                _dateToText(state.record!.laporAsuransi);
            fieldLaporJpsController.text = _dateToText(state.record!.laporJps);
            fieldPenyebabController.text = state.record!.penyebab;
            fieldPicEmailController.text = state.record!.picEmail;
            fieldPicJabatanController.text = state.record!.picJabatan;
            fieldPicNamaController.text = state.record!.picNama;
            fieldComboRMatauang = state.comboRMatauang;
            fieldPicTelpController.text = state.record?.picTelp ?? '';
            isPolisJps = state.record?.isPolisJps ?? false;
            fieldCobNamaController.text = state.record!.cobNama;
            fieldKlaimAmountController.text =
                NumberFormat("#,###").format(state.record!.klaimAmount);
          }
          fieldComboMJenisrugi = state.comboMJenisrugi;
        }
      },
    );
  }

  void loadData() {
    if (widget.viewMode == "ubah") {
      klaimparklaimcrudBloc.add(
        KlaimparklaimcrudLihatEvent(recordId: widget.recordId),
      );
    }
  }

  Widget buildFieldCobNama() {
    return appTextField(
      label: 'Kategori Asuransi',
      enabled: false,
      controller: fieldCobNamaController,
    );
  }

  Widget buildFieldDol() {
    return AppDateField(
      label: 'Tanggal Kejadian',
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      enabled: !isPolisJps,
      initialValue: DateTime.tryParse(fieldDolController.text),
      validator: (_) => err('form.dol'),
      onChanged: (value) {
        fieldDolController.text = value?.toIso8601String() ?? '';
        clearErr('form.dol');
        klaimparklaimcrudBloc.add(FieldDolChangedEvent(dol: value));
      },
    );
  }

  Widget buildFieldKeterangan() {
    return appTextField(
      label: 'Keterangan',
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      controller: fieldKeteranganController,
      errorText: err('form.keterangan'),
      validator: (_) => err('form.keterangan'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          clearErr('form.keterangan');
        }
        klaimparklaimcrudBloc.add(
          FieldKeteranganChangedEvent(keterangan: value),
        );
      },
    );
  }

  Widget buildFieldLaporAsuransi() {
    return AppDateField(
      label: 'Tanggal ke Asuransi',
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      enabled: !isPolisJps,
      initialValue: DateTime.tryParse(fieldLaporAsuransiController.text),
      validator: (_) => err('form.laporAsuransi'),
      onChanged: (value) {
        fieldLaporAsuransiController.text = value?.toIso8601String() ?? '';
        clearErr('form.laporAsuransi');
        klaimparklaimcrudBloc.add(
          FieldLaporAsuransiChangedEvent(laporAsuransi: value),
        );
      },
    );
  }

  Widget buildFieldLaporJps() {
    return AppDateField(
      label: 'Tanggal ke JPS',
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      enabled: !isPolisJps,
      initialValue: DateTime.tryParse(fieldLaporJpsController.text),
      validator: (_) => err('form.laporJps'),
      onChanged: (value) {
        fieldLaporJpsController.text = value?.toIso8601String() ?? '';
        clearErr('form.laporJps');
        klaimparklaimcrudBloc.add(
          FieldLaporJpsChangedEvent(laporJps: value),
        );
      },
    );
  }

  Widget buildFieldMjenisrugiId() {
    return ReusableComboBoxV2<ComboMJenisrugiModel>(
      comboKey: comboMJenisrugiKey,
      hintText: 'Jenis Kerugian',
      initItem: fieldComboMJenisrugi,
      loader: (q) => ComboMJenisrugiRepository().getComboMJenisrugi(),
      clientSideSearch: true,
      displayText: (item) => item.rugiDesc,
      compareItems: (a, b) => a.mjenisrugiId == b.mjenisrugiId,
      errorText: err('form.mjenisrugiId'),
      validatorCallback: (v) => v == null ? kStringNullError : null,
      onChangedCallback: (value) {
        setState(() {
          fieldComboMJenisrugi = value;

          if (value != null) {
            clearErr('form.mjenisrugiId');
          }
        });
        if (value != null) {
          klaimparklaimcrudBloc.add(
            ComboMJenisrugiChangedEvent(comboMJenisrugi: value),
          );
        }
      },
      onSaveCallback: (value) {
        fieldComboMJenisrugi = value;
      },
    );
  }

  Widget buildFieldPenyebab() {
    return appTextField(
      label: 'Penyebab Kerugian',
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      controller: fieldPenyebabController,
      errorText: err('form.penyebab'),
      validator: (_) => err('form.penyebab'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          clearErr('form.penyebab');
        }
        klaimparklaimcrudBloc.add(
          FieldPenyebabChangedEvent(penyebab: value),
        );
      },
    );
  }

  Widget buildFieldPicEmail() {
    return appTextField(
      label: 'Email',
      controller: fieldPicEmailController,
      keyboardType: TextInputType.emailAddress,
      errorText: err('form.picEmail'),
      validator: (_) => err('form.picEmail'),
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      onChanged: (value) {
        final email = value.trim();

        if (email.isEmpty) {
          clearErr('form.picEmail');
        } else if (emailValidatorRegExp.hasMatch(email)) {
          clearErr('form.picEmail');
        } else {
          setErr('form.picEmail', 'Format email tidak valid');
        }

        klaimparklaimcrudBloc.add(
          FieldPicEmailChangedEvent(picEmail: value),
        );
      },
    );
  }

  Widget buildFieldPicJabatan() {
    return appTextField(
      label: 'Jabatan',
      controller: fieldPicJabatanController,
      errorText: err('form.picJabatan'),
      validator: (_) => err('form.picJabatan'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          clearErr('form.picJabatan');
        }
        klaimparklaimcrudBloc.add(
          FieldPicJabatanChangedEvent(picJabatan: value),
        );
      },
    );
  }

  Widget buildFieldPicNama() {
    return appTextField(
      label: 'PIC Tertanggung',
      controller: fieldPicNamaController,
      errorText: err('form.picNama'),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r"[a-zA-Z0-9 .,'-]"),
        ),
      ],
      validator: (_) => err('form.picNama'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          clearErr('form.picNama');
        }
        klaimparklaimcrudBloc.add(
          FieldPicNamaChangedEvent(picNama: value),
        );
      },
    );
  }

  Widget buildFieldPicTelp() {
    return appTextField(
      label: 'No Telp PIC',
      controller: fieldPicTelpController,
      keyboardType: TextInputType.phone,
      errorText: err('form.picTelp'),
      validator: (_) => err('form.picTelp'),
      onChanged: (value) {
        final telp = value.trim();

        if (telp.isEmpty) {
          clearErr('form.picTelp');
        } else {
          if (PhoneNumberHelper.isValid(telp)) {
            clearErr('form.picTelp');
          } else {
            setErr('form.picTelp', "Nomor telepon tidak valid");
          }
        }

        klaimparklaimcrudBloc.add(
          FieldPicTelpChangedEvent(picTelp: value),
        );
      },
    );
  }

  Widget buildFieldCurrId() {
    return buildFieldComboRMatauang(
      comboKey: comboRMatauangKey,
      labelText: 'Mata Uang',
      initItem: fieldComboRMatauang,
      onChangedCallback: (value) {
        setState(() {
          fieldComboRMatauang = value;
          if (value != null) clearErr('form.currId');
        });

        klaimparklaimcrudBloc.add(
          FieldCurrIdChangedEvent(
            currId: fieldComboRMatauang?.rmatauangKode ?? '',
          ),
        );
      },
      onSaveCallback: (value) {
        fieldComboRMatauang = value;

        klaimparklaimcrudBloc.add(
          FieldCurrIdChangedEvent(
            currId: fieldComboRMatauang?.rmatauangKode ?? '',
          ),
        );
      },
    );
  }

  Widget buildFieldKlaimAmount() {
    return AppCurrencyAmountField(
      label: "Nilai Klaim",
      currency: fieldComboRMatauang,
      errorText: err('form.klaimAmount'),
      onCurrencyChanged: (v) {
        setState(() {
          fieldComboRMatauang = v;
          if (v != null) clearErr('form.currId');
        });

        if (v != null) {
          klaimparklaimcrudBloc.add(
            ComboRMatauangChangedEvent(comboRMatauang: v),
          );
        }
      },
      amountController: fieldKlaimAmountController,
      onAmountChanged: (rawText) {
        final amount = parseAmount(rawText);

        klaimparklaimcrudBloc.add(
          FieldKlaimAmountChangedEvent(klaimAmount: amount),
        );

        if (amount > 0) {
          clearErr('form.klaimAmount');
        }
      },
      validator: (_) => err('form.klaimAmount'),
    );
  }

  double parseAmount(String s) {
    final cleaned = s.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return 0;
    return double.tryParse(cleaned) ?? 0;
  }

  DateTime? _parseOptionalDate(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;
    return DateTime.tryParse(text);
  }

  bool _isEmptyOrValidDate(String value) {
    final text = value.trim();
    return text.isEmpty || DateTime.tryParse(text) != null;
  }

  String _dateToText(DateTime? value) {
    return value?.toIso8601String() ?? '';
  }
}
