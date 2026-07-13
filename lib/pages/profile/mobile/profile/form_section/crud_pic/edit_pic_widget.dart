import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/pages/profile/mobile/profile/form_section/rekan_pic_widget.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_success/payment_success.dart';
import 'package:joss_app/common/loading_indicator.dart';
import '../../../../../../blocs/gen_profile/mrekanpiccrud_bloc.dart';
import '../../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../../blocs/hakakses/hakaksescrud_bloc.dart';
import '../../../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../helper/indo_phone_result.dart';
import '../../../../../../models/combobox/combomjabatan_model.dart';
import '../../../../../../models/gen_profile/mrekanpiccrud_model.dart';
import '../../../../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../../../../../repositories/combobox/combomjabatan_repository.dart';
import '../../../../../../repositories/gen_profile/rekanpiccobcari_repository.dart';
import '../../../../../base/base_background_sidepage.dart';
import 'list_pic_widget.dart';

class EditPicWidget extends StatefulWidget {
  final String mrekanpicId;

  const EditPicWidget({
    super.key,
    required this.mrekanpicId,
  });

  @override
  State<EditPicWidget> createState() => _EditPicWidgetState();
}

class _EditPicWidgetState extends State<EditPicWidget> {
  bool _saving = false;

  MRekanPicCrudModel? _initialRecord;
  bool _payloadInjected = false;

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  final _id = TextEditingController();
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _hp = TextEditingController();
  final _jabatanDesc = TextEditingController();
  final _alamat = TextEditingController();

  bool _isDefault = false;
  bool _showErrors = false;

  late final MRekanPicCrudBloc crudBloc;
  late final RekanPicCobCariBloc cobBloc;
  late HakaksesCrudBloc hakaksesCrudBloc;

  final _comboKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();
  ComboMJabatanModel? _jabatan;

  @override
  void initState() {
    super.initState();
    cobBloc = context.read<RekanPicCobCariBloc>();
    crudBloc = context.read<MRekanPicCrudBloc>();
    hakaksesCrudBloc = context.read<HakaksesCrudBloc>();
    Future.delayed(const Duration(milliseconds: 300), () {
      loadData();
    });
  }

  void loadData() {
    cobBloc.add(
      RefreshRekanPicCobCariEvent(
        rekanPicId: widget.mrekanpicId,
        searchText: '',
      ),
    );

    crudBloc.add(
      MRekanPicCrudLihatEvent(recordId: widget.mrekanpicId),
    );
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _hp.dispose();
    _jabatanDesc.dispose();
    _alamat.dispose();
    super.dispose();
  }

  String _toPhoneFieldValue(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) return '';

    if (digits.startsWith('62')) {
      return digits.substring(2);
    }

    if (digits.startsWith('0')) {
      return digits.substring(1);
    }

    return digits;
  }

  String _toNormalizedPhone62(String raw) {
    final res = IndoPhoneHelper.normalize(raw.trim());
    return res.phone62 ?? '';
  }

  Future<void> _openCobPicker() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cobBloc,
          child: ListPicWidget(
            mrekanpicId: widget.mrekanpicId,
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      if (!_showErrors) {
        setState(() => _showErrors = true);
      }
      return;
    }

    _formKey.currentState?.save();

    final selectedCobItems = cobBloc.state.selectedItems;
    if (selectedCobItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          infoSnackBar('Silakan pilih minimal 1 COB sebelum menyimpan.'));
      return;
    }

    final mjnsclientId = context.read<RegUserBloc>().state.record?.jnsClientId;

    final jabatanDesc = (mjnsclientId == '10') ? '' : _jabatanDesc.text.trim();

    final hpNormalized = _toNormalizedPhone62(_hp.text.trim());
    final mjabatanId =
        (_jabatan?.mjabatanId ?? _initialRecord?.mjabatanId ?? '').trim();

    final record = MRekanPicCrudModel(
      mrekanpicId: widget.mrekanpicId,
      picNama: _nama.text.trim(),
      picEmail: _email.text.trim().toLowerCase(),
      picHp: hpNormalized,
      jabatanDesc: jabatanDesc,
      mjabatanId: mjabatanId,
      alamat1: _alamat.text.trim(),
      alamat2: '',
      isDefault: _isDefault,
    );

    if (_initialRecord != null && _isSameRecord(_initialRecord!, record)) {
      final picId = widget.mrekanpicId.trim();
      final cobRepo = RekanPicCobCariRepository();

      final listCheckbox = selectedCobItems
          .map(
            (e) => RekanPicCobCariCheckboxModel(
              mcobId: e.mcobId,
              isChecked: e.isChecked,
            ),
          )
          .toList();

      final cobResult = await cobRepo.rekanPicCobUpdateList(
        picId,
        listCheckbox,
      );

      if (!mounted) return;

      setState(() => _saving = false);

      if (cobResult.success) {
        hakaksesCrudBloc.add(HakaksesCrudLihatEvent());
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PaymentSuccess(
              display: 'PIC Berhasil Diperbarui',
              description:
                  'PIC telah berhasil diperbarui dan dapat digunakan sesuai hak akses yang diberikan.',
              displayButton: 'Kembali',
              onButtonPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const RekanPicWidgetPage(),
                  ),
                  (route) => route.isFirst,
                );
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            errorSnackBar('PIC tersimpan, tapi gagal update COB.'));
      }
      return;
    }

    setState(() => _saving = true);
    crudBloc.add(MRekanPicCrudUbahEvent(record: record));
  }

  void _injectPayload(MRekanPicCrudModel record) {
    _id.text = (record.mrekanpicId ?? '').trim();
    _nama.text = (record.picNama ?? '').trim();
    _email.text = (record.picEmail ?? '').trim();
    _hp.text = _toPhoneFieldValue((record.picHp ?? '').trim());
    _jabatanDesc.text = (record.jabatanDesc ?? '').trim();
    _alamat.text = (record.alamat1 ?? '').trim();
    _isDefault = record.isDefault ?? false;
    _jabatan = record.comboMJabatan;
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _comboKey.currentState?.changeSelectedItem(_jabatan);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: secondaryBlackColor,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
              listenWhen: (prev, curr) {
                return prev.isSaving != curr.isSaving ||
                    prev.isSaved != curr.isSaved ||
                    prev.hasFailure != curr.hasFailure ||
                    prev.isLoaded != curr.isLoaded ||
                    prev.record != curr.record;
              },
              listener: (context, state) async {
                // ===== LOAD DATA EFFECT =====
                if (!_payloadInjected &&
                    state.isLoaded == true &&
                    state.record != null &&
                    !_saving) {
                  _injectPayload(state.record!);

                  _initialRecord = MRekanPicCrudModel(
                    mrekanpicId: (state.record!.mrekanpicId ?? '').trim(),
                    picNama: (state.record!.picNama ?? '').trim(),
                    picEmail:
                        (state.record!.picEmail ?? '').trim().toLowerCase(),
                    picHp: _toNormalizedPhone62(
                        (state.record!.picHp ?? '').trim()),
                    jabatanDesc: (state.record!.jabatanDesc ?? '').trim(),
                    mjabatanId: (state.record!.mjabatanId ?? ''),
                    alamat1: (state.record!.alamat1 ?? '').trim(),
                    alamat2: (state.record!.alamat2 ?? '').trim(),
                    isDefault: state.record!.isDefault ?? false,
                  );

                  _payloadInjected = true;
                  return;
                }

                // ===== SAVE START EFFECT =====
                if (state.isSaving == true) {
                  if (!_saving) {
                    setState(() => _saving = true);
                  }
                  return;
                }

                // Jangan proses saved/failure kalau bukan dari tombol simpan widget ini
                if (!_saving) return;

                // ===== SAVE SUCCESS EFFECT =====
                if (state.isSaved == true) {
                  try {
                    final picId = widget.mrekanpicId.trim();
                    final cobRepo = RekanPicCobCariRepository();

                    final selectedCobItems =
                        context.read<RekanPicCobCariBloc>().state.selectedItems;

                    final listCheckbox = selectedCobItems
                        .map(
                          (e) => RekanPicCobCariCheckboxModel(
                            mcobId: e.mcobId,
                            isChecked: e.isChecked,
                          ),
                        )
                        .toList();

                    final cobResult = await cobRepo.rekanPicCobUpdateList(
                      picId,
                      listCheckbox,
                    );

                    if (!context.mounted) return;

                    setState(() => _saving = false);

                    if (cobResult.success) {
                      hakaksesCrudBloc.add(HakaksesCrudLihatEvent());

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentSuccess(
                            display: 'PIC Berhasil Diperbarui',
                            description:
                                'PIC telah berhasil diperbarui dan dapat digunakan sesuai hak akses yang diberikan.',
                            displayButton: 'Kembali',
                            onButtonPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const RekanPicWidgetPage(),
                                ),
                                (route) => route.isFirst,
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        errorSnackBar('PIC tersimpan, tapi gagal update COB.'),
                      );
                    }
                  } catch (e) {
                    if (!context.mounted) return;

                    setState(() => _saving = false);

                    ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar(
                          'PIC tersimpan, tapi terjadi error saat update COB.'),
                    );
                  }

                  return;
                }

                // ===== SAVE FAILURE EFFECT =====
                if (state.hasFailure == true) {
                  setState(() => _saving = false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    errorSnackBar(
                      (state.message ?? '').trim().isNotEmpty
                          ? state.message!
                          : 'Gagal menyimpan perubahan. Coba lagi.',
                    ),
                  );

                  return;
                }
              },
            ),
          ],
          child: BaseBackgroundSidePage(
            title: 'Edit PIC',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final mjnsclientId = context.select(
                  (RegUserBloc b) => b.state.record?.jnsClientId,
                );

                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Container(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    color: secondaryBlackColor,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: hPadding * 1.5,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Di sini Anda dapat mengelola dan menambahkan PIC yang akan diundang melalui email untuk setiap asuransi Anda.",
                          style: bodyTextStyle(
                            context,
                            fontSize: getResponsiveFont(context, 16),
                          ).copyWith(color: primaryLightColor),
                        ),
                        SizedBox(height: hPadding),
                        Card(
                          color: pGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(cardBorderRadius),
                            side: const BorderSide(color: sGrey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: _formKey,
                              autovalidateMode: _showErrors
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Form Edit PIC',
                                    style: headingStyle(context, fontSize: 20),
                                  ),
                                  const SizedBox(height: vPadding),

                                  buildFieldRekanNama(),
                                  const SizedBox(height: vPadding),

                                  buildFieldAlamat(),
                                  const SizedBox(height: vPadding),

                                  buildFieldEmail(),
                                  const SizedBox(height: vPadding),

                                  buildFiledTelp(),
                                  const SizedBox(height: vPadding),

                                  if (mjnsclientId != '10') ...[
                                    buildFieldjabatanDesc(),
                                    const SizedBox(height: vPadding),
                                  ],

                                  buildFieldJabatan(),
                                  const SizedBox(height: vPadding),

                                  // CheckboxListTile(
                                  //   value: _isDefault,
                                  //   onChanged: (v) => setState(
                                  //         () => _isDefault = v ?? false,
                                  //   ),
                                  //   title: Text(
                                  //     'Jadikan sebagai PIC default',
                                  //     style: bodyTextStyle(context),
                                  //   ),
                                  //   dense: true,
                                  //   activeColor: primaryColor,
                                  //   controlAffinity:
                                  //   ListTileControlAffinity.leading,
                                  //   contentPadding: EdgeInsets.zero,
                                  // ),
                                  //
                                  // const SizedBox(height: vPadding),

                                  GestureDetector(
                                    onTap: _openCobPicker,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade800,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/list_cob_icon.svg',
                                            width: 20,
                                            height: 20,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'COB yang bisa diakses:',
                                                style: bodyTextStyle(context)
                                                    .copyWith(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              BlocBuilder<RekanPicCobCariBloc,
                                                  RekanPicCobCariState>(
                                                builder: (context, cobState) {
                                                  final isInitialLoading =
                                                      cobState.status ==
                                                              ListStatus
                                                                  .initial &&
                                                          cobState
                                                              .items.isEmpty &&
                                                          cobState.selectedItems
                                                              .isEmpty;

                                                  if (cobState
                                                      .selectedItems.isEmpty) {
                                                    return const Text(
                                                      'Pilih Daftar COB',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                      ),
                                                    );
                                                  }

                                                  if (isInitialLoading) {
                                                    return const Center(
                                                      child: LoadingIndicator(),
                                                    );
                                                  }

                                                  return Wrap(
                                                    spacing: 6,
                                                    runSpacing: 6,
                                                    children: cobState
                                                        .selectedItems
                                                        .map(
                                                          (e) => Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 10,
                                                              vertical: 6,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  const Color(
                                                                0xFFFF9D00,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                8,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              e.cobNama,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: vPadding),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppButton.primary(
                                          text: "Batal",
                                          backgroundColor:
                                              sGrey.withOpacity(0.25),
                                          textColor: primaryLightColor,
                                          onPressed: _saving
                                              ? null
                                              : () =>
                                                  Navigator.pop(context, false),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: AppButton.primary(
                                          text: "Simpan",
                                          isLoading: _saving,
                                          backgroundColor: _saving
                                              ? secondaryBlackColor
                                              : primaryColor,
                                          onPressed: _saving ? null : _save,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameRecord(MRekanPicCrudModel a, MRekanPicCrudModel b) {
    return (a.mrekanpicId ?? '').trim() == (b.mrekanpicId ?? '').trim() &&
        (a.picNama ?? '').trim() == (b.picNama ?? '').trim() &&
        (a.picEmail ?? '').trim().toLowerCase() ==
            (b.picEmail ?? '').trim().toLowerCase() &&
        (a.picHp ?? '').trim() == (b.picHp ?? '').trim() &&
        (a.jabatanDesc ?? '').trim() == (b.jabatanDesc ?? '').trim() &&
        (a.mjabatanId ?? '').trim() == (b.mjabatanId ?? '').trim() &&
        (a.alamat1 ?? '').trim() == (b.alamat1 ?? '').trim() &&
        (a.isDefault ?? false) == (b.isDefault ?? false);
  }

  // Widget buildFieldRekanPicId() {
  //   return appTextField(
  //     label: 'E PIC',
  //     controller: _nama,
  //     keyboardType: TextInputType.text,
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return kNameNullError;
  //       }
  //       return null;
  //     },
  //   );
  // }

  Widget buildFieldRekanNama() {
    return appTextField(
      label: 'Nama PIC',
      controller: _nama,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kNameNullError;
        }
        return null;
      },
    );
  }

  Widget buildFieldjabatanDesc() {
    return appTextField(
      label: 'Jabatan',
      controller: _jabatanDesc,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Jabatan wajib diisi";
        }
        return null;
      },
    );
  }

  Widget buildFieldJabatan() {
    return ReusableComboBox<ComboMJabatanModel>(
      hintText: "Peran",
      comboKey: _comboKey,
      initItem: _jabatan,
      dataLoader: () => ComboMJabatanRepository().getComboMJabatan(),
      displayText: (i) => i.jabatanDesc,
      compareItems: (a, b) => a.mjabatanId == b.mjabatanId,
      onChangedCallback: (value) {
        setState(() {
          _jabatan = value;
        });

        if (value != null) {
          removeError(error: kStringNullError);
          crudBloc.add(ComboMJabatanChangedEvent(comboMJabatan: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          _jabatan = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          return "Peran wajib diisi";
        }
        return null;
      },
    );
  }

  Widget buildFieldAlamat() {
    return appTextField(
      label: 'Alamat',
      controller: _alamat,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Alamat wajib diisi";
        }
        return null;
      },
    );
  }

  Widget buildFieldEmail() {
    return appTextField(
      label: 'Email',
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      validator: (v) {
        final email = v?.trim() ?? '';

        if (email.isEmpty) {
          return kEmailNullError;
        }

        if (!emailValidatorRegExp.hasMatch(email)) {
          return 'Format email tidak valid';
        }

        return null;
      },
    );
  }

  Widget buildFiledTelp() {
    return appTextField(
      label: 'No. Telp',
      controller: _hp,
      keyboardType: TextInputType.phone,
      prefix: Text(
        '+62 | ',
        style: inputTextStyle(context, color: primaryLightColor),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
      ],
      validator: (v) {
        final telp = v?.trim() ?? '';

        if (telp.isEmpty) {
          return kPhoneNumberNullError;
        }

        final res = IndoPhoneHelper.normalize(telp);

        if (!res.isValid) {
          return res.error ?? 'Nomor HP tidak valid';
        }

        return null;
      },
    );
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}
