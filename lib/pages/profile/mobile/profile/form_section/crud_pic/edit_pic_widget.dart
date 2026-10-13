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
import '../../../../../../blocs/reguser_otp/reguser_otp_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../helper/international_phone_result.dart';
import '../../../../../../helper/navigation_keys.dart';
import '../../../../../../models/combobox/combomjabatan_model.dart';
import '../../../../../../models/gen_profile/mrekanpiccrud_model.dart';
import '../../../../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../../../../../repositories/combobox/combomjabatan_repository.dart';
import '../../../../../../repositories/gen_profile/rekanpiccobcari_repository.dart';
import '../../../../../../widgets/apptheme/dropdown2.dart';
import '../../../../../../widgets/apptheme/phone_number_field.dart';
import '../../../../../base/base_background_sidepage.dart';
import '../../../../../register/mobile/client/widget/register_otp_popup_widget.dart';
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
  String _pendingOpenOtpFor = '';
  String _pendingOtpTarget = '';
  String _lastHandledHpStatusKey = '';
  String _emailOtpError = '';
  String _hpOtpError = '';

  final Map<String, String> _verifiedEmailRequestIds = {};
  final Map<String, String> _verifiedHpRequestIds = {};
  final Set<String> _rejectedHpTargets = {};

  late final MRekanPicCrudBloc crudBloc;
  late final RekanPicCobCariBloc cobBloc;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RegUserOtpBloc>().add(const RegUserOtpClearEvent());
    });
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

  String _emailOtpTarget(String value) {
    final email = value.trim().toLowerCase();
    return emailValidatorRegExp.hasMatch(email) ? email : '';
  }

  String _hpOtpTarget(String value) {
    final result = InternationalPhoneHelper.normalize(
      value,
      countryCode: _hpCountryCode,
    );
    return result.isValid ? result.phone ?? '' : '';
  }

  bool _isEmailChanged() {
    if (!_payloadInjected) return false;
    return _email.text.trim().toLowerCase() !=
        (_initialRecord?.picEmail ?? '').trim().toLowerCase();
  }

  bool _isHpChanged() {
    if (!_payloadInjected) return false;
    return _hpOtpTarget(_hp.text) != (_initialRecord?.picHp ?? '').trim();
  }

  bool _isEmailVerifiedForCurrent(RegUserOtpState state) {
    final target = _emailOtpTarget(_email.text);
    if (target.isEmpty) return false;

    final cachedRequestId = _verifiedEmailRequestIds[target] ?? '';
    if (cachedRequestId.isNotEmpty) return true;

    return state.isEmailVerified &&
        state.activeRequestFrom == 'email' &&
        state.activeTarget.toLowerCase() == target &&
        state.emailRequestId.isNotEmpty;
  }

  bool _isHpVerifiedForCurrent(RegUserOtpState state) {
    final target = _hpOtpTarget(_hp.text);
    if (target.isEmpty || _rejectedHpTargets.contains(target)) return false;

    final cachedRequestId = _verifiedHpRequestIds[target] ?? '';
    if (cachedRequestId.isNotEmpty) return true;

    return state.isHpVerified &&
        !state.isHpStatusChecking &&
        state.hpRegistrationStatus ==
            RegUserHpRegistrationStatus.notRegistered &&
        state.hpStatusTarget == target &&
        state.hpStatusRequestId.isNotEmpty &&
        state.hpRequestId == state.hpStatusRequestId;
  }

  String _emailRequestIdForCurrent(RegUserOtpState state) {
    final target = _emailOtpTarget(_email.text);
    if (target.isEmpty) return '';

    return _verifiedEmailRequestIds[target] ??
        (_isEmailVerifiedForCurrent(state) ? state.emailRequestId : '');
  }

  String _hpRequestIdForCurrent(RegUserOtpState state) {
    final target = _hpOtpTarget(_hp.text);
    if (target.isEmpty) return '';

    return _verifiedHpRequestIds[target] ??
        (_isHpVerifiedForCurrent(state) ? state.hpRequestId : '');
  }

  void _sendEmailOtp() {
    final target = _emailOtpTarget(_email.text);
    if (target.isEmpty) {
      setState(() => _emailOtpError = 'Format email tidak valid');
      _formKey.currentState?.validate();
      return;
    }

    setState(() {
      _emailOtpError = '';
      _pendingOpenOtpFor = 'email';
      _pendingOtpTarget = target;
    });
    context.read<RegUserOtpBloc>().add(
          RegUserOtpKirimEvent(target: target, requestFrom: 'email'),
        );
  }

  void _sendHpOtp() {
    final target = _hpOtpTarget(_hp.text);
    if (target.isEmpty) {
      setState(() => _hpOtpError = 'Nomor HP tidak valid');
      _formKey.currentState?.validate();
      return;
    }

    setState(() {
      _hpOtpError = '';
      _lastHandledHpStatusKey = '';
      _pendingOpenOtpFor = 'hp';
      _pendingOtpTarget = target;
    });
    context.read<RegUserOtpBloc>().add(
          RegUserOtpKirimEvent(target: target, requestFrom: 'hp'),
        );
  }

  void _handleHpRegistrationStatus(
    BuildContext context,
    RegUserOtpState state,
  ) {
    if (!_isHpChanged() ||
        state.isHpStatusChecking ||
        state.hpRegistrationStatus.isEmpty) {
      return;
    }

    final target = state.hpStatusTarget.trim();
    if (target.isEmpty || target != _hpOtpTarget(_hp.text)) return;

    final status = state.hpRegistrationStatus;
    final statusKey = '$target;${state.hpStatusRequestId};$status';
    if (statusKey == _lastHandledHpStatusKey) return;
    _lastHandledHpStatusKey = statusKey;

    if (status == RegUserHpRegistrationStatus.notRegistered) {
      final requestId = state.hpStatusRequestId.trim();
      if (requestId.isEmpty || requestId != state.hpRequestId.trim()) return;

      setState(() {
        _verifiedHpRequestIds[target] = requestId;
        _rejectedHpTargets.remove(target);
        _hpOtpError = '';
      });
      return;
    }

    if (status != RegUserHpRegistrationStatus.registeredLogin &&
        status != RegUserHpRegistrationStatus.registered &&
        status != RegUserHpRegistrationStatus.registeredPic) {
      return;
    }

    final message = status == RegUserHpRegistrationStatus.registeredPic
        ? 'No. HP sudah terdaftar di PIC.'
        : 'No. HP sudah terdaftar.';

    setState(() {
      _verifiedHpRequestIds.remove(target);
      _rejectedHpTargets.add(target);
      _hpOtpError = message;
      _pendingOpenOtpFor = '';
      _pendingOtpTarget = '';
    });
    context.read<RegUserOtpBloc>().add(const RegUserOtpResetHpEvent());
    showRootSnackBar(errorSnackBar(message));
  }

  void _handleOtpStateChanged(BuildContext context, RegUserOtpState state) {
    _handleHpRegistrationStatus(context, state);

    if (_isEmailChanged() &&
        state.isEmailVerified &&
        state.activeRequestFrom == 'email' &&
        state.activeTarget.isNotEmpty &&
        state.emailRequestId.isNotEmpty) {
      final target = state.activeTarget.toLowerCase();
      if (target == _emailOtpTarget(_email.text) &&
          _verifiedEmailRequestIds[target] != state.emailRequestId) {
        setState(() {
          _verifiedEmailRequestIds[target] = state.emailRequestId;
          _emailOtpError = '';
        });
      }
    }

    final hpTarget = _hpOtpTarget(_hp.text);
    final hpStatusFailed = _isHpChanged() &&
        state.hasFailure &&
        state.activeRequestFrom == 'hp' &&
        state.hpStatusRequestId.isNotEmpty &&
        state.hpStatusTarget == hpTarget &&
        !state.isHpSending &&
        !state.isHpValidating;
    if (hpStatusFailed) {
      final failureKey = '${state.hpStatusRequestId};FAIL;${state.message}';
      if (failureKey != _lastHandledHpStatusKey) {
        _lastHandledHpStatusKey = failureKey;
        final message = state.hpError.isNotEmpty
            ? state.hpError
            : 'Gagal memeriksa status No. HP.';
        setState(() {
          _verifiedHpRequestIds.remove(hpTarget);
          _hpOtpError = message;
        });
        showRootSnackBar(errorSnackBar(message));
      }
      return;
    }

    if (_pendingOpenOtpFor.isEmpty ||
        state.activeRequestFrom != _pendingOpenOtpFor ||
        state.activeTarget != _pendingOtpTarget) {
      return;
    }

    final isEmail = _pendingOpenOtpFor == 'email';
    final isSending = isEmail ? state.isEmailSending : state.isHpSending;
    if (isSending) return;

    if (state.hasFailure) {
      final message = isEmail ? state.emailError : state.hpError;
      setState(() {
        if (isEmail) {
          _emailOtpError = message.isNotEmpty ? message : 'Gagal mengirim OTP.';
        } else {
          _hpOtpError = message.isNotEmpty ? message : 'Gagal mengirim OTP.';
        }
        _pendingOpenOtpFor = '';
        _pendingOtpTarget = '';
      });
      showRootSnackBar(
        errorSnackBar(message.isNotEmpty ? message : 'Gagal mengirim OTP.'),
      );
      return;
    }

    final requestId = isEmail ? state.emailRequestId : state.hpRequestId;
    if (requestId.isEmpty) return;

    final target = _pendingOtpTarget;
    final requestFrom = _pendingOpenOtpFor;
    setState(() {
      _pendingOpenOtpFor = '';
      _pendingOtpTarget = '';
    });
    showRegisterOtpPopup(
      context,
      target: target,
      requestFrom: requestFrom,
    );
  }

  bool _validateOtpBeforeSave(RegUserOtpState state) {
    final emailChanged = _isEmailChanged();
    final hpChanged = _isHpChanged();
    final emailVerified = !emailChanged || _isEmailVerifiedForCurrent(state);
    final hpVerified = !hpChanged || _isHpVerifiedForCurrent(state);
    if (emailVerified && hpVerified) return true;

    setState(() {
      _showErrors = true;
      _emailOtpError = emailVerified ? '' : 'Email belum diverifikasi';
      _hpOtpError = hpVerified
          ? ''
          : state.isHpStatusChecking
              ? 'Status No. HP masih diperiksa'
              : 'No. HP belum diverifikasi';
    });
    _formKey.currentState?.validate();
    showRootSnackBar(
      errorSnackBar('Verifikasi kontak yang diubah terlebih dahulu.'),
    );
    return false;
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
    final otpState = context.read<RegUserOtpBloc>().state;
    if (!_validateOtpBeforeSave(otpState)) return;

    final emailChanged = _isEmailChanged();
    final hpChanged = _isHpChanged();

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
      emailReqtokenId: emailChanged ? _emailRequestIdForCurrent(otpState) : '',
      hpReqtokenId: hpChanged ? _hpRequestIdForCurrent(otpState) : '',
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
        BlocListener<RegUserOtpBloc, RegUserOtpState>(
          listener: _handleOtpStateChanged,
        ),
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

                              BlocBuilder<RegUserOtpBloc, RegUserOtpState>(
                                builder: (context, otpState) {
                                  return _isEmailChanged()
                                      ? _buildEmailOtpRow(otpState)
                                      : buildFieldEmail(otpState);
                                },
                              ),
                              const SizedBox(height: vPadding),

                              BlocBuilder<RegUserOtpBloc, RegUserOtpState>(
                                builder: (context, otpState) {
                                  return _isHpChanged()
                                      ? _buildHpOtpRow(otpState)
                                      : buildFiledTelp(otpState);
                                },
                              ),
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

  Widget buildFieldEmail(RegUserOtpState state) {
    final isVerified = _isEmailChanged() && _isEmailVerifiedForCurrent(state);

    return appTextField(
      label: 'Email',
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      helperText: isVerified ? 'Email ini telah diverifikasi' : null,
      helperStyle: bodyTextStyle(context, fontSize: 12).copyWith(
        color: successGreen,
      ),
      borderColor: isVerified ? successGreen : null,
      focusedBorderColor: isVerified ? successGreen : null,
      suffixIcon: isVerified
          ? const Icon(Icons.check, color: successGreen, size: 22)
          : null,
      validator: (v) {
        final email = v?.trim() ?? '';

        if (email.isEmpty) {
          return kEmailNullError;
        }

        if (!emailValidatorRegExp.hasMatch(email)) {
          return 'Format email tidak valid';
        }

        if (_emailOtpError.isNotEmpty) return _emailOtpError;

        return null;
      },
      onChanged: (value) {
        final target = _emailOtpTarget(value);
        final isVerifiedAfterChange =
            target.isNotEmpty && _verifiedEmailRequestIds.containsKey(target);
        setState(() {
          _emailOtpError = '';
          if (!isVerifiedAfterChange) {
            _pendingOpenOtpFor = '';
            _pendingOtpTarget = '';
          }
        });
        if (!isVerifiedAfterChange) {
          context.read<RegUserOtpBloc>().add(const RegUserOtpResetEmailEvent());
        }
      },
    );
  }

  Widget buildFiledTelp(RegUserOtpState state) {
    final isVerified = _isHpChanged() && _isHpVerifiedForCurrent(state);

    return AppPhoneNumberField(
      label: 'No. Telp',
      controller: _hp,
      countryCode: _hpCountryCode,
      helperText: isVerified ? 'No. HP ini telah diverifikasi' : null,
      helperStyle: bodyTextStyle(context, fontSize: 12).copyWith(
        color: successGreen,
      ),
      borderColor: isVerified ? successGreen : null,
      focusedBorderColor: isVerified ? successGreen : null,
      suffixIcon: isVerified
          ? const Icon(Icons.check, color: successGreen, size: 22)
          : null,
      onCountryCodeChanged: (value) {
        setState(() {
          _hpCountryCode = value;
          _hpOtpError = '';
          _lastHandledHpStatusKey = '';
        });
        final target = _hpOtpTarget(_hp.text);
        if (!_verifiedHpRequestIds.containsKey(target)) {
          context.read<RegUserOtpBloc>().add(const RegUserOtpResetHpEvent());
        }
      },
      validator: (v) {
        final telp = v?.trim() ?? '';

        if (telp.isEmpty) {
          return kPhoneNumberNullError;
        }

        final res = InternationalPhoneHelper.normalize(
          telp,
          countryCode: _hpCountryCode,
        );

        if (!res.isValid) {
          return res.error ?? 'Nomor HP tidak valid';
        }

        if (_hpOtpError.isNotEmpty) return _hpOtpError;

        return null;
      },
      onChanged: (value) {
        final target = _hpOtpTarget(value);
        final isVerifiedAfterChange =
            target.isNotEmpty && _verifiedHpRequestIds.containsKey(target);
        setState(() {
          _hpOtpError = _rejectedHpTargets.contains(target)
              ? 'No. HP sudah terdaftar.'
              : '';
          _lastHandledHpStatusKey = '';
          if (!isVerifiedAfterChange) {
            _pendingOpenOtpFor = '';
            _pendingOtpTarget = '';
          }
        });
        if (!isVerifiedAfterChange) {
          context.read<RegUserOtpBloc>().add(const RegUserOtpResetHpEvent());
        }
      },
    );
  }

  Widget _buildEmailOtpRow(RegUserOtpState state) {
    if (_isEmailVerifiedForCurrent(state)) return buildFieldEmail(state);

    return _buildOtpRow(
      field: buildFieldEmail(state),
      isLoading: state.isEmailSending,
      onPressed: _sendEmailOtp,
    );
  }

  Widget _buildHpOtpRow(RegUserOtpState state) {
    if (_isHpVerifiedForCurrent(state)) return buildFiledTelp(state);

    return _buildOtpRow(
      field: buildFiledTelp(state),
      isLoading: state.isHpSending || state.isHpStatusChecking,
      onPressed: _sendHpOtp,
    );
  }

  Widget _buildOtpRow({
    required Widget field,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    Widget buildButton() {
      return AppButton.primary(
        text: 'Kirim OTP',
        isLoading: isLoading,
        backgroundColor: isLoading ? secondaryBlackColor : primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        onPressed: isLoading ? null : onPressed,
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
