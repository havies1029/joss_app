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

import '../../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../../../../../repositories/gen_profile/mrekanpiccrud_repository.dart';
import '../../../../../../repositories/gen_profile/rekanpiccobcari_repository.dart';
import '../../../../../base/base_background_sidepage.dart';
import '../../../../../gen_profile/common/rekanpiccobcari_list.dart';
import '../../../../../gen_profile/rekanpiccobmultipage.dart';

class TambahPicWidget extends StatefulWidget {
  const TambahPicWidget({super.key});

  @override
  State<TambahPicWidget> createState() => _TambahPicWidgetState();
}

class _TambahPicWidgetState extends State<TambahPicWidget> {
  List< RekanPicCobCariModel> _pendingCobList = [];


  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _hp = TextEditingController();

  final _comboKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();
  ComboMJabatanModel? _jabatan;

  bool _isDefault = false;
  bool _saving = false;
  bool _showErrors = false;

  List<ComboMJabatanModel>? _jabatanCache;

  Future<List<ComboMJabatanModel>> _loadJabatan() async {
    _jabatanCache ??= await ComboMJabatanRepository().getComboMJabatan();
    return _jabatanCache!;
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _hp.dispose();
    super.dispose();
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return kEmailNullError;
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Format email tidak valid';
  }

  String _normalizeHp(String s) => s.replaceAll(' ', '');

  void _save() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      if (!_showErrors) setState(() => _showErrors = true);
      return;
    }

    final idJabatan = (_jabatan?.mjabatanId ?? '').trim();
    if (idJabatan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jabatan harus dipilih')),
      );
      return;
    }

    // 🚫 VALIDASI: wajib pilih minimal 1 COB
    if (_pendingCobList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih minimal 1 COB sebelum menyimpan.')),
      );
      debugPrint('⚠️ [VALIDATION] User belum memilih COB — simpan dibatalkan.');
      return;
    }

    setState(() => _saving = true);

    final record = MRekanPicCrudModel(
      picNama: _nama.text.trim(),
      picEmail: _email.text.trim().toLowerCase(),
      picHp: _normalizeHp(_hp.text.trim()),
      mjabatanId: idJabatan,
      isDefault: _isDefault,
    );

    debugPrint('🚀 [SAVE] Mulai simpan data PIC...');
    debugPrint('📦 Payload: ${record.toJson()}');

    // 🛰️ Step 1: Simpan PIC ke API
    final repo = MRekanPicCrudRepository();
    final returnData = await repo.mRekanPicCrudTambah(record);

    if (!returnData.success) {
      debugPrint('❌ [SAVE] Gagal menyimpan PIC ke server.');
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan PIC. Coba lagi.')),
      );
      return;
    }

    // ✅ Step 2: Ambil picId dari returnData
    final picId = returnData.data;
    debugPrint('✅ [SAVE] PIC berhasil disimpan dengan ID: $picId');

    // 🔄 Step 3: Kirim pending COB ke server
    debugPrint('📤 Mengirim ${_pendingCobList.length} COB ke PIC ID $picId...');

    try {
      final cobRepo = RekanPicCobCariRepository();

      final listCheckbox = _pendingCobList.map((e) =>
          RekanPicCobCariCheckboxModel(
            mcobId: e.mcobId,
            isChecked: e.isChecked,
          ),
      ).toList();

      debugPrint('🧾 [COB] Payload dikirim: ${listCheckbox.map((e) => e.toJson()).toList()}');

      final cobResult = await cobRepo.rekanPicCobUpdateList(picId, listCheckbox);

      if (cobResult.success) {
        debugPrint('✅ [COB] ${listCheckbox.length} item berhasil diupdate ke server.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PIC & ${listCheckbox.length} COB berhasil disimpan!')),
        );
      } else {
        debugPrint('⚠️ [COB] Gagal update COB ke server untuk PIC $picId.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIC tersimpan, tapi gagal update COB.')),
        );
      }
    } catch (e) {
      debugPrint('💥 [ERROR] Gagal kirim pending COB: $e');
    }

    setState(() => _saving = false);

    debugPrint('🎯 [DONE] Semua proses selesai — PIC & COB tersimpan.');
    Navigator.pop(context, true);
  }



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
          listener: (context, state) async {

            if (state.hasFailure == true) {
              setState(() => _saving = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gagal menyimpan. Coba lagi.')),
              );
            }
          },
          child: BaseBackgroundSidePage(
            title: 'Tambah PIC',
            child: LayoutBuilder(
              builder: (context, constraints) {
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
                        constraints: BoxConstraints(maxWidth: 720),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 🔹 Tambahkan teks penjelasan di atas card
                            Text(
                              "Di sini Anda dapat mengelola dan menambahkan PIC yang akan diundang melalui email untuk setiap asuransi Anda.",
                              style: bodyTextStyle(
                                context,
                                fontSize: getResponsiveFont(context, 16),
                              ).copyWith(color: primaryLightColor),
                            ),

                            SizedBox(height: hPadding,),

                            // 🔹 Card form
                            Card(
                              color: formGrey,
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

                                      const SizedBox(height: hPadding),

                                      // 🔹 Nama
                                      appTextField(
                                        label: 'Nama PIC',
                                        controller: _nama,
                                        validator: (v) => (v == null || v.trim().isEmpty)
                                            ? kNameNullError
                                            : null,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: hPadding),

                                      // 🔹 Email
                                      appTextField(
                                        label: 'Email',
                                        controller: _email,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: _emailValidator,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: hPadding),

                                      // 🔹 Nomor Telepon
                                      appTextField(
                                        label: 'No. Telp',
                                        controller: _hp,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9+ ]')),
                                        ],
                                        validator: (v) => (v == null || v.trim().isEmpty)
                                            ? kPhoneNumberNullError
                                            : null,
                                      ),
                                      const SizedBox(height: hPadding),

                                      // 🔹 Combo Jabatan
                                      ReusableComboBox<ComboMJabatanModel>(
                                        key: ValueKey(
                                            'jabatan-${_jabatan?.mjabatanId ?? "none"}'),
                                        hintText: "Jabatan",
                                        comboKey: _comboKey,
                                        initItem: _jabatan,
                                        maxHeight: 180,
                                        dataLoader: _loadJabatan,
                                        displayText: (i) => i.jabatanDesc,
                                        compareItems: (a, b) =>
                                        (a.mjabatanId ?? '').trim() ==
                                            (b.mjabatanId ?? '').trim(),
                                        onChangedCallback: (val) =>
                                            setState(() => _jabatan = val),
                                        onSaveCallback: (val) => _jabatan = val,
                                        validatorCallback: (val) =>
                                        val == null ? kStringNullError : null,
                                      ),

                                      const SizedBox(height: hPadding),

                                      CheckboxListTile(
                                        value: _isDefault,
                                        onChanged: (v) => setState(() => _isDefault = v ?? false),
                                        title: Text(
                                          'Jadikan sebagai PIC default',
                                          style: bodyTextStyle(context),
                                        ),
                                        dense: true,
                                        activeColor: primaryColor,
                                        controlAffinity: ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      const SizedBox(height: hPadding),


                                      GestureDetector(
                                        onTap: () async {
                                          final selectedCobs = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => BlocProvider(
                                                create: (_) => RekanPicCobCariBloc(),
                                                child: RekanPicCobCariPage(
                                                  rekanPicId: '0', // untuk mode tambah
                                                  viewMode: 'tambah',
                                                ),
                                              ),
                                            ),
                                          );

                                          if (selectedCobs != null && selectedCobs.isNotEmpty) {
                                            setState(() {
                                              _pendingCobList = selectedCobs;
                                            });
                                            debugPrint("🟠 Pending COB disimpan sementara: ${_pendingCobList!.length} item");
                                          }
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 🧩 Icon kiri
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

                                            // 📋 Isi konten
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Akses',
                                                    style: bodyTextStyle(context)
                                                        .copyWith(color: Colors.white70, fontSize: 13),
                                                  ),
                                                  const SizedBox(height: 4),

                                                  if (_pendingCobList == null || _pendingCobList!.isEmpty)
                                                    const Text(
                                                      'Pilih Daftar COB',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15,
                                                      ),
                                                    )
                                                  else
                                                    Wrap(
                                                      spacing: 6,
                                                      runSpacing: 6,
                                                      children: _pendingCobList!
                                                          .map(
                                                            (e) => Container(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 10, vertical: 6),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFFFF9D00),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text(
                                                            e.cobNama,
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                          .toList(),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                      const SizedBox(height: 16),

                                      // 🔹 Tombol Aksi
                                      Row(
                                        children: [
                                          // 🔹 Tombol Simpan
                                          Expanded(
                                            child: TextButton(
                                              onPressed: _saving ? null : _save,
                                              style: TextButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                backgroundColor: primaryColor,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(cardBorderRadius),
                                                ),
                                              ),
                                              child: _saving
                                                  ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                              )
                                                  : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/save_btn_pic.svg',
                                                    height: 18,
                                                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                                  ),
                                                  SizedBox(width: hPadding),
                                                  Text(
                                                    'Simpan',
                                                    style: TextStyle(
                                                      fontSize: getResponsiveFont(context, 16), // 🎯 ukuran custom
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          // 🔹 Tombol Kirim Undangan
                                          Expanded(
                                            child: TextButton(
                                              onPressed: _saving ? null : _save, // TODO: ganti ke fungsi _sendInvite kalau ada
                                              style: TextButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                backgroundColor: sBlue, // 💙 gunakan sBlue untuk tombol kirim
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(cardBorderRadius),
                                                ),
                                              ),
                                              child: _saving
                                                  ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                              )
                                                  : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/send_btn_pic.svg',
                                                    height: 18,
                                                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                                  ),
                                                  SizedBox(width: hPadding),
                                                  Text(
                                                    'Kirim Undangan',
                                                    style: TextStyle(
                                                      fontSize: getResponsiveFont(context, 16), // 🎯 ukuran custom
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
}
