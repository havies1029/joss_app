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

import '../../../../../../common/constants.dart';
import '../../../../../base/base_background_sidepage.dart';

class TambahPicWidget extends StatefulWidget {
  const TambahPicWidget({super.key});

  @override
  State<TambahPicWidget> createState() => _TambahPicWidgetState();
}

class _TambahPicWidgetState extends State<TambahPicWidget> {
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

  void _save() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      if (!_showErrors) setState(() => _showErrors = true);
      return;
    }

    ComboMJabatanModel? selected = _jabatan;
    try {
      final st = _comboKey.currentState;
      if (selected == null) selected = st?.getSelectedItem;
    } catch (_) {}

    final idJabatan = (selected?.mjabatanId ?? '').trim();
    if (idJabatan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jabatan harus dipilih')),
      );
      if (!_showErrors) setState(() => _showErrors = true);
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

    context.read<MRekanPicCrudBloc>().add(
      MRekanPicCrudTambahEvent(record: record),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
          listener: (context, state) {
            if (state.isSaved == true) {
              Navigator.pop(context, true);
              return;
            }
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
                                      const SizedBox(height: 16),

                                      // 🔹 Nama
                                      appTextField(
                                        label: 'Nama PIC',
                                        controller: _nama,
                                        validator: (v) => (v == null || v.trim().isEmpty)
                                            ? kNameNullError
                                            : null,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 12),

                                      // 🔹 Email
                                      appTextField(
                                        label: 'Email',
                                        controller: _email,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: _emailValidator,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 12),

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
                                      const SizedBox(height: 12),

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
                                      const SizedBox(height: 8),

                                      CheckboxListTile(
                                        value: _isDefault,
                                        onChanged: (v) =>
                                            setState(() => _isDefault = v ?? false),
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
