import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:joss_app/blocs/gen_profile/mrekanpiclist_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';
import 'package:joss_app/widgets/combobox/combomjabatan_widget.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';

import '../../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../../blocs/user_profile/user_profile_state.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../helper/image_uploader.dart';
import '../../../../../base/base_background_sidepage.dart';

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

    // --- layout vars (ngikut contoh lo)
    final screenHeight = MediaQuery.of(context).size.height;
    final headerSpacing = screenHeight * 0.025;
    const double avatarRadius = 50;
    const double avatarRingPadding = 3;
    const double avatarBorderWidth = 2;
    const double contentTopPadding = 120; // ruang buat avatar biar konten gak ketimpa

    // --- listener CRUD (refresh list + tutup form tambah setelah save/hapus)
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
          //
          // // (opsional) tampilkan loading kalau ada state loading
          // if (state.status == ListStatus.loading) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          // Sinkronisasi controllers dgn data list
          _ensureRowControllers(state);

          // ====== KONTEN FORM LIST (scrollable) ======
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, contentTopPadding + 8, 12, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // === LIST EDITABLE ===
                if (state.items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(child: Text('Belum ada data PIC')),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, idx) {
                      final item = state.items[idx];
                      final ctrls = _rowCtrls[item.mrekanpicId]!;
                      return _buildEditorRowCard(
                        title: 'Edit PIC',
                        ctrls: ctrls,
                        isNew: false,
                        onSave: () => _saveExisting(item.mrekanpicId, ctrls),
                        onDelete: () => _confirmDelete(item.mrekanpicId),
                      );
                    },
                  ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // === BUTTON TAMBAH / FORM TAMBAH ===
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => SizeTransition(sizeFactor: anim, child: child),
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
                      : // import 'package:joss_app/common/constants.dart'; // pastikan constants kebawa

                  SizedBox(
                    key: const ValueKey('add-button'),
                    width: double.infinity, // full width
                    height: 56,             // tinggi tombol (cobain 56–60 biar mantap)
                    child: AppButton.iconLeft(
                      text: 'Tambah PIC',
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: _isSavingNew ? null : () => setState(() => _showAddForm = true),

                      // styling JPS
                      backgroundColor: primaryColor,
                      iconTextSpacing: 10,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // ====== WRAP DENGAN BASE BACKGROUND + AVATAR OVERLAY ======
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          backgroundAsset: "assets/images/background_gradient.png",
          fadeHeight: 300,
          title: 'Informasi PIC', // ganti judul panel
          child: Column(
            children: [
              SizedBox(height: headerSpacing * 4),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: secondaryBlackColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      border: Border(
                        top: BorderSide(color: primaryColor, width: 4.0),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        // --- konten scrollable (form list + tambah)
                        content,

                        // --- Avatar tetap di atas tengah (opsional, kalau mau dipakai di screen ini)
                        Positioned(
                          top: 16,
                          child: BlocBuilder<UserProfileCubit, UserProfileState>(
                            buildWhen: (prev, curr) =>
                            (prev.fotoBytes?.lengthInBytes ?? -1) !=
                                (curr.fotoBytes?.lengthInBytes ?? -1),
                            builder: (context, state) {
                              final imageBytes = state.fotoBytes;
                              return InkResponse(
                                onTap: () => ImageUploader.pickAndUpload(context),
                                containedInkWell: true,
                                customBorder: const CircleBorder(),
                                radius: avatarRadius + 14,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(avatarRingPadding),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryBlackColor,
                                        border: Border.all(color: sGrey, width: avatarBorderWidth),
                                      ),
                                      child: CircleAvatar(
                                        radius: avatarRadius,
                                        backgroundColor: secondaryBlackColor,
                                        backgroundImage: (imageBytes != null && imageBytes.isNotEmpty)
                                            ? MemoryImage(imageBytes)
                                            : null,
                                        child: (imageBytes == null || imageBytes.isEmpty)
                                            ? const Icon(Icons.person, color: Colors.white, size: 48)
                                            : null,
                                      ),
                                    ),
                                    const Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: IgnorePointer(
                                        ignoring: true,
                                        child: CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.black87,
                                          child: Icon(Icons.camera_alt, color: Color(0xffff6101), size: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: ctrls.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + actions
              Row(
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: onSave,
                    icon: isSaving
                        ? const SizedBox(
                        height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.save),
                    label: Text(
                      isNew ? 'Simpan' : 'Simpan',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                      onPressed: onDelete,
                      // icon: Icon(isNew ? Icons.close : Icons.delete_outline),
                      label: AppButton.iconLeft(
                        text: isNew ? 'Batal' : 'Hapus',
                        icon: Icon(isNew ? Icons.close : Icons.delete_outline, size: 18),
                        onPressed: onDelete,
                        backgroundColor: Colors.transparent,
                      )

                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Nama
              const Text('Nama PIC'),
              TextFormField(
                controller: ctrls.nama,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nama',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),

              // Email
              const Text('Email'),
              TextFormField(
                controller: ctrls.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Masukkan email',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Email tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),

              // HP
              const Text('No. HP'),
              TextFormField(
                controller: ctrls.hp,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
                decoration: const InputDecoration(
                  hintText: 'Masukkan nomor HP',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'No. HP tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),

              // Jabatan
              const Text('Jabatan'),
              FormField<ComboMJabatanModel>(
                validator: (_) => ctrls.jabatan == null ? 'Jabatan harus dipilih' : null,
                builder: (ffState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildFieldComboMJabatan(
                        comboKey: ctrls.comboKey,
                        labelText: 'Pilih Jabatan',
                        initItem: ctrls.jabatan,
                        onChangedCallback: (val) {
                          setState(() => ctrls.jabatan = val);
                          ffState.didChange(val);
                        },
                        onSaveCallback: (val) => ctrls.jabatan = val,
                        validatorCallback: (_) {},
                      ),
                      if (ffState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(ffState.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),

              // Default checkbox
              Row(
                children: [
                  Checkbox(
                    value: ctrls.isDefault,
                    onChanged: (v) => setState(() => ctrls.isDefault = v ?? false),
                  ),
                  const Text('Jadikan sebagai PIC default'),
                ],
              ),
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
