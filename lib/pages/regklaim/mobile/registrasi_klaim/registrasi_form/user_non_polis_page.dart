import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/polis_detail/upload_section_widget.dart';

import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import '../../../../../blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import '../../../../../blocs/gen_regmv/polis_tanggal_bloc.dart';
import '../../../../../blocs/gen_regmv/polis_tanggal_event.dart';
import '../../../../../blocs/gen_regmv/polis_tanggal_state.dart';
import '../../../../../blocs/regklaim/attach_bloc.dart';
import '../../../../../blocs/regklaim/polissourcecari_bloc.dart';
import '../../../../../blocs/regklaim/regklaim1crud_bloc.dart';
import '../../../../../common/app_data.dart';
import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../common/plat_nomor_formatter.dart';
import '../../../../../models/combobox/combominsurance_model.dart';
import '../../../../../models/combobox/combomjenisrugimv_model.dart';
import '../../../../../models/regklaim/attachment_item.dart';
import '../../../../../models/regklaim/regklaim1crud_model.dart';
import '../../../../../models/user/user_model.dart';
import '../../../../../repositories/combobox/combominsurance_repository.dart';
import '../../../../../repositories/combobox/combomjenisrugimv_repository.dart';
import '../../../../../repositories/regklaim/picker_repository.dart';
import '../../../../../repositories/regklaim/upload_repository.dart';
import 'package:joss_app/pages/regklaim/mobile/main_page/klaim_main_page.dart';

import '../../../../../widgets/apptheme/dropdown2.dart';
import '../../../../../widgets/apptheme/register_client_pop_up.dart';
import '../../../../profile/mobile/profile/form_section/popup/rekan_general_cmp.dart';
import '../../../../profile/mobile/profile/form_section/popup/rekan_general_idv.dart';
import '../../../../register/mobile/client/register_client_page.dart';
import '../../../../tagihan_pembayaran/mobile/payment_page/payment_success/payment_success.dart';

class UserNonPolisPage extends StatefulWidget {
  final String cobKlaimId;
  final String cobKlaimNama;

  const UserNonPolisPage({
    super.key,
    required this.cobKlaimId,
    required this.cobKlaimNama,
  });

  @override
  State<UserNonPolisPage> createState() => _UserNonPolisPageState();
}

class _UserNonPolisPageState extends State<UserNonPolisPage> {
  String regklaim1Id = "";
  late Regklaim1CrudBloc regklaim1formBloc;
  late final Dio _dio;
  late final AttachBloc _attachBloc;
  bool _isCariPolisLoading = false;

  final fieldInsuredNamaController = TextEditingController();
  ComboMInsuranceModel? fieldComboMInsurance;
  final comboMInsuranceKey = GlobalKey<DropdownSearchState<ComboMInsuranceModel>>();
  final fieldPolisAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
  final fieldPolisMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
  final fieldPolisNoController = TextEditingController();
  final fieldLokasiObjectController = TextEditingController();
  ComboMJenisrugimvModel? fieldComboMJenisrugimv;

  late Future<List<ComboMJenisrugimvModel>> _futureJenisKerugian;

  final comboMJenisrugimvKey =
  GlobalKey<DropdownSearchState<ComboMJenisrugimvModel>>();

  DateTime? fieldPolisMulai;
  DateTime? fieldPolisBerakhir;

  bool _toKlaimTriggered = false;

  late MRekanGeneralCmpCrudBloc mRekanGeneralCmpCrudBloc;
  late MRekanGeneralIdvCrudBloc mRekanGeneralIdvCrudBloc;
  bool _insuranceInitialized = false;


  Color get _submitButtonColor {
    if (widget.cobKlaimId == '10002') return pBlue;
    if (widget.cobKlaimId == '10001') return pGreen2;
    return sGrey;
  }

  Future<void> _initDefaultInsurance() async {
    if (!_isAutoInsurance || _insuranceInitialized) return;

    final data = await ComboMInsuranceRepository().getComboMInsurance("");
    final filtered = _filterInsurance(data);

    if (!mounted) return;

    if (filtered.isNotEmpty) {
      setState(() {
        fieldComboMInsurance = filtered.first;
        _insuranceInitialized = true;
      });
      clearErr('form1.kategoryInsurance');
    }
  }

  @override
  void initState() {
    super.initState();
    regklaim1formBloc = context.read<Regklaim1CrudBloc>();

    _dio = Dio(BaseOptions(
      baseUrl: AppData.apiDomain,
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ${AppData.userToken}',
      },
    ));

    _attachBloc = AttachBloc(
      pickerRepo: PickerRepositoryImpl(),
      uploadRepo: UploadRepositoryImpl(_dio),
    );

    _futureJenisKerugian =
        ComboMJenisrugimvRepository().getComboMJenisrugimv();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final now = DateTime.now();
    //   final today = DateTime(now.year, now.month, now.day);
    //   context.read<PolisTanggalBloc>().add(PolisMulaiChanged(today));
    // });

    mRekanGeneralIdvCrudBloc = context.read<MRekanGeneralIdvCrudBloc>();
    mRekanGeneralCmpCrudBloc = context.read<MRekanGeneralCmpCrudBloc>();

    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mjenisClient == "10") {
        mRekanGeneralIdvCrudBloc.add(MRekanGeneralIdvCrudLihatEvent());
      }else if (mjenisClient == "20"){
        mRekanGeneralCmpCrudBloc.add(MRekanGeneralCmpCrudLihatEvent());
      }
    });

    _initDefaultInsurance();
  }

  @override
  void dispose() {
    _attachBloc.close();
    fieldInsuredNamaController.dispose();
    fieldPolisAkhirController.dispose();
    fieldPolisMulaiController.dispose();
    fieldPolisNoController.dispose();
    fieldLokasiObjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _attachBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<Regklaim1CrudBloc, Regklaim1CrudState>(
            listenWhen: (prev, curr) => curr.isSaved,
            listener: (context, state) {
              if (!mounted) return;
              if (state.hasFailure) return;

              if (_toKlaimTriggered) return;
              _toKlaimTriggered = true;

              final id = state.regklaim1Id;
              final attachBloc = context.read<AttachBloc>();

              for (final item in attachBloc.state.items) {
                if (item.status == UploadStatus.queued) {
                  attachBloc.add(UploadOne(localId: item.localId, regklaim1Id: id));
                }
              }

              regklaim1formBloc.add(RegklaimToKlaimEvent(regklaim1Id: id));

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PaymentSuccess(
                    displayButton: "Kembali",
                    description:
                    "Departemen kami akan segera menghubungi kamu untuk menindaklanjuti klaim ini.",
                    display: "Klaim Kamu Berhasil Didaftarkan!",
                    onButtonPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const KlaimMainPage()),
                            (route) => route.isFirst,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: vPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: pGrey,
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Cari Data Polis",
                      style: TextStyle(
                        color: primaryLightColor,
                        fontSize: getResponsiveFont(context, 18),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: hPadding),
                    buildFieldMinsuranceId(),
                    const SizedBox(height: hPadding),
                    buildFieldPolisNo(),
                    const SizedBox(height: hPadding),
                    Row(
                      children: [
                        Flexible(child: buildFieldPolisMulai()),
                        const SizedBox(width: hPadding),
                        Flexible(child: buildFieldPolisBerakhir()),
                      ],
                    ),
                    const SizedBox(height: hPadding),
                    buildFieldInsuredNama(),
                    if (widget.cobKlaimId == '10002') ...[
                      const SizedBox(height: hPadding),
                      buildFieldJenisKerugian(),
                    ],
                    const SizedBox(height: hPadding),
                    buildFieldLokasiResiko(),
                    const SizedBox(height: hPadding),
                    UploadSectionWidget(),
                  ],
                ),
              ),
              const SizedBox(height: vPadding),
              SizedBox(
                width: double.infinity,
                child: AppButton.primary(
                  text: "Masukan Data Polis",
                  isLoading: _isCariPolisLoading,
                  backgroundColor:
                  _isCariPolisLoading ? secondaryBlackColor : _submitButtonColor,
                  onPressed: _isCariPolisLoading
                      ? null
                      : () async {
                    setState(() {
                      _isCariPolisLoading = true;
                    });

                    onPressCariPolis();

                    await Future.delayed(const Duration(seconds: 2));

                    if (mounted) {
                      setState(() {
                        _isCariPolisLoading = false;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressCariPolis() {
    final polis = context.read<PolisTanggalBloc>().state;

    final attachState = _attachBloc.state;

    final ok = validateForm1();
    if (!ok) return;

    if (attachState.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar('Lampiran wajib diisi minimal 1 file/foto'));
      return;
    }

    final record = Regklaim1CrudModel(
      insuredNama: fieldInsuredNamaController.text.trim(),
      lokasiObject: fieldLokasiObjectController.text.trim(),
      minsuranceId: fieldComboMInsurance?.minsuranceId ?? '',
      polisAkhir: fieldPolisBerakhir,
      polisMulai: fieldPolisMulai,
      polisNo: fieldPolisNoController.text.trim(),
      mjenisrugimvId: widget.cobKlaimId == '10002'
          ? fieldComboMJenisrugimv?.mjenisrugimvId ?? ''
          : '',
      regklaim1Id: regklaim1Id,
    );

    final mjenisClient =
        context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;

    if (context.read<AuthenticationBloc>().state is AuthenticationAuthenticated) {
      User user = (context.read<AuthenticationBloc>().state as AuthenticationAuthenticated).user;
      if (user.userType == "C"){
        if (mjenisClient == "10") {
          final idvState = context.read<MRekanGeneralIdvCrudBloc>().state;

          if (!idvState.isDataComplete) {
            showDialog(
              context: context,
              barrierDismissible: true,
              barrierColor: Colors.black.withOpacity(0.6),
              builder: (context) => RegisterClientPopUp(
                header: 'Isi Data Pribadi Anda',
                description:
                'Lengkapi data pribadi Anda terlebih dahulu untuk melanjutkan proses ini.',
                buttonText: 'Lengkapi Data Pribadi',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MRekanGeneralIdvPopUpPage(),
                    ),
                  );
                },
              ),
            );
            return;
          }
        }
        else if (mjenisClient == "20") {
          final cmpState = context.read<MRekanGeneralCmpCrudBloc>().state;

          if (!cmpState.isDataComplete) {
            showDialog(
              context: context,
              barrierDismissible: true,
              barrierColor: Colors.black.withOpacity(0.6),
              builder: (context) => RegisterClientPopUp(
                header: 'Isi Data Pribadi Anda',
                description:
                'Lengkapi data pribadi Anda terlebih dahulu untuk melanjutkan proses ini.',
                buttonText: 'Lengkapi Data Pribadi',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MRekanGeneralCmpPopUpPage(),
                    ),
                  );
                },
              ),
            );
            return;
          }
        }
        if (regklaim1Id.isNotEmpty) {
          regklaim1formBloc.add(Regklaim1CrudUbahEvent(record: record));
        } else {
          regklaim1formBloc.add(Regklaim1CrudTambahEvent(record: record));
        }
      }
      else {
        showDialog(
          context: context,
          barrierDismissible: true, // klik luar = close
          barrierColor: Colors.black.withOpacity(0.6), // background gelap transparan
          builder: (context) => RegisterClientPopUp(
            header: 'Data Klien Belum Terdaftar!',
            description:
            'Untuk melanjutkan ke proses Klaim Baru, Anda perlu mendaftarkan data klien terlebih dahulu.',
            buttonText: 'Daftar Klien',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterClient(requestFrom: 'regisnonpolis_page')
                ),
              );
            },
          ),
        );
      }
    }
  }

  bool validateForm1() {
    clearErrsByPrefix('form1.');
    bool ok = true;

    if (fieldComboMInsurance == null) {
      setErr('form1.kategoryInsurance', kStringNullError);
      ok = false;
    }

    // final noPolis = fieldPolisNoController.text.trim();
    // if (noPolis.isEmpty) {
    //   setErr('form1.noPolis', kStringNullError);
    //   ok = false;
    // }

    final nama = fieldInsuredNamaController.text.trim();
    if (nama.isEmpty) {
      setErr('form1.namaTertanggung', kStringNullError);
      ok = false;
    }

    if (widget.cobKlaimId == '10002' && fieldComboMJenisrugimv == null) {
      setErr('form1.jenisKerugian', kStringNullError);
      ok = false;
    }

    if (fieldLokasiObjectController.text.trim().isEmpty) {
      setErr(
        'form1.alamatTertanggung',
        widget.cobKlaimId == '10002'
            ? 'Nomor Polisi wajib diisi'
            : kAddressNullError,
      );
      ok = false;
    }

    return ok;
  }

  List<ComboMInsuranceModel> _filterInsurance(
      List<ComboMInsuranceModel> data,
      ) {
    // 10001 → hanya tampil 14
    if (widget.cobKlaimId == '10001') {
      return data.where((e) => e.minsuranceId == '14').toList();
    }

    // 10002 → hanya tampil 02
    if (widget.cobKlaimId == '10002') {
      return data.where((e) => e.minsuranceId == '02').toList();
    }

    // selain itu → buang 14 & 02
    return data
        .where((e) => e.minsuranceId != '14' && e.minsuranceId != '02')
        .toList();
  }

  bool get _isAutoInsurance =>
      widget.cobKlaimId == '10001' || widget.cobKlaimId == '10002';

  static const _priorityInsuranceIds = [
    '21',
    '17',
    '47',
    '52',
    '03',
    '46',
    // '??', // jiwa
  ];

  Widget buildFieldMinsuranceId() => ReusableComboBoxV2<ComboMInsuranceModel>(
    key: ValueKey('minsurance_${widget.cobKlaimId}'),
    hintText: "Kategori Asuransi",
    comboKey: comboMInsuranceKey,
    initItem: fieldComboMInsurance,
    isEnabled: !_isAutoInsurance,
    useScrollableShowMorePopup: true,
    initialVisibleCount: _priorityInsuranceIds.length,
    expandText: (count) => "Lihat $count Kategori Lainnya",
    collapseText: "Tampilkan Lebih Sedikit",
    loader: (q) async {
      final data = await ComboMInsuranceRepository().getComboMInsurance(
        q.searchText,
      );
      return _filterInsurance(data);
    },

    clientSideSearch: true,

    displayText: (item) => item.insuranceName,
    compareItems: (a, b) => a.minsuranceId == b.minsuranceId,

    errorText: err('form1.kategoryInsurance'),

    validatorCallback: (value) {
      if (value == null) {
        return kStringNullError;
      }
      return null;
    },

    onChangedCallback: (v) {
      setState(() {
        fieldComboMInsurance = v;

        if (v != null) {
          clearErr('form1.kategoryInsurance');
        }
      });
    },

    onSaveCallback: (value) {
      fieldComboMInsurance = value;
    },
  );

  Widget buildFieldPolisNo() => appTextField(
    label: "No Polis",
    controller: fieldPolisNoController,
    keyboardType: TextInputType.text,
    errorText: err('form1.noPolis'),
    // validator: (_) => err('form1.noPolis'),
    validator: (_) => null,
    onChanged: (v) {
      if (v.trim().isNotEmpty) clearErr('form1.noPolis');
    },
  );

  Widget buildFieldPolisMulai() {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    return AppDateField(
      label: 'Tanggal Mulai',
      initialValue: fieldPolisMulai,
      firstDate: today,
      lastDate: DateTime(2100),
      validator: (_) => null,
      onChanged: (dt) {
        setState(() {
          fieldPolisMulai = dt;

          if (dt == null) {
            fieldPolisBerakhir = null;
          } else {
            fieldPolisBerakhir = DateTime(
              dt.year + 1,
              dt.month,
              dt.day,
            );
          }
        });
      },
    );
  }

  Widget buildFieldPolisBerakhir() {
    return AppDateField(
      key: ValueKey(fieldPolisBerakhir?.toIso8601String() ?? 'empty'),
      label: 'Tanggal Berakhir',
      enabled: false,
      initialValue: fieldPolisBerakhir,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      validator: (_) => null,
      onChanged: (_) {},
    );
  }

  Widget buildFieldInsuredNama() => appTextField(
    label: "Nama Tertanggung",
    controller: fieldInsuredNamaController,
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
    ],
    errorText: err('form1.namaTertanggung'),
    validator: (_) => err('form1.namaTertanggung'),
    onChanged: (v) {
      if (v.trim().isNotEmpty) clearErr('form1.namaTertanggung');
    },
  );

  Widget buildFieldJenisKerugian() {
    return FutureBuilder<List<ComboMJenisrugimvModel>>(
      future: _futureJenisKerugian,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final jenisKerugianList = snapshot.data ?? [];

        if (jenisKerugianList.isEmpty) {
          return const Text('Tidak ada data jenis kerugian');
        }

        return FormField<ComboMJenisrugimvModel>(
          initialValue: fieldComboMJenisrugimv,
          validator: (_) {
            if (widget.cobKlaimId == '10002' &&
                fieldComboMJenisrugimv == null) {
              return kStringNullError;
            }
            return null;
          },
          builder: (fieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jenis Kerugian',
                  style: bodyTextStyle(context, fontSize: getResponsiveFont(context, 18)),
                ),
                const SizedBox(height: hPadding),
                Row(
                  children: jenisKerugianList.map((item) {
                    final isSelected =
                        fieldComboMJenisrugimv?.mjenisrugimvId ==
                            item.mjenisrugimvId;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            fieldComboMJenisrugimv = item;
                          });

                          fieldState.didChange(item);
                          clearErr('form1.jenisKerugian');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? primaryColor : hintGrey,
                                  width: 1,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                  ),
                                ),
                              )
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                item.jenisrugiNama,
                                overflow: TextOverflow.ellipsis,
                                style: isSelected
                                    ? inputTextStyle(context)
                                    : bodyTextStyle(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: hPadding),
                if (fieldState.hasError || err('form1.jenisKerugian') != null)
                  Text(
                    fieldState.errorText ?? err('form1.jenisKerugian') ?? '',
                    style: const TextStyle(color: pRed, fontSize: 12),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildFieldLokasiResiko() => appTextField(
    label: widget.cobKlaimId == '10002'
        ? "Nomor Polisi"
        : "Lokasi Risiko",
    controller: fieldLokasiObjectController,
    maxLines: widget.cobKlaimId == '10002' ? 1 : 4,
    keyboardType: TextInputType.text,
    inputFormatters: widget.cobKlaimId == '10002'
        ? [
      PlatNomorFormatter(),
    ]
        : [
      FilteringTextInputFormatter.allow(
        RegExp(r"[0-9a-zA-Z ,./\-#()]"),
      ),
    ],
    errorText: err('form1.alamatTertanggung'),
    // validator: (_) => err('form1.alamatTertanggung'),
    validator: (_) => null,
    onChanged: (v) {
      if (v.trim().isNotEmpty) clearErr('form1.alamatTertanggung');
    },
  );

  final Map<String, String?> fieldErrors = {};
  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }

  void clearErrsByPrefix(String prefix) {
    setState(() {
      fieldErrors.removeWhere((k, _) => k.startsWith(prefix));
    });
  }
}