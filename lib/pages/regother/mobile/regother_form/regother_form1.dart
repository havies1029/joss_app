import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/blocs/regother/regother1crud_bloc.dart';
import 'package:joss_app/models/regother/regother1crud_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/pages/regother/mobile/regother_form/regother_cob_list_page.dart';
import 'package:joss_app/pages/regother/mobile/regother_form/regother_success.dart';
import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import '../../../../blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import '../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../common/app_data.dart';
import '../../../../helper/navigation_keys.dart';
import '../../../../models/combobox/combomcobapp1_model.dart';
import '../../../../repositories/combobox/combormatauang_repository.dart';
import '../../../../widgets/apptheme/dropdown2.dart';
import '../../../../widgets/apptheme/register_client_pop_up.dart';
import '../../../profile/mobile/profile/form_section/popup/rekan_general_cmp.dart';
import '../../../profile/mobile/profile/form_section/popup/rekan_general_idv.dart';
import '../../../register/mobile/client/register_phone_gate_page.dart';

class Regother1CrudFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const Regother1CrudFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  Regother1CrudFormPageFormState createState() =>
      Regother1CrudFormPageFormState();
}

class Regother1CrudFormPageFormState extends State<Regother1CrudFormPage> {
  late Regother1CrudBloc regother1CrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  final Map<String, String?> fieldErrors = {};
  bool _isKonfirmasiLoading = false;
  bool _pendingAutoConfirm = false;
  bool _isDialogLoadingShown = false;

  ComboRMatauangModel? fieldComboRMatauang;
  ComboMCobApp1Model? fieldComboMCobApp1;
  final comboRMatauangKey =
      GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
  var fieldRemarkController = TextEditingController();
  var fieldTsiController = TextEditingController();

  late MRekanGeneralCmpCrudBloc mRekanGeneralCmpCrudBloc;
  late MRekanGeneralIdvCrudBloc mRekanGeneralIdvCrudBloc;
  late RegUserBloc regUserBloc;
  late AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    super.initState();

    context.read<Regother1CrudBloc>().add(
          const ResetSelectedCobEvent(),
        );

    _loadDefaultCurrency();

    regUserBloc = context.read<RegUserBloc>();
    authenticationBloc = context.read<AuthenticationBloc>();

    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;

    if (mjenisClient == "10") {
      context.read<MRekanGeneralIdvCrudBloc>().add(
            MRekanGeneralIdvCrudLihatEvent(),
          );
    } else if (mjenisClient == "20") {
      context.read<MRekanGeneralCmpCrudBloc>().add(
            MRekanGeneralCmpCrudLihatEvent(),
          );
    }

    loadData();
  }

  Future<void> _loadDefaultCurrency() async {
    final currencies = await ComboRMatauangRepository().getComboRMatauang();

    final idrCurrency = currencies.firstWhere(
      (curr) => curr.rmatauangSimbol == 'IDR',
      orElse: () => currencies.first,
    );

    setState(() {
      fieldComboRMatauang = idrCurrency;
    });
  }

  void _showGlobalLoading() {
    if (!mounted || _isDialogLoadingShown) return;

    _isDialogLoadingShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: LoadingIndicator(),
          ),
        );
      },
    );
  }

  void _hideGlobalLoading() {
    if (!mounted || !_isDialogLoadingShown) return;

    _isDialogLoadingShown = false;

    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    regother1CrudBloc = BlocProvider.of<Regother1CrudBloc>(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<MRekanGeneralIdvCrudBloc, MRekanGeneralIdvCrudState>(
          listenWhen: (previous, current) =>
              previous.isLoaded != current.isLoaded && current.isLoaded,
          listener: (context, state) => _tryAutoConfirm(),
        ),
        BlocListener<MRekanGeneralCmpCrudBloc, MRekanGeneralCmpCrudState>(
          listenWhen: (previous, current) =>
              previous.isLoaded != current.isLoaded && current.isLoaded,
          listener: (context, state) => _tryAutoConfirm(),
        ),
      ],
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) return;

          if (regUserBloc.state.requestFrom.isNotEmpty) {
            authenticationBloc.add(
              LoggedIn(user: AppData.user),
            );
            regUserBloc.add(ClearRequestFromEvent());
          }
          regother1CrudBloc.add(
            const ResetSelectedCobEvent(),
          );
        },
        child: BlocConsumer<Regother1CrudBloc, Regother1CrudState>(
          builder: (context, state) {
            return BaseBackgroundSidePage(
              title: 'Lainnya',
              onHome: () async {
                regother1CrudBloc.add(
                  const ResetSelectedCobEvent(),
                );

                final homeState = homeTabKey.currentState;

                if (homeState != null) {
                  homeState.goToHeroPage();
                }

                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              onBack: () async {
                if (regUserBloc.state.requestFrom.isNotEmpty) {
                  authenticationBloc.add(
                    LoggedIn(user: AppData.user),
                  );
                  regUserBloc.add(ClearRequestFromEvent());
                  regother1CrudBloc.add(
                    const ResetSelectedCobEvent(),
                  );
                }
                Navigator.pop(context);
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  color: secondaryBlackColor,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Pilih jenis asuransi yang ingin Anda beli. Sesuaikan dengan kebutuhan perlindungan Anda.",
                            style: bodyTextStyle(context),
                          ),
                        ),
                        buildFieldMcobId(),
                        const SizedBox(height: 12),
                        buildFieldTsi(),
                        const SizedBox(height: 12),
                        buildFieldRemark(),
                        const SizedBox(height: 25),
                        BlocBuilder<MRekanGeneralIdvCrudBloc,
                            MRekanGeneralIdvCrudState>(
                          builder: (context, idvState) {
                            return BlocBuilder<MRekanGeneralCmpCrudBloc,
                                MRekanGeneralCmpCrudState>(
                              builder: (context, cmpState) {
                                return AppButton.primary(
                                  text: "Konfirmasi",
                                  isLoading: _isKonfirmasiLoading,
                                  backgroundColor: _isKonfirmasiLoading
                                      ? secondaryBlackColor
                                      : primaryColor,
                                  onPressed: _isKonfirmasiLoading
                                      ? null
                                      : () {
                                          onSaveForm(
                                            idvState: idvState,
                                            cmpState: cmpState,
                                          );
                                        },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {
            if (state.isLoaded && state.record != null) {
              setState(() {
                fieldRemarkController.text = state.record!.remark;
                fieldTsiController.text =
                    NumberFormat("#,###").format(state.record!.tsi);

                fieldComboRMatauang = state.comboRMatauang;
                fieldComboMCobApp1 = state.comboMCobApp1;
              });
            }

            if (state.isSaved) {
              _hideGlobalLoading();

              if (mounted) {
                setState(() {
                  _isKonfirmasiLoading = false;
                });
              }

              if (state.hasFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBar("Pengajuan gagal dikirim. Silakan coba lagi."),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegotherSucess(
                    display: "Berhasil dikirim!",
                    purpose: "O",
                  ),
                ),
              );
              _resetForm();
            }
          },
        ),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();

    setState(() {
      fieldRemarkController.clear();
      fieldTsiController.clear();
      fieldComboMCobApp1 = null;
      fieldComboRMatauang = null;
      fieldErrors.clear();
    });

    _loadDefaultCurrency();
  }

  void loadData() {
    if (widget.viewMode == "ubah") {
      regother1CrudBloc.add(Regother1CrudLihatEvent(recordId: widget.recordId));
    }
  }

  // Widget buildFieldCurrId() => ReusableComboBox<ComboRMatauangModel>(
  //   hintText: "Mata Uang",
  //   initItem: fieldComboRMatauang,
  //   dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
  //   displayText: (i) => i.rmatauangSimbol,
  //   compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
  //   validatorCallback: (v) => v == null ? kStringNullError : null,
  //   onChangedCallback: (v) => fieldComboRMatauang = v,
  //   onSaveCallback: (value) => fieldComboRMatauang = value,
  // );

  Widget buildFieldMcobId() {
    final errorText = err('mcobId');

    return FormField<ComboMCobApp1Model>(
      initialValue: fieldComboMCobApp1,
      validator: (_) => err('mcobId'),
      builder: (fieldState) => GestureDetector(
        onTap: () async {
          final ComboMCobApp1Model? selected =
              await Navigator.push<ComboMCobApp1Model>(
            context,
            MaterialPageRoute(builder: (_) => const CobCariPage()),
          );

          if (!mounted) return;

          if (selected != null) {
            context.read<Regother1CrudBloc>().add(
                  ComboMCobApp1ChangedEvent(comboMCobApp1: selected),
                );

            fieldState.didChange(selected);
            setState(() => fieldComboMCobApp1 = selected);
            clearErr('mcobId');
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: formGrey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: errorText != null ? Colors.red : sGrey,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      fieldComboMCobApp1 == null
                          ? "Pilih Kategori Asuransi"
                          : fieldComboMCobApp1!.cobNama,
                      style: bodyTextStyle(context).copyWith(
                        color: fieldComboMCobApp1 == null
                            ? primaryColor
                            : primaryLightColor,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/icons/dropdown.svg",
                    width: 16,
                    colorFilter: const ColorFilter.mode(
                      primaryLightColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  errorText,
                  style: bodyTextStyle(context).copyWith(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildFieldRemark() {
    return appTextField(
      label: 'Tambahkan Catatan',
      keyboardType: TextInputType.multiline,
      hint: "Jelaskan kebutuhan Anda terkait pembelian polis.",
      maxLines: 3,
      controller: fieldRemarkController,
      errorText: err('remark'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) clearErr('remark');
      },
      validator: (_) => err('remark'),
    );
  }

  Widget buildFieldTsi() {
    return AppCurrencyField(
      label: "Nilai Pertanggungan",
      currency: fieldComboRMatauang,
      onCurrencyChanged: (v) {
        setState(() => fieldComboRMatauang = v);
        if (v != null && fieldTsiController.text.trim().isNotEmpty) {
          clearErr('tsi');
        }
      },
      valueController: fieldTsiController,
      errorText: err('tsi'),
      onChanged: (v) {
        if (_isValidTsi(v) && fieldComboRMatauang != null) {
          clearErr('tsi');
        }
      },
      validator: (_) => err('tsi'),
    );
  }

  void _showPengajuanDialog({
    required MRekanGeneralIdvCrudState idvState,
    required MRekanGeneralCmpCrudState cmpState,
  }) {
    final authState = context.read<AuthenticationBloc>().state;
    final pageContext = context;
    final userType = authState is AuthenticationAuthenticated
        ? authState.user.userType.trim().toUpperCase()
        : "";

    if (authState is! AuthenticationAuthenticated || userType != "C") {
      showDialog(
        context: pageContext,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.6),
        builder: (_) => RegisterClientPopUp(
          header: 'Data Klien Belum Terdaftar!',
          description:
              'Untuk melanjutkan ke proses Registrasi, Anda perlu mendaftarkan data klien terlebih dahulu.',
          buttonText: 'Daftar Klien',
          onPressed: () {
            _pendingAutoConfirm = true;
            Navigator.push(
              pageContext,
              MaterialPageRoute(
                builder: (context) => RegisterPhoneGatePage(
                  requestFrom: 'regother_page',
                ),
              ),
            );
          },
        ),
      );
      return;
    }

    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;

    if (mjenisClient == "10") {
      if (idvState.isLoading || !idvState.isLoaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar('Data pribadi masih dimuat. Silakan coba lagi.'),
        );
        return;
      }

      if (!idvState.isDataComplete) {
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.6),
          builder: (context) => RegisterClientPopUp(
            header: 'Isi Data Pribadi Anda',
            description:
                'Lengkapi data pribadi Anda terlebih dahulu untuk melanjutkan proses ini.',
            buttonText: 'Lengkapi Data Pribadi',
            onPressed: () {
              _pendingAutoConfirm = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MRekanGeneralIdvPopUpPage(),
                ),
              );
            },
          ),
        );
        return;
      }
    }

    if (mjenisClient == "20") {
      if (cmpState.isLoading || !cmpState.isLoaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar('Data perusahaan masih dimuat. Silakan coba lagi.'),
        );
        return;
      }

      if (!cmpState.isDataComplete) {
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.6),
          builder: (context) => RegisterClientPopUp(
            header: 'Isi Data Perusahaan Anda',
            description:
                'Lengkapi data perusahaan Anda terlebih dahulu untuk melanjutkan proses ini.',
            buttonText: 'Lengkapi Data Perusahaan',
            onPressed: () {
              _pendingAutoConfirm = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MRekanGeneralCmpPopUpPage(),
                ),
              );
            },
          ),
        );
        return;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: formGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/regother_ajukan.svg',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(height: hPadding),
                Text(
                  "Pengajuan diproses tim internal.",
                  textAlign: TextAlign.center,
                  style: headingStyle(context, fontSize: 17.49),
                ),
                const SizedBox(height: hPadding),
                AppButton.primary(
                  text: 'Ajukan Sekarang',
                  backgroundColor: const Color(0xFF0ED7FF),
                  onPressed: () {
                    Navigator.pop(context);
                    _showGlobalLoading();
                    _executeSave();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _executeSave() {
    if (!validateRegotherForm()) return;
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    _saveRegother();
  }

  void _executeSaveSilently() {
    if (!validateRegotherForm()) return;
    if (!_formKey.currentState!.validate()) return;

    _saveRegother();
  }

  void _saveRegother() {
    Regother1CrudModel record = Regother1CrudModel(
      currId: fieldComboRMatauang?.rmatauangKode,
      regother1Id: '',
      comboMCobApp1: fieldComboMCobApp1,
      mcobId: fieldComboMCobApp1!.mCobApp1Id,
      remark: fieldRemarkController.text,
      tsi: double.parse(fieldTsiController.text.replaceAll(',', '')),
    );

    regother1CrudBloc.add(
      const ResetSelectedCobEvent(),
    );

    if (widget.viewMode == "tambah") {
      regother1CrudBloc.add(Regother1CrudTambahEvent(record: record));
    } else if (widget.viewMode == "ubah") {
      record.regother1Id = regother1CrudBloc.state.record!.regother1Id;
      regother1CrudBloc.add(Regother1CrudUbahEvent(record: record));
    }
  }

  void onSaveForm({
    required MRekanGeneralIdvCrudState idvState,
    required MRekanGeneralCmpCrudState cmpState,
  }) {
    if (!validateRegotherForm()) return;
    if (!_formKey.currentState!.validate()) return;

    _showPengajuanDialog(
      idvState: idvState,
      cmpState: cmpState,
    );
  }

  bool validateRegotherForm() {
    final nextErrors = <String, String?>{};

    if (fieldComboMCobApp1 == null) {
      nextErrors['mcobId'] = kStringNullError;
    }

    if (fieldComboRMatauang == null) {
      nextErrors['tsi'] = kStringNullError;
    } else if (fieldTsiController.text.trim().isEmpty) {
      nextErrors['tsi'] = kStringNullError;
    } else if (!_isValidTsi(fieldTsiController.text)) {
      nextErrors['tsi'] = 'Nilai pertanggungan tidak valid';
    }

    if (fieldRemarkController.text.trim().isEmpty) {
      nextErrors['remark'] = kStringNullError;
    }

    setState(() {
      fieldErrors
        ..clear()
        ..addAll(nextErrors);
    });

    return nextErrors.isEmpty;
  }

  bool _isValidTsi(String value) {
    final cleaned = value.replaceAll(',', '').trim();
    if (cleaned.isEmpty) return false;
    return double.tryParse(cleaned) != null;
  }

  bool _isFormFilledSilently() {
    return fieldComboMCobApp1 != null &&
        fieldComboRMatauang != null &&
        fieldTsiController.text.trim().isNotEmpty &&
        fieldRemarkController.text.trim().isNotEmpty;
  }

  void _tryAutoConfirm() {
    final requestFrom = regUserBloc.state.requestFrom;
    final shouldAutoConfirm =
        _pendingAutoConfirm || requestFrom == 'regother_page';

    if (!shouldAutoConfirm || !_isFormFilledSilently()) return;

    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;
    final idvState = context.read<MRekanGeneralIdvCrudBloc>().state;
    final cmpState = context.read<MRekanGeneralCmpCrudBloc>().state;

    if (mjenisClient == "10" &&
        (idvState.isLoading ||
            !idvState.isLoaded ||
            !idvState.isDataComplete)) {
      return;
    }

    if (mjenisClient == "20" &&
        (cmpState.isLoading ||
            !cmpState.isLoaded ||
            !cmpState.isDataComplete)) {
      return;
    }

    if (mjenisClient != "10" && mjenisClient != "20") return;

    _pendingAutoConfirm = false;
    regUserBloc.add(const ClearRequestFromEvent());
    if (mounted) {
      setState(() {
        _isKonfirmasiLoading = true;
      });
    }
    _executeSaveSilently();
  }

  String? err(String key) => fieldErrors[key];

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }
}

class AppCurrencyField extends StatelessWidget {
  final String label;
  final ComboRMatauangModel? currency;
  final Function(ComboRMatauangModel?) onCurrencyChanged;
  final TextEditingController valueController;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const AppCurrencyField({
    super.key,
    required this.label,
    required this.currency,
    required this.onCurrencyChanged,
    required this.valueController,
    this.validator,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) => validator?.call(valueController.text),
      builder: (fieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: formGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                border: Border.all(
                  color: errorText != null ? Colors.red : sGrey,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: SizedBox(
                      width: 100,
                      child: ReusableComboBoxV2<ComboRMatauangModel>(
                        hintText: "",
                        initItem: currency,
                        loader: (q) =>
                            ComboRMatauangRepository().getComboRMatauang(),
                        clientSideSearch: true,
                        displayText: (m) => m.rmatauangSimbol,
                        compareItems: (a, b) =>
                            a.rmatauangKode == b.rmatauangKode,
                        enableSearch: false,
                        onChangedCallback: onCurrencyChanged,
                        onSaveCallback: onCurrencyChanged,
                        maxHeight: 200,
                      ),
                    ),
                  ),
                  Container(width: 1, height: 30, color: sGrey),
                  Expanded(
                    child: TextFormField(
                      controller: valueController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter.currency(
                          locale: 'en',
                          decimalDigits: 0,
                          symbol: '',
                        ),
                      ],
                      onChanged: (value) {
                        fieldState.didChange(value);
                        onChanged?.call(value);
                      },
                      cursorColor: primaryLightColor,
                      style: bodyTextStyle(context),
                      decoration: const InputDecoration(
                        hintText: "Nilai Pertanggungan",
                        hintStyle: TextStyle(color: primaryColor),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  errorText!,
                  style: bodyTextStyle(context).copyWith(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
