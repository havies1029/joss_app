import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/pages/profile/mobile/profile/form_section/rekan_pic_widget.dart';
import 'package:joss_app/pages/tagihan_pembayaran/mobile/payment_page/payment_success/payment_success.dart';

import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';

import '../../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../helper/international_phone_result.dart';
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

  final _comboKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();
  ComboMJabatanModel? _jabatan;
  int _hpCountryCode = InternationalPhoneHelper.defaultCountryCode;

  @override
  void initState() {
    super.initState();
    crudBloc = context.read<MRekanPicCrudBloc>();
    cobBloc = context.read<RekanPicCobCariBloc>();
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

    return BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
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

                              buildFieldEmail(),
                              const SizedBox(height: vPadding),

                              buildFiledTelp(),
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

  Widget buildFieldEmail() {
    return appTextField(
      label: 'Email',
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      validator: (v) {
        final email = v?.trim() ?? "";

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
    return AppPhoneNumberField(
      label: 'No. Telp',
      controller: _hp,
      countryCode: _hpCountryCode,
      onCountryCodeChanged: (value) {
        setState(() {
          _hpCountryCode = value;
        });
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
