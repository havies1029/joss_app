import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/pages/profile/mobile/profile/form_section/rekan_pic_widget.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_success/payment_success.dart';
import 'package:joss_app/common/loading_indicator.dart';
import '../../../../../../blocs/gen_profile/mrekanpic_contact_change_bloc.dart';
import '../../../../../../blocs/gen_profile/mrekanpiccrud_bloc.dart';
import '../../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../../blocs/hakakses/hakaksescrud_bloc.dart';
import '../../../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../helper/international_phone_result.dart';
import '../../../../../../models/combobox/combomjabatan_model.dart';
import '../../../../../../models/gen_profile/mrekanpic_contact_change_model.dart';
import '../../../../../../models/gen_profile/mrekanpiccrud_model.dart';
import '../../../../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../../../../../repositories/combobox/combomjabatan_repository.dart';
import '../../../../../../repositories/gen_profile/rekanpiccobcari_repository.dart';
import '../../../../../../widgets/apptheme/dropdown2.dart';
import '../../../../../../widgets/apptheme/phone_number_field.dart';
import '../../../../../base/base_background_sidepage.dart';
import 'list_pic_widget.dart';
import 'mrekanpic_contact_change_otp_popup_widget.dart';
import 'mrekanpic_contact_change_page.dart';

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
  String _emailChangeRequestId = '';
  String _hpChangeRequestId = '';

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
  late final MRekanPicContactChangeBloc contactChangeBloc;
  late HakaksesCrudBloc hakaksesCrudBloc;

  final _comboKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();
  ComboMJabatanModel? _jabatan;
  int _hpCountryCode = InternationalPhoneHelper.defaultCountryCode;

  @override
  void initState() {
    super.initState();
    cobBloc = context.read<RekanPicCobCariBloc>();
    crudBloc = context.read<MRekanPicCrudBloc>();
    hakaksesCrudBloc = context.read<HakaksesCrudBloc>();
    contactChangeBloc = MRekanPicContactChangeBloc();
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
    contactChangeBloc.close();
    super.dispose();
  }

  String _toPhoneFieldValue(String raw) {
    return InternationalPhoneHelper.toNationalInput(
      raw,
      countryCode: _hpCountryCode,
    );
  }

  String _toNormalizedPhone62(String raw) {
    final res = InternationalPhoneHelper.normalize(
      raw.trim(),
      countryCode: _hpCountryCode,
    );
    return res.phone ?? '';
  }

  void _setHpCountryFromRaw(String raw) {
    final digits = InternationalPhoneHelper.clean(raw);
    final detected = InternationalPhoneHelper.detectCountry(digits);
    _hpCountryCode =
        detected?.dialCode ?? InternationalPhoneHelper.defaultCountryCode;
  }

  String _normalizeStoredPhone(String raw) {
    final result = InternationalPhoneHelper.normalize(
      raw,
      countryCode: InternationalPhoneHelper.defaultCountryCode,
    );
    return result.phone ?? '';
  }

  String _maskEmail(String value) {
    final parts = value.trim().split('@');
    if (parts.length != 2 || parts.first.isEmpty) return value;
    return '${parts.first.substring(0, 1)}***@${parts.last}';
  }

  String _maskPhone(String value) {
    final phone = _normalizeStoredPhone(value);
    if (phone.length <= 6) return phone;
    return '${phone.substring(0, 2)}******${phone.substring(phone.length - 4)}';
  }

  Future<int?> _chooseVerificationChannel() {
    final email = (_initialRecord?.picEmail ?? '').trim().toLowerCase();
    final phone = _normalizeStoredPhone(_initialRecord?.picHp ?? '');
    final hasEmail = emailValidatorRegExp.hasMatch(email);
    final hasPhone = phone.isNotEmpty;

    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: formGrey,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(cardBorderRadius),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: sGrey,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Pilih Tujuan OTP',
                style: headingStyle(sheetContext, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Verifikasi perubahan melalui kontak PIC yang saat ini aktif.',
                style: bodyTextStyle(sheetContext, fontSize: 14).copyWith(
                  color: hintGrey,
                ),
              ),
              const SizedBox(height: 16),
              if (hasEmail)
                _buildVerificationOption(
                  context: sheetContext,
                  icon: Icons.email_outlined,
                  title: 'Email',
                  value: _maskEmail(email),
                  onTap: () => Navigator.pop(
                    sheetContext,
                    MRekanPicContactVerifyVia.email,
                  ),
                ),
              if (hasEmail && hasPhone) const SizedBox(height: 10),
              if (hasPhone)
                _buildVerificationOption(
                  context: sheetContext,
                  icon: Icons.phone_android_outlined,
                  title: 'No. HP',
                  value: _maskPhone(phone),
                  onTap: () => Navigator.pop(
                    sheetContext,
                    MRekanPicContactVerifyVia.phone,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: pGrey,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: bodyTextStyle(context)),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: bodyTextStyle(context, fontSize: 13).copyWith(
                        color: hintGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: hintGrey),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startContactChange(int changeTypeId) async {
    if (!_payloadInjected || _initialRecord == null) return;

    final currentValue = changeTypeId == MRekanPicContactChangeType.email
        ? (_initialRecord!.picEmail ?? '').trim().toLowerCase()
        : _normalizeStoredPhone(_initialRecord!.picHp ?? '');
    if (currentValue.isEmpty) {
      final label = changeTypeId == MRekanPicContactChangeType.email
          ? 'Email lama'
          : 'No. HP lama';
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar('$label belum tersedia.'),
      );
      return;
    }

    final verifyViaId = await _chooseVerificationChannel();
    if (!mounted || verifyViaId == null) return;

    final verified = await showMRekanPicContactChangeOtpPopup(
      context,
      bloc: contactChangeBloc,
      mrekanpicId: widget.mrekanpicId,
      changeTypeId: changeTypeId,
      verifyViaId: verifyViaId,
    );
    if (!mounted || verified != true) return;

    final prepared =
        await Navigator.of(context).push<MRekanPicPreparedContactChange>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: contactChangeBloc,
          child: MRekanPicContactChangePage(
            changeTypeId: changeTypeId,
            currentValue: currentValue,
          ),
        ),
      ),
    );
    if (!mounted ||
        prepared == null ||
        prepared.changeRequestId.trim().isEmpty ||
        prepared.newValue.trim().isEmpty) {
      return;
    }

    setState(() {
      if (changeTypeId == MRekanPicContactChangeType.email) {
        final email = prepared.newValue.trim().toLowerCase();
        _email.text = email;
        _emailChangeRequestId = prepared.changeRequestId.trim();
      } else {
        final phone = _normalizeStoredPhone(prepared.newValue);
        _hpCountryCode = InternationalPhoneHelper.defaultCountryCode;
        _hp.text = InternationalPhoneHelper.toNationalInput(phone);
        _hpChangeRequestId = prepared.changeRequestId.trim();
      }
    });

    final message = changeTypeId == MRekanPicContactChangeType.email
        ? 'Email baru siap disimpan. Tekan Simpan untuk menerapkan perubahan.'
        : 'No. HP baru siap disimpan. Tekan Simpan untuk menerapkan perubahan.';
    ScaffoldMessenger.of(context).showSnackBar(successSnackBar(message));
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
      emailReqtokenId: '',
      hpReqtokenId: '',
      emailChangeRequestId: _emailChangeRequestId,
      hpChangeRequestId: _hpChangeRequestId,
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
    _setHpCountryFromRaw((record.picHp ?? '').trim());
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

    return MultiBlocListener(
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
                picEmail: (state.record!.picEmail ?? '').trim().toLowerCase(),
                picHp: _toNormalizedPhone62((state.record!.picHp ?? '').trim()),
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
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                        borderRadius: BorderRadius.circular(cardBorderRadius),
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

                              buildFieldTelp(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade800,
                                        borderRadius: BorderRadius.circular(10),
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
                                            style:
                                                bodyTextStyle(context).copyWith(
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
                                                          ListStatus.initial &&
                                                      cobState.items.isEmpty &&
                                                      cobState.selectedItems
                                                          .isEmpty;

                                              if (cobState
                                                  .selectedItems.isEmpty) {
                                                return const Text(
                                                  'Pilih Daftar COB',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
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
                                                children: cobState.selectedItems
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
                                                          color: const Color(
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
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                      backgroundColor: sGrey.withOpacity(0.25),
                                      textColor: primaryLightColor,
                                      onPressed: _saving
                                          ? null
                                          : () => Navigator.pop(context, false),
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
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[!@#$%^&*]')),
      ],
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
    return ReusableComboBoxV2<ComboMJabatanModel>(
      hintText: "Peran",
      comboKey: _comboKey,
      initItem: _jabatan,
      loader: (q) => ComboMJabatanRepository().getComboMJabatan(),
      clientSideSearch: true,
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
    return _buildContactFieldRow(
      field: appTextField(
        label: 'Email',
        controller: _email,
        enabled: false,
      ),
      buttonText: 'Ubah Email',
      enabled: _payloadInjected && _email.text.trim().isNotEmpty,
      onPressed: () => _startContactChange(
        MRekanPicContactChangeType.email,
      ),
    );
  }

  Widget buildFieldTelp() {
    return _buildContactFieldRow(
      field: AppPhoneNumberField(
        label: 'No. Telp',
        controller: _hp,
        countryCode: _hpCountryCode,
        enabled: false,
        onCountryCodeChanged: (_) {},
      ),
      buttonText: 'Ubah No. HP',
      enabled: _payloadInjected && _hp.text.trim().isNotEmpty,
      onPressed: () => _startContactChange(
        MRekanPicContactChangeType.phone,
      ),
    );
  }

  Widget _buildContactFieldRow({
    required Widget field,
    required String buttonText,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    Widget buildButton() {
      return AppButton.primary(
        text: buttonText,
        backgroundColor: enabled ? primaryColor : secondaryBlackColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        onPressed: enabled ? onPressed : null,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 340) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              field,
              const SizedBox(height: 8),
              buildButton(),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 7, child: field),
            const SizedBox(width: 8),
            Expanded(flex: 3, child: buildButton()),
          ],
        );
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
