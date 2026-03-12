import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';
import 'package:joss_app/repositories/combobox/combomjabatan_repository.dart';

import '../../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../../../../../repositories/gen_profile/rekanpiccobcari_repository.dart';
import '../../../../../base/base_background_sidepage.dart';
import '../../../../../gen_profile/common/rekanpiccobcari_list.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _comboKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();

  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _hp = TextEditingController();

  late final MRekanPicCrudBloc crudBloc;
  late final RekanPicCobCariBloc cobBloc;

  ComboMJabatanModel? _jabatan;
  List<RekanPicCobCariModel> _pendingCobList = [];

  bool _isDefault = false;
  bool _saving = false;
  bool _showErrors = false;

  bool _payloadInjected = false;
  bool _initialCobInjected = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    crudBloc = context.read<MRekanPicCrudBloc>();
    cobBloc = context.read<RekanPicCobCariBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    crudBloc.add(
      MRekanPicCrudLihatEvent(recordId: widget.mrekanpicId),
    );

    cobBloc.add(
      RefreshRekanPicCobCariEvent(
        rekanPicId: widget.mrekanpicId,
        searchText: '',
      ),
    );
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _hp.dispose();
    super.dispose();
  }

  String _normalizeHp(String value) {
    return value.replaceAll(' ', '');
  }

  Future<void> _openCobPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => RekanPicCobCariBloc(),
          child: RekanPicCobCariPage(
            rekanPicId: widget.mrekanpicId,
            viewMode: 'ubah',
            initialSelectedItems: _pendingCobList,
          ),
        ),
      ),
    );

    if (!mounted || result == null) return;

    final selected = (result as List)
        .whereType<RekanPicCobCariModel>()
        .where((e) => e.isChecked)
        .toList();

    setState(() {
      _pendingCobList = selected;
    });
  }

  void _injectPayload(MRekanPicCrudModel record) {
    if (_payloadInjected) return;

    _nama.text = (record.picNama ?? '').trim();
    _email.text = (record.picEmail ?? '').trim();
    _hp.text = (record.picHp ?? '').trim();
    _isDefault = record.isDefault ?? false;

    final comboFromRecord = record.comboMJabatan;
    final mjabatanId = (record.mjabatanId ?? '').trim();

    if (comboFromRecord != null) {
      _jabatan = comboFromRecord;
    } else if (mjabatanId.isNotEmpty) {
      _jabatan = ComboMJabatanModel(
        mjabatanId: mjabatanId,
        jabatanDesc: '',
      );
    } else {
      _jabatan = null;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_jabatan != null) {
        _comboKey.currentState?.changeSelectedItem(_jabatan);
      }
    });

    _payloadInjected = true;
    setState(() {});
  }

  Future<void> _save() async {
    if (_isSubmitting || _saving) return;

    final selectedCob = _pendingCobList.where((e) => e.isChecked).toList();
    if (selectedCob.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar('Silakan pilih minimal 1 COB sebelum menyimpan.'),
      );
      return;
    }

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      if (!_showErrors) {
        setState(() => _showErrors = true);
      }
      return;
    }

    _formKey.currentState?.save();

    ComboMJabatanModel? selectedJabatan = _jabatan;
    try {
      selectedJabatan ??= _comboKey.currentState?.getSelectedItem;
    } catch (_) {}

    final mjnsclientId =
        context.read<RegUserBloc>().state.record?.jnsClientId;

    final idJabatan = (mjnsclientId == '10')
        ? ''
        : (selectedJabatan?.mjabatanId.trim() ?? '');

    if (mjnsclientId != '10' && idJabatan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar('Jabatan harus dipilih'),
      );
      return;
    }

    final record = MRekanPicCrudModel(
      mrekanpicId: widget.mrekanpicId,
      picNama: _nama.text.trim(),
      picEmail: _email.text.trim().toLowerCase(),
      picHp: _normalizeHp(_hp.text.trim()),
      mjabatanId: idJabatan,
      isDefault: _isDefault,
    );

    setState(() {
      _saving = true;
      _isSubmitting = true;
    });

    crudBloc.add(
      MRekanPicCrudUbahEvent(record: record),
    );
  }

  Future<void> _handleCrudSaved() async {
    final selectedCob = _pendingCobList.where((e) => e.isChecked).toList();

    final listCheckbox = selectedCob
        .map(
          (e) => RekanPicCobCariCheckboxModel(
        mcobId: e.mcobId,
        isChecked: true,
      ),
    )
        .toList();

    try {
      final cobRepo = RekanPicCobCariRepository();
      final cobResult = await cobRepo.rekanPicCobUpdateList(
        widget.mrekanpicId,
        listCheckbox,
      );

      if (!mounted) return;

      setState(() {
        _saving = false;
        _isSubmitting = false;
      });

      if (cobResult.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          successSnackBar(
            'PIC & ${listCheckbox.length} COB berhasil diperbarui!',
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar('PIC tersimpan, tapi gagal update COB.'),
        );
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _saving = false;
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar('PIC tersimpan, tapi terjadi error saat update COB.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
          listenWhen: (prev, curr) =>
          prev.isLoaded != curr.isLoaded ||
              prev.record != curr.record ||
              prev.isSaved != curr.isSaved ||
              prev.hasFailure != curr.hasFailure,
          listener: (context, state) async {
            if (!mounted) return;

            if (state.isLoaded && state.record != null && !_payloadInjected) {
              _injectPayload(state.record!);
            }

            if (state.hasFailure) {
              setState(() {
                _saving = false;
                _isSubmitting = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar('Gagal menyimpan perubahan. Coba lagi.'),
              );
              return;
            }

            if (state.isSaved && _isSubmitting) {
              await _handleCrudSaved();
            }
          },
        ),

        BlocListener<RekanPicCobCariBloc, RekanPicCobCariState>(
          listenWhen: (prev, curr) =>
          prev.status != curr.status || prev.items != curr.items,
          listener: (context, state) {
            if (!mounted) return;
            if (state.status != ListStatus.success) return;
            if (_initialCobInjected) return;

            final selected = state.items.where((e) => e.isChecked).toList();

            setState(() {
              _pendingCobList = List<RekanPicCobCariModel>.from(selected);
              _initialCobInjected = true;
            });
          },
        ),
      ],
      child: BaseBackgroundSidePage(
        title: 'Edit PIC',
        child: LayoutBuilder(
          builder: (context, constraints) {
            final mjnsclientId =
            context.select((RegUserBloc b) => b.state.record?.jnsClientId);

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Container(
                color: secondaryBlackColor,
                padding: EdgeInsets.symmetric(
                  horizontal: hPadding * 1.5,
                  vertical: 10,
                ),
                child: Card(
                  color: pGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    side: const BorderSide(color: sGrey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _showErrors
                          ? AutovalidateMode.always
                          : AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildFieldEmail(),
                          const SizedBox(height: hPadding),

                          _buildFieldNama(),
                          const SizedBox(height: hPadding),

                          _buildFieldTelp(),
                          const SizedBox(height: hPadding),

                          if (mjnsclientId != '10') _buildFieldJabatan(),
                          const SizedBox(height: hPadding),

                          CheckboxWidget(
                            leftLabel: '',
                            rightLabel: 'PIC Default',
                            initialValue: _isDefault,
                            callback: (val) {
                              setState(() {
                                _isDefault = val;
                              });
                            },
                          ),

                          const SizedBox(height: hPadding),

                          GestureDetector(
                            onTap: _saving ? null : _openCobPicker,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Akses',
                                  style: bodyTextStyle(context, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: pGrey,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: sGrey),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/list_cob_icon.svg',
                                        width: 10,
                                        height: 10,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _pendingCobList.isEmpty
                                          ? Text(
                                        'Pilih Daftar COB',
                                        style: bodyTextStyle(
                                          context,
                                          fontSize: 16,
                                        ),
                                      )
                                          : Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: _pendingCobList.map((e) {
                                          return Container(
                                            height: 30,
                                            padding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                              BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              e.cobNama,
                                              style: bodyTextStyle(
                                                context,
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

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
                                      color: Colors.white,
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
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFieldNama() {
    return appTextField(
      label: 'Nama PIC',
      controller: _nama,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return kNameNullError;
        }
        return null;
      },
    );
  }

  Widget _buildFieldEmail() {
    return appTextField(
      label: 'Email',
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return kEmailNullError;
        }

        final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
        if (!emailRegex.hasMatch(v.trim())) {
          return 'Format email tidak valid';
        }

        return null;
      },
    );
  }

  Widget _buildFieldTelp() {
    return appTextField(
      label: 'No. Telp',
      controller: _hp,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
      ],
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return kPhoneNumberNullError;
        }
        return null;
      },
    );
  }

  Widget _buildFieldJabatan() {
    return ReusableComboBox<ComboMJabatanModel>(
      hintText: 'Jabatan',
      comboKey: _comboKey,
      initItem: _jabatan,
      dataLoader: () => ComboMJabatanRepository().getComboMJabatan(),
      displayText: (i) => i.jabatanDesc,
      compareItems: (a, b) => a.mjabatanId == b.mjabatanId,
      onChangedCallback: (value) {
        if (value != null) {
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
}