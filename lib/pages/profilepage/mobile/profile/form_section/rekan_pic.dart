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

import '../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../blocs/user_profile/user_profile_state.dart';
import '../../../../../common/constants.dart';
import '../../../../../helper/image_uploader.dart';
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

          _ensureRowControllers(state);

          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 24, 12, 24), // ✅ no contentTopPadding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // === AVATAR ===
                BlocBuilder<UserProfileCubit, UserProfileState>(
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
                              border: Border.all(
                                  color: sGrey, width: avatarBorderWidth),
                            ),
                            child: CircleAvatar(
                              radius: avatarRadius,
                              backgroundColor: secondaryBlackColor,
                              backgroundImage: (imageBytes != null &&
                                  imageBytes.isNotEmpty)
                                  ? MemoryImage(imageBytes)
                                  : null,
                              child: (imageBytes == null || imageBytes.isEmpty)
                                  ? const Icon(Icons.person,
                                  color: Colors.white, size: 48)
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
                                child: Icon(Icons.camera_alt,
                                    color: Color(0xffff6101), size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // === HEADER ===
                Padding(
                  padding: EdgeInsets.fromLTRB(hPadding, 0, hPadding, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Informasi PIC",
                          style: TextStyle(
                            fontSize: getResponsiveFont(context, 22),
                            fontWeight: FontWeight.w600,
                            color: primaryLightColor,
                          )),
                      Text("Data penanggung jawab utama perusahaan.",
                          style: TextStyle(
                            fontSize: getResponsiveFont(context, 16),
                            color: sGrey,
                            height: 1.3,
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, color: primaryColor, size: 20),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "Maksimal 3 PIC yang bisa di tambahkan.",
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 16),
                                color: primaryColor,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // === LIST ===
                if (state.items.isNotEmpty)
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

                const SizedBox(height: vPadding),

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
                      : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: hPadding), // 👈 kasih jarak kiri-kanan
                    child: SizedBox(
                      key: const ValueKey('add-button'),
                      width: double.infinity,
                      height: 56,
                      child: AppButton.iconLeft(
                        text: 'Tambah PIC',
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: _isSavingNew
                            ? null
                            : () => setState(() => _showAddForm = true),
                        backgroundColor: primaryColor,
                        iconTextSpacing: 10,
                      ),
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
                        // 🔥 scroll dipindah ke sini
                        SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          child: content,
                        ),

                        // Avatar overlay
                        // Positioned(
                        //   top: 16,
                        //   child: BlocBuilder<UserProfileCubit, UserProfileState>(
                        //     buildWhen: (prev, curr) =>
                        //     (prev.fotoBytes?.lengthInBytes ?? -1) !=
                        //         (curr.fotoBytes?.lengthInBytes ?? -1),
                        //     builder: (context, state) {
                        //       final imageBytes = state.fotoBytes;
                        //       return InkResponse(
                        //         onTap: () => ImageUploader.pickAndUpload(context),
                        //         containedInkWell: true,
                        //         customBorder: const CircleBorder(),
                        //         radius: avatarRadius + 14,
                        //         child: Stack(
                        //           alignment: Alignment.bottomRight,
                        //           children: [
                        //             Container(
                        //               padding: const EdgeInsets.all(avatarRingPadding),
                        //               decoration: BoxDecoration(
                        //                 shape: BoxShape.circle,
                        //                 color: primaryBlackColor,
                        //                 border: Border.all(
                        //                     color: sGrey, width: avatarBorderWidth),
                        //               ),
                        //               child: CircleAvatar(
                        //                 radius: avatarRadius,
                        //                 backgroundColor: secondaryBlackColor,
                        //                 backgroundImage: (imageBytes != null &&
                        //                     imageBytes.isNotEmpty)
                        //                     ? MemoryImage(imageBytes)
                        //                     : null,
                        //                 child: (imageBytes == null || imageBytes.isEmpty)
                        //                     ? const Icon(Icons.person,
                        //                     color: Colors.white, size: 48)
                        //                     : null,
                        //               ),
                        //             ),
                        //             const Positioned(
                        //               bottom: 4,
                        //               right: 4,
                        //               child: IgnorePointer(
                        //                 ignoring: true,
                        //                 child: CircleAvatar(
                        //                   radius: 18,
                        //                   backgroundColor: Colors.black87,
                        //                   child: Icon(Icons.camera_alt,
                        //                       color: Color(0xffff6101), size: 18),
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
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
      margin: const EdgeInsets.symmetric(horizontal: hPadding),
      color: pGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius), // ⬅️ radius pakai constant
        side: const BorderSide(
          color: sGrey, // ⬅️ border warna sGrey
          width: 1.0,
        ),
      ),
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
                  Text(
                    title,
                    style: TextStyle(fontSize: getResponsiveFont(context, 20), fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),

                  // === Tombol SIMPAN (centang) ===
                  ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : const Icon(Icons.check, color: Colors.white), // ⬅️ hanya ikon centang
                  ),

                  const SizedBox(width: 8),

                  // === Tombol BATAL (X) / HAPUS (tong sampah) ===
                  OutlinedButton(
                    onPressed: onDelete,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: isNew ? primaryLightColor : pRed),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: Icon(
                      isNew ? Icons.close : Icons.delete, // ⬅️ X untuk batal, 🗑️ untuk hapus
                      color: isNew ? primaryLightColor : pRed,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              appTextField(
                label: "Nama PIC",
                hint: "Masukkan nama",
                controller: ctrls.nama,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),

              const SizedBox(height: 12),

              appTextField(
                label: "Email",
                hint: "Masukkan email",
                controller: ctrls.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Email tidak boleh kosong' : null,
              ),

              const SizedBox(height: 12),

              appTextField(
                label: "No. HP",
                hint: "Masukkan nomor HP",
                controller: ctrls.hp,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                ],
                textInputAction: TextInputAction.done,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'No. HP tidak boleh kosong' : null,
              ),

              const SizedBox(height: 12),

              // Jabatan
              Text('Jabatan', style: TextStyle( fontSize: getResponsiveFont(context, 20)),),
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
