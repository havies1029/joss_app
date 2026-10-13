import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/blocs/reguser_otp/reguser_otp_bloc.dart';
import 'package:joss_app/pages/profile/mobile/profile/form_section/rekan_pic_widget.dart';
import 'package:joss_app/pages/register/mobile/client/widget/register_otp_popup_widget.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_success/payment_success.dart';

import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';

import '../../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../helper/international_phone_result.dart';
import '../../../../../../helper/navigation_keys.dart';
import '../../../../../../models/combobox/combomjabatan_model.dart';
import '../../../../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../../../../../repositories/combobox/combomjabatan_repository.dart';
import '../../../../../../repositories/gen_profile/rekanpiccobcari_repository.dart';
import '../../../../../../widgets/apptheme/dropdown2.dart';
import '../../../../../../widgets/apptheme/phone_number_field.dart';
import '../../../../../base/base_background_sidepage.dart';
import 'list_pic_widget.dart';

class TambahPicWidget extends StatefulWidget {
  const TambahPicWidget({super.key});

  @override
  State<TambahPicWidget> createState() => _TambahPicWidgetState();
}

class _TambahPicWidgetState extends State<TambahPicWidget> {
  late final MRekanPicCrudBloc crudBloc;
  late final RekanPicCobCariBloc cobBloc;

  final List<String> errors = [];

  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _hp = TextEditingController();
  final _jabatanDesc = TextEditingController();
  final _alamat1 = TextEditingController();

  final bool _isDefault = false;
  bool _saving = false;
  bool _showErrors = false;
  String _pendingOpenOtpFor = '';
  String _pendingOtpTarget = '';
  String _lastHandledHpStatusKey = '';
  String _emailOtpError = '';
  String _hpOtpError = '';

  final Map<String, String> _verifiedEmailRequestIds = {};
  final Map<String, String> _verifiedHpRequestIds = {};
  final Set<String> _rejectedHpTargets = {};

  final _comboKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();
  ComboMJabatanModel? _jabatan;
  int _hpCountryCode = InternationalPhoneHelper.defaultCountryCode;

  @override
  void initState() {
    super.initState();
    crudBloc = context.read<MRekanPicCrudBloc>();
    cobBloc = context.read<RekanPicCobCariBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RegUserOtpBloc>().add(const RegUserOtpClearEvent());
    });
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _hp.dispose();
    _jabatanDesc.dispose();
    _alamat1.dispose();
    super.dispose();
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
    if (state.isHpStatusChecking || state.hpRegistrationStatus.isEmpty) return;

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

    if (state.isEmailVerified &&
        state.activeRequestFrom == 'email' &&
        state.activeTarget.isNotEmpty &&
        state.emailRequestId.isNotEmpty) {
      final target = state.activeTarget.toLowerCase();
      if (_verifiedEmailRequestIds[target] != state.emailRequestId) {
        setState(() {
          _verifiedEmailRequestIds[target] = state.emailRequestId;
          _emailOtpError = '';
        });
      }
    }

    final hpTarget = _hpOtpTarget(_hp.text);
    final hpStatusFailed = state.hasFailure &&
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

    if (_pendingOpenOtpFor.isEmpty) return;
    if (state.activeRequestFrom != _pendingOpenOtpFor ||
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
    final emailVerified = _isEmailVerifiedForCurrent(state);
    final hpVerified = _isHpVerifiedForCurrent(state);
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
      errorSnackBar('Verifikasi email dan nomor HP terlebih dahulu.'),
    );
    return false;
  }

  void _save() {
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

    final phoneRes = InternationalPhoneHelper.normalize(
      _hp.text.trim(),
      countryCode: _hpCountryCode,
    );
    final hpNormalized = phoneRes.phone ?? "";

    final otpState = context.read<RegUserOtpBloc>().state;
    if (!_validateOtpBeforeSave(otpState)) return;

    final mjnsclientId = context.read<RegUserBloc>().state.record?.jnsClientId;

    final jabatanDesc = (mjnsclientId == '10') ? '' : _jabatanDesc.text.trim();

    final record = MRekanPicCrudModel(
      picNama: _nama.text.trim(),
      picEmail: _email.text.trim().toLowerCase(),
      picHp: hpNormalized,
      jabatanDesc: jabatanDesc,
      mjabatanId: _jabatan?.mjabatanId,
      alamat1: _alamat1.text.trim(),
      alamat2: "",
      isDefault: _isDefault,
      emailReqtokenId: _emailRequestIdForCurrent(otpState),
      hpReqtokenId: _hpRequestIdForCurrent(otpState),
    );

    context.read<MRekanPicCrudBloc>().add(
          MRekanPicCrudTambahEvent(record: record),
        );
  }

  Future<void> _openCobPicker() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cobBloc,
          child: const ListPicWidget(
            mrekanpicId: '0',
          ),
        ),
      ),
    );
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
          listener: (context, state) async {
            if (state.isSaving) {
              setState(() {
                _saving = true;
              });
              return;
            }

            if (state.hasFailure) {
              setState(() {
                _saving = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(
                  state.message?.isNotEmpty == true
                      ? state.message!
                      : 'Gagal menyimpan data PIC.',
                ),
              );
              return;
            }

            if (state.isSaved == true) {
              try {
                final picId = (state.savedId ?? '').trim();
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

                if (cobResult.success) {
                  setState(() {
                    _saving = false;
                  });

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PaymentSuccess(
                        display: 'PIC Berhasil Ditambahkan',
                        description:
                            'PIC telah berhasil dibuat dan dapat digunakan sesuai hak akses yang diberikan.',
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
                  setState(() {
                    _saving = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar('PIC tersimpan, tapi gagal update COB.'));
                }
              } catch (e) {
                if (!context.mounted) return;

                setState(() {
                  _saving = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(
                    'PIC tersimpan, tapi terjadi error saat update COB.'));
              }
            }
          },
        ),
      ],
      child: BaseBackgroundSidePage(
        title: 'Tambah PIC',
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
                                'Form Tambah PIC',
                                style: headingStyle(context, fontSize: 20),
                              ),
                              const SizedBox(height: vPadding),

                              buildFieldRekanNama(),
                              const SizedBox(height: vPadding),

                              buildFieldAlamat1(),
                              const SizedBox(height: vPadding),

                              BlocBuilder<RegUserOtpBloc, RegUserOtpState>(
                                builder: (context, otpState) {
                                  return Column(
                                    children: [
                                      _buildEmailOtpRow(otpState),
                                      const SizedBox(height: vPadding),
                                      _buildHpOtpRow(otpState),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: vPadding),

                              if (mjnsclientId != '10') buildFieldjabatanDesc(),
                              const SizedBox(height: vPadding),

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
                              // const SizedBox(height: hPadding),

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

                              const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                child: AppButton.primary(
                                  text: 'Simpan',
                                  isLoading: _saving,
                                  backgroundColor: _saving
                                      ? secondaryBlackColor
                                      : primaryColor,
                                  onPressed: _saving ? null : _save,
                                ),
                              ),
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

  Widget buildFieldEmail(RegUserOtpState state) {
    final isVerified = _isEmailVerifiedForCurrent(state);

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
        final email = v?.trim() ?? "";

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
    final isVerified = _isHpVerifiedForCurrent(state);

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
        final telp = v?.trim() ?? "";

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

  Widget buildFieldjabatanDesc() {
    return appTextField(
      label: 'Jabatan',
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[!@#$%^&*]')),
      ],
      controller: _jabatanDesc,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Jabatan wajib diisi';
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

  Widget buildFieldAlamat1() {
    return appTextField(
      label: 'Alamat',
      controller: _alamat1,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Alamat wajib diisi';
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
