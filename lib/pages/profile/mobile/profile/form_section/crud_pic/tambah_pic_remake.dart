import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';
import 'package:joss_app/repositories/combobox/combomjabatan_repository.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';

import '../../../../../../blocs/gen_invite/invite_bloc.dart';
import '../../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../../blocs/reguser/reguser_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../../../../../repositories/gen_profile/rekanpiccobcari_repository.dart';
import '../../../../../../widgets/apptheme/invite_success_popup.dart';
import '../../../../../base/base_background_sidepage.dart';
import '../../../../../gen_profile/common/rekanpiccobcari_list.dart';

class TambahPicWidget extends StatefulWidget {
  const TambahPicWidget({super.key});

  @override
  State<TambahPicWidget> createState() => _TambahPicWidgetState();
}

class _TambahPicWidgetState extends State<TambahPicWidget> {
  List< RekanPicCobCariModel> _pendingCobList = [];
  late final MRekanPicCrudBloc crudBloc;
  final List<String> errors = [];

  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _hp = TextEditingController();

  final _comboKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();
  ComboMJabatanModel? _jabatan;

  bool _isDefault = false;
  bool _saving = false;
  bool _sendingInvite = false;
  bool _inviteEnabled = false;
  bool _savedOnce = false;

  bool _showErrors = false;
  final bool _showInviteWarning = false;


  @override
  void initState() {
    super.initState();
    crudBloc = context.read<MRekanPicCrudBloc>();
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _hp.dispose();
    super.dispose();
  }

  void _save() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      if (!_showErrors) setState(() => _showErrors = true);
      return;
    }

    final mjnsclientId = context.select((RegUserBloc b) => b.state.record?.jnsClientId);

    final idJabatan = (mjnsclientId == '10')
        ? ''
        : (_jabatan?.mjabatanId.trim().isEmpty ?? true)
        ? ''
        : _jabatan!.mjabatanId.trim();

    if (_pendingCobList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih minimal 1 COB sebelum menyimpan.')),
      );
      // debugPrint('⚠ [VALIDATION] User belum memilih COB — simpan dibatalkan.');
      return;
    }

    setState(() => _saving = true);

    final record = MRekanPicCrudModel(
      picNama: _nama.text.trim(),
      picEmail: _email.text.trim().toLowerCase(),
      picHp: _hp.text.trim(),
      mjabatanId: idJabatan,
      isDefault: _isDefault,
    );

    context.read<MRekanPicCrudBloc>().add(
      MRekanPicCrudTambahEvent(record: record),
    );

    setState(() {
      _saving = false;
      _savedOnce = true;
      _inviteEnabled = true;
    });
  }





  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            // Listener untuk CRUD PIC
            BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
              listener: (context, state) async {
                if (state.hasFailure == true) {
                  setState(() => _saving = false);
                }

                if(state.isSaved == true){
                  try {
                    final picId = (state.savedId ?? '').trim();
                    final cobRepo = RekanPicCobCariRepository();

                    final listCheckbox = _pendingCobList.map((e) =>
                        RekanPicCobCariCheckboxModel(
                          mcobId: e.mcobId,
                          isChecked: e.isChecked,
                        ),
                    ).toList();


                    final cobResult = await cobRepo.rekanPicCobUpdateList(picId, listCheckbox);

                    if (cobResult.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('PIC & ${listCheckbox.length} COB berhasil disimpan!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('PIC tersimpan, tapi gagal update COB.')),
                      );
                    }
                  } catch (e) {
                    debugPrint('💥 [ERROR] Gagal kirim pending COB: $e');
                  }
                }
              },
            ),


            // Listener untuk undangan
            BlocListener<InviteBloc, InviteState>(
              listener: (context, state) async {
                if (state.isLoading) {
                  setState(() => _sendingInvite = true);
                } else {
                  setState(() => _sendingInvite = false);
                }

                if (state.isSuccess) {
                  await showDialog(
                    context: context,
                    builder: (_) => const InviteSuccessPopup(),
                  );
                  if (context.mounted) Navigator.pop(context, true);
                } else if (state.message.isNotEmpty && !state.isLoading) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            ),
          ],
          child: BaseBackgroundSidePage(
            title: 'Tambah PIC',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final mjnsclientId = context.select((RegUserBloc b) => b.state.record?.jnsClientId);

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

                            // === CARD FORM ===
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
                                        style:
                                        headingStyle(context, fontSize: 20),
                                      ),
                                      const SizedBox(height: vPadding),

                                      // === INPUT FIELD ===
                                      buildFieldRekanNama(),

                                      const SizedBox(height: vPadding),

                                      buildFieldEmail(),

                                      const SizedBox(height: vPadding),

                                      buildFiledTelp(),

                                      const SizedBox(height: vPadding),


                                      if (mjnsclientId != '10')
                                         buildFieldJabatan(),

                                      const SizedBox(height: vPadding),

                                      CheckboxListTile(
                                        value: _isDefault,
                                        onChanged: (v) => setState(
                                                () => _isDefault = v ?? false),
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

                                      const SizedBox(height: hPadding),

                                      GestureDetector(
                                        onTap: () async {
                                          final selectedCobs =
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => BlocProvider(
                                                create: (_) =>
                                                    RekanPicCobCariBloc(),
                                                child: RekanPicCobCariPage(
                                                  rekanPicId: '0',
                                                  viewMode: 'tambah',
                                                ),
                                              ),
                                            ),
                                          );
                                          if (selectedCobs != null &&
                                              selectedCobs.isNotEmpty) {
                                            setState(() {
                                              _pendingCobList = selectedCobs;
                                            });
                                          }
                                        },
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
                                                        fontSize: 13),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  if (_pendingCobList.isEmpty)
                                                    const Text(
                                                      'Pilih Daftar COB',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontSize: 15,
                                                      ),
                                                    )
                                                  else
                                                    Wrap(
                                                      spacing: 6,
                                                      runSpacing: 6,
                                                      children: _pendingCobList
                                                          .map(
                                                            (e) => Container(
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              10,
                                                              vertical: 6),
                                                          decoration:
                                                          BoxDecoration(
                                                            color: const Color(
                                                                0xFFFF9D00),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                8),
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
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      // === TOMBOL AKSI ===
                                      Row(
                                        children: [
                                          // Simpan
                                          Expanded(
                                            child: TextButton(
                                              onPressed: _saving || _savedOnce
                                                  ? null
                                                  : _save,
                                              style: TextButton.styleFrom(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 12),
                                                backgroundColor: _savedOnce
                                                    ? Colors.grey
                                                    : primaryColor,
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
                                                  color: Colors.white,
                                                ),
                                              )
                                                  : Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/save_btn_pic.svg',
                                                    height: 18,
                                                    colorFilter:
                                                    const ColorFilter
                                                        .mode(
                                                      Colors.white,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                  SizedBox(width: hPadding),
                                                  Text(
                                                    _savedOnce
                                                        ? 'Tersimpan'
                                                        : 'Simpan',
                                                    style: TextStyle(
                                                      fontSize:
                                                      getResponsiveFont(
                                                          context, 16),
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          // Kirim Undangan
                                          Expanded(
                                            child: BlocBuilder<InviteBloc,
                                                InviteState>(
                                              builder: (context, inviteState) {
                                                return TextButton(
                                                  onPressed: !_inviteEnabled
                                                      ? () {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Simpan dahulu sebelum kirim undangan.'),
                                                        backgroundColor:
                                                        Colors.redAccent,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      ),
                                                    );
                                                  }
                                                      : inviteState.isLoading
                                                      ? null
                                                      : () {
                                                    final mrekan1Id =
                                                        context.read<MRekan1CrudBloc>().state.record?.mrekan1Id ?? "";

                                                    final email = _email
                                                        .text
                                                        .trim()
                                                        .toLowerCase();

                                                    context
                                                        .read<
                                                        InviteBloc>()
                                                        .add(SendInviteEvent(
                                                        userId:
                                                        mrekan1Id,
                                                        email:
                                                        email));
                                                  },
                                                  style: TextButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 12),
                                                    backgroundColor:
                                                    _inviteEnabled
                                                        ? sBlue
                                                        : Colors.grey,
                                                    foregroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          cardBorderRadius),
                                                    ),
                                                  ),
                                                  child: inviteState.isLoading
                                                      ? const SizedBox(
                                                    width: 18,
                                                    height: 18,
                                                    child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors
                                                            .white),
                                                  )
                                                      : Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/icons/send_btn_pic.svg',
                                                        height: 18,
                                                        colorFilter:
                                                        const ColorFilter
                                                            .mode(
                                                          Colors.white,
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: hPadding),
                                                      const Text(
                                                        'Kirim Undangan',
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w600),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
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