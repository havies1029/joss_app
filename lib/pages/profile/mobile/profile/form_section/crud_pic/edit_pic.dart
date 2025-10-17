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
import '../../../../../../common/constants.dart';
import '../../../../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../../../../base/base_background_sidepage.dart';
import '../../../../../gen_profile/common/rekanpiccobcari_list.dart';
import '../../../../../gen_profile/rekanpiccobmultipage.dart';

class EditPicWidget extends StatefulWidget {
  final String mrekanpicId;
  final String? initNama;
  final String? initEmail;
  final String? initHp;
  final ComboMJabatanModel? initJabatanModel;
  final bool initIsDefault;

  const EditPicWidget({
    super.key,
    required this.mrekanpicId,
    this.initNama,
    this.initEmail,
    this.initHp,
    this.initJabatanModel,
    this.initIsDefault = false,
  });

  @override
  State<EditPicWidget> createState() => _EditPicWidgetState();
}

class _EditPicWidgetState extends State<EditPicWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _hp = TextEditingController();
  List<RekanPicCobCariModel>? _selectedCobList = [];

  final _comboKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();
  ComboMJabatanModel? _jabatan;
  bool _isDefault = false;
  bool _saving = false;

  List<ComboMJabatanModel>? _jabatanCache;
  Future<List<ComboMJabatanModel>> _loadJabatan() async {
    _jabatanCache ??= await ComboMJabatanRepository().getComboMJabatan();
    return _jabatanCache!;
  }

  @override
  void initState() {
    super.initState();
    _nama.text = widget.initNama ?? '';
    _email.text = widget.initEmail ?? '';
    _hp.text = widget.initHp ?? '';
    _isDefault = widget.initIsDefault;
// 🔹 Tambahkan inisialisasi untuk COB list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cobBloc = context.read<RekanPicCobCariBloc>();
      cobBloc.add(RefreshRekanPicCobCariEvent(
        rekanPicId: widget.mrekanpicId,
        searchText: '',
      ));
    });

    if (widget.initJabatanModel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final items = await _loadJabatan();
        final initId = (widget.initJabatanModel!.mjabatanId ?? '').trim();
        final found = items.firstWhere(
              (e) => (e.mjabatanId ?? '').trim() == initId,
          orElse: () => widget.initJabatanModel!,
        );
        setState(() => _jabatan = found);
        _comboKey.currentState?.changeSelectedItem(found);
      });
    }
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
    if (!(_formKey.currentState?.validate() ?? false)) return;

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
      return;
    }

    setState(() => _saving = true);

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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                const SnackBar(
                    content: Text('Gagal menyimpan perubahan. Coba lagi.')),
              );
            }
          },
          child: BaseBackgroundSidePage(
            title: 'Edit PIC',
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Container(
                    width: double.infinity,
                    color: secondaryBlackColor, // 🔹 background full tinggi
                    constraints:
                    BoxConstraints(minHeight: constraints.maxHeight),
                    padding: EdgeInsets.symmetric(
                      horizontal: hPadding * 1.5,
                      vertical: 20,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Card(
                          color: formGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(cardBorderRadius),
                            side: const BorderSide(color: sGrey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: _formKey,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Form Edit PIC',
                                    style:
                                    headingStyle(context, fontSize: 20),
                                  ),
                                  const SizedBox(height: 12),

                                  appTextField(
                                    label: 'Nama PIC',
                                    controller: _nama,
                                    validator: (v) => (v == null ||
                                        v.trim().isEmpty)
                                        ? kNameNullError
                                        : null,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: hPadding),

                                  appTextField(
                                    label: 'Email',
                                    controller: _email,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: _emailValidator,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: hPadding),
                                  appTextField(
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
                                  ),
                                  const SizedBox(height: hPadding),

                                  // Jabatan
                                  ReusableComboBox<ComboMJabatanModel>(
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
                                    onSaveCallback: (val) =>
                                    _jabatan = val,
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
                                      // 🔹 Buka halaman multi-select COB (mode UBAH)
                                      final selectedCobs = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                            create: (_) => RekanPicCobCariBloc(),
                                            child: RekanPicCobCariPage(
                                              rekanPicId: widget.mrekanpicId, // ID PIC valid
                                              viewMode: 'ubah',
                                            ),
                                          ),
                                        ),
                                      );

                                      // 🔹 Setelah kembali dari halaman pilih COB
                                      if (selectedCobs != null && selectedCobs.isNotEmpty) {
                                        setState(() {
                                          _selectedCobList = selectedCobs; // update daftar lokal (tampilan)
                                        });
                                        debugPrint("✅ Daftar COB diperbarui untuk ${widget.mrekanpicId}");
                                      }
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // 🧩 Icon kiri (pakai SVG list_cob_icon)
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

                                        // 📋 Konten teks & daftar chip COB
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

                                              if (_selectedCobList == null || _selectedCobList!.isEmpty)
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
                                                  children: _selectedCobList!
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

                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: _saving
                                              ? null
                                              : () => Navigator.pop(
                                              context, false),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            backgroundColor:
                                            sGrey.withOpacity(0.25),
                                            foregroundColor: primaryLightColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  cardBorderRadius),
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
                                                vertical: 12),
                                            backgroundColor: primaryColor,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  cardBorderRadius),
                                            ),
                                          ),
                                          child: _saving
                                              ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child:
                                            CircularProgressIndicator(
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
