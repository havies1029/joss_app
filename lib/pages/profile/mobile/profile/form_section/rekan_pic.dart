import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_svg/svg.dart';

import 'package:joss_app/blocs/gen_profile/mrekanpiclist_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';
import 'package:joss_app/widgets/combobox/combomjabatan_widget.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';

import '../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../blocs/user_profile/user_profile_state.dart';
import '../../../../../common/constants.dart';
import '../../../../../helper/image_uploader.dart';
import '../../../../../repositories/combobox/combomjabatan_repository.dart';
import '../../../../base/base_background_sidepage.dart';

/// Bundle controller per baris
class _PicRowCtrls {
  final formKey = GlobalKey<FormState>();
  final nama = TextEditingController();
  final email = TextEditingController();
  final hp = TextEditingController();
  final comboKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();
  ComboMJabatanModel? jabatan;
  bool isDefault = false;

  void dispose() {
    nama.dispose();
    email.dispose();
    hp.dispose();
  }
}

class MRekanPicInlineEditorList extends StatefulWidget {
  const MRekanPicInlineEditorList({super.key});

  @override
  State<MRekanPicInlineEditorList> createState() => _MRekanPicInlineEditorListState();
}

class _MRekanPicInlineEditorListState extends State<MRekanPicInlineEditorList> {
  late MRekanPicListBloc listBloc;
  late MRekanPicCrudBloc crudBloc;

  // Controllers utk item existing: key = mrekanpicId
  final Map<String, _PicRowCtrls> _rowCtrls = {};
  // Controllers utk form tambah
  final _PicRowCtrls _newCtrls = _PicRowCtrls();

  bool _showAddForm = false;
  bool _isSavingNew = false;

  @override
  void dispose() {
    for (final c in _rowCtrls.values) {
      c.dispose();
    }
    _newCtrls.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- init blocs
    listBloc = context.read<MRekanPicListBloc>();
    crudBloc = context.read<MRekanPicCrudBloc>();
    SizeConfig().init(context);

    final content = BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
      listener: (context, state) {
        if (state.isSaved) {
          listBloc.add(FetchMRekanPicListEvent());
          setState(() {
            _isSavingNew = false;
            _showAddForm = false;
          });
          _clearNewRow();
        }
      },
      child: BlocBuilder<MRekanPicListBloc, MRekanPicListState>(
        builder: (context, state) {
          if (state.status == ListStatus.failure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal memuat data PIC'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => listBloc.add(FetchMRekanPicListEvent()),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          _ensureRowControllers(state);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Informasi PIC",
                style: headingStyle(context, fontSize: 22),
              ),
              Text("Data penanggung jawab utama perusahaan.",
                  style: bodyTextStyle(
                    context,
                    fontSize: 16,
                  ).copyWith(color: hintGrey)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: primaryColor, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                        "Maksimal 3 PIC yang bisa di tambahkan.",
                        style: inputTextStyle(context).copyWith(fontSize: 16)
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // === LIST ===
              if (state.items.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (ctx, idx) {
                    final item = state.items[idx];
                    final ctrls = _rowCtrls[item.mrekanpicId]!;
                    return _buildEditorRowCard(
                      title: 'PIC ${idx + 1}',
                      ctrls: ctrls,
                      isNew: false,
                      onSave: () => _saveExisting(item.mrekanpicId, ctrls),
                      onDelete: () => _confirmDelete(item.mrekanpicId),
                    );
                  },
                ),

              const SizedBox(height: 16),

              // === FORM TAMBAH ===
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    SizeTransition(sizeFactor: anim, child: child),
                child: _showAddForm
                    ? _buildEditorRowCard(
                  key: const ValueKey('add-form'),
                  title: 'Tambah PIC Baru',
                  ctrls: _newCtrls,
                  isNew: true,
                  onSave: _isSavingNew ? null : _saveNew,
                  onDelete: () {
                    setState(() {
                      _showAddForm = false;
                      _isSavingNew = false;
                    });
                    _clearNewRow();
                  },
                  isSaving: _isSavingNew,
                )
                    : AppButton.iconLeft(
                  text: 'Tambah PIC',
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: _isSavingNew
                      ? null
                      : () => setState(() => _showAddForm = true)
                )

              ),
            ],
          );
        },
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: 'Informasi PIC',
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: secondaryBlackColor,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    child: content,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ensureRowControllers(MRekanPicListState state) {
    if (state.items.isEmpty) {
      // kalau kosong, cukup pastikan _rowCtrls kosong juga
      _rowCtrls.clear();
      return;
    }

    // Tambahkan ctrls yang belum ada
    for (final item in state.items) {
      if (!_rowCtrls.containsKey(item.mrekanpicId)) {
        final c = _PicRowCtrls();
        c.nama.text  = item.picNama ?? '';
        c.email.text = item.picEmail ?? '';
        c.hp.text    = item.picHp ?? '';
        c.isDefault  = item.isDefault ?? false;

        c.jabatan = ComboMJabatanModel(
          mjabatanId: item.mjabatanId,
          jabatanDesc: item.jabatanDesc ?? item.jabatanDesc ?? '', // isi label
        );

        _rowCtrls[item.mrekanpicId] = c;
      }
    }

    // Bersihkan ctrls yang tidak ada lagi di list
    final ids = state.items.map((e) => e.mrekanpicId).toSet();
    final remove = _rowCtrls.keys.where((id) => !ids.contains(id)).toList();
    for (final id in remove) {
      _rowCtrls[id]?.dispose();
      _rowCtrls.remove(id);
    }
  }

  Widget _buildEditorRowCard({
    Key? key,
    required String title,
    required _PicRowCtrls ctrls,
    required bool isNew,
    required VoidCallback? onSave,
    required VoidCallback onDelete,
    bool isSaving = false,
  }) {
    return Card(
      key: key,
      color: pGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        side: const BorderSide(
          color: sGrey,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: ctrls.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + actions
              Row(
                children: [
                  Text(
                    title,
                    style: bodyTextStyle(context, fontSize: 20),
                  ),
                  const Spacer(),
                  AppButton.icon(
                    icon: const Icon(Icons.check, size: 20),
                    onPressed: onSave,
                    isLoading: isSaving,
                    backgroundColor: Colors.transparent,
                  ),
                  AppButton.icon(
                    icon: Icon(
                      isNew ? Icons.close : Icons.delete,
                      color: primaryLightColor,
                      size: 20,
                    ),
                    onPressed: onDelete,
                    isOutlined: true,
                    backgroundColor: Colors.transparent,
                  )

                ],
              ),

              const SizedBox(height: 8),

              appTextField(
                label: "Nama PIC",
                controller: ctrls.nama,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty) ? kNameNullError: null,
              ),

              const SizedBox(height: 12),

              appTextField(
                label: "Email",
                controller: ctrls.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty) ? kEmailNullError : null,
              ),

              const SizedBox(height: 12),

              appTextField(
                label: "No. Telp",
                controller: ctrls.hp,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                ],
                textInputAction: TextInputAction.done,
                validator: (v) => (v == null || v.trim().isEmpty) ? kPhoneNumberNullError : null,
              ),

              const SizedBox(height: 12),

              // Jabatan
              FormField<ComboMJabatanModel>(
                validator: (value) =>
                ctrls.jabatan == null ? 'Jabatan harus dipilih' : null,
                builder: (ffState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableComboBox<ComboMJabatanModel>(
                        hintText: "Jabatan",
                        searchHintText: "Cari Jabatan...",
                        comboKey: ctrls.comboKey,
                        initItem: ctrls.jabatan,
                        maxHeight: 150,
                        dataLoader: () => ComboMJabatanRepository().getComboMJabatan(),
                        displayText: (item) => item.jabatanDesc,
                        compareItems: (a, b) => a.mjabatanId == b.mjabatanId,
                        onChangedCallback: (val) {
                          setState(() => ctrls.jabatan = val);
                          ffState.didChange(val);
                        },
                        onSaveCallback: (val) {
                          ctrls.jabatan = val;
                        },
                        validatorCallback: (val) {
                          if (val == null) return kStringNullError;
                          return null;
                        },
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 8),

              // Default checkbox
              CheckboxListTile(
                value: ctrls.isDefault,
                onChanged: (v) => setState(() => ctrls.isDefault = v ?? false),
                title: Text(
                  'Jadikan sebagai PIC default',
                  style: bodyTextStyle(context),
                ),
                dense: true,
                activeColor: primaryColor,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              )

            ],
          ),
        ),
      ),
    );
  }

  // === ACTIONS ===

  void _saveExisting(String recordId, _PicRowCtrls c) {
    if (!(c.formKey.currentState?.validate() ?? false)) return;
    final record = MRekanPicCrudModel(
      mrekanpicId: recordId,
      picNama: c.nama.text.trim(),
      picEmail: c.email.text.trim().toLowerCase(),
      picHp: c.hp.text.trim(),
      mjabatanId: c.jabatan?.mjabatanId,
      isDefault: c.isDefault,
    );
    crudBloc.add(MRekanPicCrudUbahEvent(record: record));
  }

  void _saveNew() {
    final c = _newCtrls;
    if (!(c.formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSavingNew = true);

    final record = MRekanPicCrudModel(
      picNama: c.nama.text.trim(),
      picEmail: c.email.text.trim().toLowerCase(),
      picHp: c.hp.text.trim(),
      mjabatanId: c.jabatan?.mjabatanId,
      isDefault: c.isDefault,
    );
    crudBloc.add(MRekanPicCrudTambahEvent(record: record));
    Navigator.pop(context);
  }

  void _clearNewRow() {
    _newCtrls.nama.clear();
    _newCtrls.email.clear();
    _newCtrls.hp.clear();
    _newCtrls.jabatan = null;
    _newCtrls.isDefault = false;
  }

  void _confirmDelete(String recordId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ShowDialogHapusWidget(
        onHapusFunction: (id) => crudBloc.add(MRekanPicCrudHapusEvent(recordId: id)),
        recordId: recordId,
      ),
    ).then((_) {
      listBloc.add(CloseDialogMRekanPicListEvent());
    });
  }
}
