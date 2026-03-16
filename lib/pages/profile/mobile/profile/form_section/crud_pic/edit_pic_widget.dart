
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/loading_indicator.dart';
import '../../../../../../blocs/gen_invite/invite_bloc.dart';
import '../../../../../../blocs/gen_profile/mrekanpiccrud_bloc.dart';
import '../../../../../../blocs/gen_profile/mrekanpiclist_bloc.dart';
import '../../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
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

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _hp = TextEditingController();
  final _comboKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();

  ComboMJabatanModel? _jabatan;
  bool _isDefault = false;
  bool _showErrors = false;

  late final MRekanPicCrudBloc crudBloc;
  late final RekanPicCobCariBloc cobBloc;
  late MRekanPicListBloc listBloc;

  @override
  void initState() {
    super.initState();
    listBloc = context.read<MRekanPicListBloc>();
    cobBloc = context.read<RekanPicCobCariBloc>();
    crudBloc = context.read<MRekanPicCrudBloc>();

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

    setState(() => _saving = true);

    final mjnsclientId = context.read<RegUserBloc>().state.record?.jnsClientId;

    final idJabatan = (mjnsclientId == '10')
        ? ''
        : (_jabatan?.mjabatanId.trim().isEmpty ?? true)
        ? ''
        : _jabatan!.mjabatanId.trim();

    final hpNormalized = _toNormalizedPhone62(_hp.text.trim());

    final record = MRekanPicCrudModel(
      mrekanpicId: widget.mrekanpicId,
      picNama: _nama.text.trim(),
      picEmail: _email.text.trim().toLowerCase(),
      picHp: hpNormalized,
      mjabatanId: idJabatan,
      isDefault: _isDefault,
    );

    crudBloc.add(MRekanPicCrudUbahEvent(record: record));
  }

  void _injectPayload(MRekanPicCrudModel record) {
    _nama.text = (record.picNama ?? '').trim();
    _email.text = (record.picEmail ?? '').trim();
    _hp.text = _toPhoneFieldValue((record.picHp ?? '').trim());
    _isDefault = record.isDefault ?? false;

    _jabatan = record.comboMJabatan ??
        ((record.mjabatanId ?? '').trim().isNotEmpty
            ? ComboMJabatanModel(
          mjabatanId: (record.mjabatanId ?? '').trim(),
          jabatanDesc: record.comboMJabatan?.jabatanDesc ?? '',
        )
            : null);

    if (_jabatan != null) {
      _comboKey.currentState?.changeSelectedItem(_jabatan);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
              listenWhen: (prev, curr) =>
              prev.isSaved != curr.isSaved ||
                  prev.hasFailure != curr.hasFailure ||
                  prev.isLoaded != curr.isLoaded ||
                  prev.record != curr.record,
              listener: (context, state) async {
                if (state.isSaved == true) {
                  try {
                    final picId = (widget.mrekanpicId).trim();
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

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'PIC & ${listCheckbox.length} COB berhasil disimpan!',
                          ),
                        ),
                      );

                      listBloc.add(
                          FetchMRekanPicListEvent());

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

                if (state.isLoaded == true && state.record != null) {
                  _injectPayload(state.record!);
                }

                if (state.hasFailure == true) {
                  setState(() => _saving = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    errorSnackBar('Gagal menyimpan perubahan. Coba lagi.'),
                  );
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
                                        'Form Edit PIC',
                                        style: headingStyle(context, fontSize: 20),
                                      ),
                                      const SizedBox(height: vPadding),

                                      buildFieldRekanNama(),
                                      const SizedBox(height: vPadding),

                                      buildFieldEmail(),
                                      const SizedBox(height: vPadding),

                                      buildFiledTelp(),
                                      const SizedBox(height: vPadding),

                                      if (mjnsclientId != '10') ...[
                                        buildFieldJabatan(),
                                        const SizedBox(height: vPadding),
                                      ],

                                      CheckboxListTile(
                                        value: _isDefault,
                                        onChanged: (v) => setState(
                                              () => _isDefault = v ?? false,
                                        ),
                                        title: Text(
                                          'Jadikan sebagai PIC default',
                                          style: bodyTextStyle(context),
                                        ),
                                        dense: true,
                                        activeColor: primaryColor,
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                      ),

                                      const SizedBox(height: vPadding),

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
                                                      final isInitialLoading =
                                                          cobState.status == ListStatus.initial &&
                                                              cobState.items.isEmpty &&
                                                              cobState.selectedItems.isEmpty;

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
                                            child: TextButton(
                                              onPressed: _saving
                                                  ? null
                                                  : () => Navigator.pop(context, false),
                                              style: TextButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                backgroundColor: sGrey.withOpacity(0.25),
                                                foregroundColor: primaryLightColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                    cardBorderRadius,
                                                  ),
                                                ),
                                              ),
                                              child: const Text('Batal'),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: TextButton(
                                              onPressed: _saving ? null : _save,
                                              style: TextButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                backgroundColor: primaryColor,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                    cardBorderRadius,
                                                  ),
                                                ),
                                              ),
                                              child: _saving
                                                  ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                                  : const Text('Simpan'),
                                            ),
                                          ),
                                        ],
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

  Widget buildFieldJabatan() {
    return ReusableComboBox<ComboMJabatanModel>(
      hintText: "Jabatan",
      comboKey: _comboKey,
      initItem: _jabatan,
      dataLoader: () => ComboMJabatanRepository().getComboMJabatan(),
      displayText: (i) => i.jabatanDesc,
      compareItems: (a, b) => a.mjabatanId == b.mjabatanId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: kStringNullError);
          setState(() {
            _jabatan = value;
          });
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
          return kStringNullError;
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