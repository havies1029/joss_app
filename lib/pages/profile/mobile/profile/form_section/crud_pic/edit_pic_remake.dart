import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';
import 'package:joss_app/repositories/combobox/combomjabatan_repository.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';
import 'package:joss_app/widgets/combobox/combomjabatan_widget.dart';

import '../../../../../../apis/gen_profile/rekanpiccobcari_api.dart';
import '../../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../../../../../repositories/gen_profile/rekanpiccobcari_repository.dart';
import '../../../../../base/base_background_sidepage.dart';
import '../../../../../gen_profile/common/rekanpiccobcari_list.dart';
import '../../../../../gen_profile/rekanpiccobmultipage.dart';

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
  List< RekanPicCobCariModel> _pendingCobList = [];
  final List<String> errors = [];
  bool _saving = false;
  final _formKey = GlobalKey<FormState>();

  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _hp = TextEditingController();
  final _comboKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();
  ComboMJabatanModel? _jabatan;
  bool _isDefault = false;

  late final MRekanPicCrudBloc crudBloc;
  late final RekanPicCobCariBloc cobBloc;

  void initState() {
    super.initState();
    cobBloc = context.read<RekanPicCobCariBloc>();
    crudBloc = context.read<MRekanPicCrudBloc>();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  void loadData() {
    cobBloc.add(RefreshRekanPicCobCariEvent(
      rekanPicId: widget.mrekanpicId,
      searchText: '',
    ));
    crudBloc.add(
        MRekanPicCrudLihatEvent(recordId: widget.mrekanpicId));
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _hp.dispose();
    super.dispose();
  }

  String _normalizeHp(String s) => s.replaceAll(' ', '');

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MultiBlocListener(
      listeners: [
        // =========================
        // 1) LISTENER CRUD PIC
        // =========================
        BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
          listenWhen: (prev, curr) =>
          prev.isSaved != curr.isSaved ||
              prev.hasFailure != curr.hasFailure ||
              prev.isLoaded != curr.isLoaded ||
              prev.record != curr.record,
          listener: (context, state) {
            if (state.isSaved == true) {
              Navigator.pop(context, true);
              return;
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

        // =========================
        // 2) LISTENER COB (inject cob awal ke pending list)
        // =========================
        BlocListener<RekanPicCobCariBloc, RekanPicCobCariState>(
          listenWhen: (prev, curr) =>
          prev.status != curr.status || prev.items != curr.items,
          listener: (context, state) {
            // sesuaikan kalau enum kamu bukan "success"
            if (state.status != ListStatus.success) return;

            final selected = state.items.where((e) => e.isChecked == true).toList();

            // isi pending hanya dari hasil fetch awal
            setState(() {
              _pendingCobList = List<RekanPicCobCariModel>.from(selected);
            });

            debugPrint('✅ [COB INIT] pendingCobList=${_pendingCobList.length}');
          },
        ),
      ],

      // =========================
      // CHILD UI KAMU TETAP
      // =========================
      child: BaseBackgroundSidePage(
        title: 'Edit PIC',
        child: LayoutBuilder(
          builder: (context, constraints) {
            final mjnsclientId = context.select((RegUserBloc b) => b.state.record?.jnsClientId);

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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Text('Form Edit PIC',
                          //     style: headingStyle(context, fontSize: 20)),
                          // const SizedBox(height: vPadding),

                          buildFieldEmail(),
                          const SizedBox(height: hPadding),

                          buildFieldRekanNama(),
                          const SizedBox(height: hPadding),

                          buildFiledTelp(),
                          const SizedBox(height: hPadding),

                          if (mjnsclientId != '10') buildFieldJabatan(),
                          const SizedBox(height: hPadding),

                          CheckboxWidget(
                            leftLabel: '',
                            rightLabel: 'PIC Default',
                            initialValue: _isDefault,
                            callback: (val) {
                              setState(() => _isDefault = val);
                            },
                          ),

                          const SizedBox(height: hPadding),

                          GestureDetector(
                            onTap: () async {
                              final selectedCobs = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RekanPicCobCariPage(
                                    rekanPicId: widget.mrekanpicId,
                                    viewMode: 'ubah',
                                  ),
                                ),
                              );

                              if (selectedCobs != null) {
                                setState(() {
                                  final combined = <RekanPicCobCariModel>[];

                                  for (final cob in selectedCobs) {
                                    if (cob.isChecked) {
                                      combined.add(cob);
                                    }
                                  }

                                  for (final old in _pendingCobList) {
                                    if (!combined.any((c) => c.mcobId == old.mcobId)) {
                                      combined.add(old);
                                    }
                                  }

                                  _pendingCobList = combined;
                                });
                              }

                            },
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
                                        style: bodyTextStyle(context, fontSize: 16),
                                      )
                                          : Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: _pendingCobList.map((e) => Container(
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            e.cobNama,
                                            style: bodyTextStyle(context, fontSize: 16),
                                          ),
                                        )).toList(),
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
                                  onPressed:
                                  _saving ? null : () => Navigator.pop(context, false),
                                  style: TextButton.styleFrom(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                    backgroundColor: sGrey.withOpacity(0.25),
                                    foregroundColor: primaryLightColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(cardBorderRadius),
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
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(cardBorderRadius),
                                    ),
                                  ),
                                  child: _saving
                                      ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
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

  void _injectPayload(MRekanPicCrudModel record) {
    // ✅ isi controller text
    _nama.text  = (record.picNama ?? '').trim();
    _email.text = (record.picEmail ?? '').trim();
    _hp.text    = (record.picHp ?? '').trim();

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


  Future<void> _save() async {

    if (_pendingCobList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar('Silakan pilih minimal 1 COB sebelum menyimpan.'),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    ComboMJabatanModel? selected = _jabatan;
    try {
      final st = _comboKey.currentState;
      if (selected == null) selected = st?.getSelectedItem;
    } catch (_) {}
    final mjnsclientId = context.select((RegUserBloc b) => b.state.record?.jnsClientId);

    final idJabatan = (mjnsclientId == '10') ? '' : (selected?.mjabatanId ?? '').trim();
    if (idJabatan.isEmpty) {
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

    context.read<MRekanPicCrudBloc>().add(
      MRekanPicCrudUbahEvent(record: record),
    );

    final cobRepo = RekanPicCobCariRepository();

    final listCheckbox = _pendingCobList.map((e) =>
        RekanPicCobCariCheckboxModel(
          mcobId: e.mcobId,
          isChecked: e.isChecked,
        )).toList();

    final cobResult = await cobRepo.rekanPicCobUpdateList(widget.mrekanpicId, listCheckbox);
    if (cobResult.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        successSnackBar('PIC & ${listCheckbox.length} COB berhasil diperbarui!'),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar('PIC tersimpan, tapi gagal update COB.'),
      );
    }

  }

  Widget buildFieldRekanNama(){
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
      // textInputAction: TextInputAction.next,
    );
  }

  Widget buildFieldEmail(){
    return appTextField(
      label: 'Email',
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      validator: (v) {
        if (v == null || v.isEmpty) return kEmailNullError;
        return null;
      },
      // textInputAction: TextInputAction.next,
    );
  }

  Widget buildFiledTelp(){
    return appTextField(
      label: 'No. Telp',
      controller: _hp,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'[0-9+ ]')),
      ],
      validator: (v) => (v == null ||
          v.trim().isEmpty)
          ? kPhoneNumberNullError
          : null,
    );
  }

  Widget buildFieldJabatan(){
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
