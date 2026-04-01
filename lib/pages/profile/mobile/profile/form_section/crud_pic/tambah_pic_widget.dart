import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';
import 'package:joss_app/repositories/combobox/combomjabatan_repository.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';

import '../../../../../../blocs/gen_profile/mrekanpiclist_bloc.dart';
import '../../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../helper/indo_phone_result.dart';
import '../../../../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../../../../../repositories/gen_profile/rekanpiccobcari_repository.dart';
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
  final _jabatanNama = TextEditingController();
  final _alamat1 = TextEditingController();

  bool _isDefault = false;
  bool _saving = false;
  bool _showErrors = false;
  late MRekanPicListBloc listBloc;

  @override
  void initState() {
    super.initState();
    listBloc = context.read<MRekanPicListBloc>();
    crudBloc = context.read<MRekanPicCrudBloc>();
    cobBloc = context.read<RekanPicCobCariBloc>();
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _hp.dispose();
    _jabatanNama.dispose();
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
        const SnackBar(
          content: Text('Silakan pilih minimal 1 COB sebelum menyimpan.'),
        ),
      );
      return;
    }

    final phoneRes = IndoPhoneHelper.normalize(_hp.text.trim());
    final hpNormalized = phoneRes.phone62 ?? "";

    final mjnsclientId = context.read<RegUserBloc>().state.record?.jnsClientId;

    final jabatanNama = (mjnsclientId == '10')
        ? ''
        : _jabatanNama.text.trim();

    final record = MRekanPicCrudModel(
      picNama: _nama.text.trim(),
      picEmail: _email.text.trim().toLowerCase(),
      picHp: hpNormalized,
      jabatanNama: jabatanNama,
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
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
                SnackBar(
                  content: Text(
                    (state.message ?? '').trim().isNotEmpty
                        ? state.message!
                        : 'Gagal menyimpan data PIC.',
                  ),
                  backgroundColor: Colors.redAccent,
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

                  listBloc.add(FetchMRekanPicListEvent());
                  Navigator.pop(context, true);
                } else {
                  setState(() {
                    _saving = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PIC tersimpan, tapi gagal update COB.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              } catch (e) {
                if (!context.mounted) return;

                setState(() {
                  _saving = false;
                });

                debugPrint('💥 [ERROR] Gagal kirim selected COB: $e');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'PIC tersimpan, tapi terjadi error saat update COB.',
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
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
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
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

                                      if (mjnsclientId != '10') buildFieldJabatanNama(),
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
                                                colorFilter:
                                                const ColorFilter.mode(
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
                                                    'Akses',
                                                    style: bodyTextStyle(context)
                                                        .copyWith(
                                                      color: Colors.white70,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  BlocBuilder<
                                                      RekanPicCobCariBloc,
                                                      RekanPicCobCariState>(
                                                    builder: (context, cobState) {
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

                                      const SizedBox(height: 16),

                                      SizedBox(
                                        width: double.infinity,
                                        child: BlocBuilder<MRekanPicCrudBloc, MRekanPicCrudState>(
                                          builder: (context, crudState) {
                                            return AppButton.primary(
                                              text: 'Simpan',
                                              onPressed: crudState.isSaving ? null : _save,
                                            );
                                          },
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
    return appTextField(
      label: 'No. Telp',
      controller: _hp,
      keyboardType: TextInputType.phone,
      prefix: Text(
        '+62 | ',
        style: inputTextStyle(context, color: primaryLightColor),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
      ],
      validator: (v) {
        final telp = v?.trim() ?? "";

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

  Widget buildFieldJabatanNama() {
    return appTextField(
      label: 'Jabatan',
      controller: _jabatanNama,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Jabatan wajib diisi';
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