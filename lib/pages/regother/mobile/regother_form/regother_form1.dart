import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/blocs/regother/regother1crud_bloc.dart';
import 'package:joss_app/models/regother/regother1crud_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/pages/regother/mobile/regother_form/regother_cob_list_page.dart';
import 'package:joss_app/pages/regother/mobile/regother_form/regother_success.dart';
import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import '../../../../blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import '../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../common/app_data.dart';
import '../../../../models/combobox/combomcobapp1_model.dart';
import '../../../../repositories/combobox/combormatauang_repository.dart';
import '../../../../widgets/apptheme/register_client_pop_up.dart';
import '../../../profile/mobile/profile/form_section/popup/rekan_general_cmp.dart';
import '../../../profile/mobile/profile/form_section/popup/rekan_general_idv.dart';
import '../../../register/mobile/client/register_client_page.dart';

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
  bool _isKonfirmasiLoading = false;

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
    _loadDefaultCurrency();
    mRekanGeneralIdvCrudBloc = context.read<MRekanGeneralIdvCrudBloc>();
    mRekanGeneralCmpCrudBloc = context.read<MRekanGeneralCmpCrudBloc>();
    regUserBloc = context.read<RegUserBloc>();
    authenticationBloc = context.read<AuthenticationBloc>();

    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mjenisClient == "10") {
        mRekanGeneralIdvCrudBloc.add(MRekanGeneralIdvCrudLihatEvent());
      }else if (mjenisClient == "20"){
        mRekanGeneralCmpCrudBloc.add(MRekanGeneralCmpCrudLihatEvent());
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
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
  @override
  Widget build(BuildContext context) {
    regother1CrudBloc = BlocProvider.of<Regother1CrudBloc>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (regUserBloc.state.requestFrom.isNotEmpty){
          authenticationBloc.add(
            LoggedIn(user: AppData.user),
          );
          regUserBloc.add(ClearRequestFromEvent());
        }
        Navigator.pop(context);
      },
      child: BlocConsumer<Regother1CrudBloc, Regother1CrudState>(
        builder: (context, state) {
          return BaseBackgroundSidePage(
            title: 'Lainnya',
            onBack: () async {
              if (regUserBloc.state.requestFrom.isNotEmpty){
                authenticationBloc.add(
                  LoggedIn(user: AppData.user),
                );
                regUserBloc.add(ClearRequestFromEvent());
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
                      AppButton.primary(
                        text: "Konfirmasi",
                        isLoading: _isKonfirmasiLoading,
                        backgroundColor:
                        _isKonfirmasiLoading ? secondaryBlackColor : primaryColor,
                        onPressed: _isKonfirmasiLoading
                            ? null
                            : () async {
                          setState(() {
                            _isKonfirmasiLoading = true;
                          });

                          onSaveForm();

                          await Future.delayed(const Duration(seconds: 2));

                          if (mounted) {
                            setState(() {
                              _isKonfirmasiLoading = false;
                            });
                          }
                        },
                      )
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
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();

    setState(() {
      fieldRemarkController.clear();
      fieldTsiController.clear();
      fieldComboMCobApp1 = null;
      fieldComboRMatauang = null;
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
    return GestureDetector(
      onTap: () async {
        final ComboMCobApp1Model? selected =
        await Navigator.push<ComboMCobApp1Model>(
          context,
          MaterialPageRoute(builder: (_) => const CobCariPage()),
        );

        if (selected != null) {
          context.read<Regother1CrudBloc>().add(
            ComboMCobApp1ChangedEvent(comboMCobApp1: selected),
          );

          setState(() => fieldComboMCobApp1 = selected);
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
                color: sGrey,
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
        ],
      ),
    );
  }

  // Widget buildFieldMcobId() => ReusableComboBox<ComboMCobApp1Model>(
  //   hintText: "Jenis Asuransi",
  //   initItem: fieldComboMCobApp1,
  //   dataLoader: () => ComboMCobApp1Repository().getComboMCobApp1(),
  //   displayText: (item) => item.cobNama,
  //   compareItems: (a, b) => a.mCobApp1Id == b.mCobApp1Id,
  //     onChangedCallback: (value) {
  //             setState(() {
  //               fieldComboMCobApp1 = value;
  //             });
  //           },
  //   onSaveCallback: (value) {
  //     fieldComboMCobApp1 = value;
  //   },
  //   validatorCallback: (value) =>
  //   value == null ? kStringNullError : null,
  // );

  Widget buildFieldRemark() {
    return appTextField(
      label: 'Tambahkan Catatan',
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      controller: fieldRemarkController,
      onChanged: (value) {
        if (value.isNotEmpty) {
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        return null;
      },
    );
  }

  Widget buildFieldTsi() {
    return AppCurrencyField(
      label: "Nilai Pertanggungan",
      currency: fieldComboRMatauang,
      onCurrencyChanged: (v) {
        setState(() => fieldComboRMatauang = v);
      },
      valueController: fieldTsiController,
      validator: (v) {
        if (v == null || v.isEmpty) return kStringNullError;
        return null;
      },
    );
  }

  void _showPengajuanDialog() {
    if (context.read<AuthenticationBloc>().state is AuthenticationAuthenticated) {
      final user =
          (context.read<AuthenticationBloc>().state as AuthenticationAuthenticated)
              .user;

      if (user.userType == "C") {
        final mjenisClient =
            context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;

        if (mjenisClient == "10") {
          final idvState = context.read<MRekanGeneralIdvCrudBloc>().state;

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
        } else if (mjenisClient == "20") {
          final cmpState = context.read<MRekanGeneralCmpCrudBloc>().state;

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
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Pengajuan diproses tim internal.",
                      textAlign: TextAlign.center,
                      style: headingStyle(context, fontSize: 17.49),
                    ),
                    const SizedBox(height: 12),
                    AppButton.primary(
                      text: 'Ajukan Sekarang',
                      backgroundColor: const Color(0xFF0ED7FF),
                      onPressed: () {
                        Navigator.pop(context);
                        _executeSave();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.6),
          builder: (context) => RegisterClientPopUp(
            header: 'Data Klien Belum Terdaftar!',
            description:
            'Untuk melanjutkan ke proses Registrasi, Anda perlu mendaftarkan data klien terlebih dahulu.',
            buttonText: 'Daftar Klien',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterClient(
                    requestFrom: 'regother_page',
                  ),
                ),
              );
            },
          ),
        );
      }
    }
  }

  void _executeSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Regother1CrudModel record = Regother1CrudModel(
        currId: fieldComboRMatauang?.rmatauangKode,
        regother1Id: '',
        comboMCobApp1: fieldComboMCobApp1,
        mcobId: fieldComboMCobApp1!.mCobApp1Id,
        remark: fieldRemarkController.text,
        tsi: double.parse(fieldTsiController.text.replaceAll(',', '')),
      );

      if (widget.viewMode == "tambah") {
        regother1CrudBloc.add(Regother1CrudTambahEvent(record: record));
      } else if (widget.viewMode == "ubah") {
        record.regother1Id = regother1CrudBloc.state.record!.regother1Id;
        regother1CrudBloc.add(Regother1CrudUbahEvent(record: record));
      }
    }
  }

  void onSaveForm() {
    if (fieldComboMCobApp1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          'Silakan pilih Kategori Asuransi sebelum menyimpan.',
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _showPengajuanDialog();
    }
  }
}

class AppCurrencyField extends StatelessWidget {
  final String label;
  final ComboRMatauangModel? currency;
  final Function(ComboRMatauangModel?) onCurrencyChanged;
  final TextEditingController valueController;
  final FormFieldValidator<String>? validator;

  const AppCurrencyField({
    super.key,
    required this.label,
    required this.currency,
    required this.onCurrencyChanged,
    required this.valueController,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: formGrey,
            borderRadius: BorderRadius.circular(cardBorderRadius),
            border: Border.all(color: sGrey),
          ),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.all(5), child: SizedBox(
                width: 100,
                child: ReusableComboBox<ComboRMatauangModel>(
                  hintText: "",
                  initItem: currency,
                  displayText: (m) => m.rmatauangSimbol,
                  compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
                  dataLoader: () =>
                      ComboRMatauangRepository().getComboRMatauang(),
                  enableSearch: false,
                  onChangedCallback: onCurrencyChanged,
                  onSaveCallback: onCurrencyChanged,
                  maxHeight: 200,
                ),
              ),),

              Container(width: 1, height: 30, color: sGrey),

              Expanded(
                child: TextFormField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    ThousandsSeparatorInputFormatter(),
                  ],

                  validator: validator,
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
      ],
    );
  }
}
