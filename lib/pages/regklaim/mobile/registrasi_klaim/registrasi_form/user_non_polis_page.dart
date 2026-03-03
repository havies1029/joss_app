import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/polis_detail/upload_section_widget.dart';

import '../../../../../blocs/gen_regmv/polis_tanggal_bloc.dart';
import '../../../../../blocs/gen_regmv/polis_tanggal_event.dart';
import '../../../../../blocs/gen_regmv/polis_tanggal_state.dart';
import '../../../../../blocs/regklaim/attach_bloc.dart';
import '../../../../../blocs/regklaim/regklaim1crud_bloc.dart';
import '../../../../../common/app_data.dart';
import '../../../../../common/constants.dart';
import '../../../../../models/combobox/combominsurance_model.dart';
import '../../../../../models/regklaim/attachment_item.dart';
import '../../../../../models/regklaim/regklaim1crud_model.dart';
import '../../../../../models/user/user_model.dart';
import '../../../../../repositories/combobox/combominsurance_repository.dart';
import '../../../../../repositories/regklaim/picker_repository.dart';
import '../../../../../repositories/regklaim/upload_repository.dart';
import 'package:joss_app/pages/regklaim/mobile/main_page/klaim_main_page.dart';

import '../../../../../widgets/apptheme/register_client_pop_up.dart';
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

  final fieldInsuredNamaController = TextEditingController();
  ComboMInsuranceModel? fieldComboMInsurance;
  final comboMInsuranceKey = GlobalKey<DropdownSearchState<ComboMInsuranceModel>>();
  final fieldPolisAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
  final fieldPolisMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
  final fieldPolisNoController = TextEditingController();
  final fieldLokasiObjectController = TextEditingController();
  bool _toKlaimTriggered = false;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      context.read<PolisTanggalBloc>().add(PolisMulaiChanged(today));
    });
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
            listenWhen: (prev, curr) => prev.isSaved != curr.isSaved,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Simpan",
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
                    const SizedBox(height: hPadding),
                    buildFieldLokasiResiko(),
                    const SizedBox(height: hPadding),

                    UploadSectionWidget(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: "Masukkan Data Polis",
                  onPressed: onPressCariPolis,
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
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text("Lampiran wajib diisi minimal 1 file/foto")),
        );
      return;
    }

    final record = Regklaim1CrudModel(
      insuredNama: fieldInsuredNamaController.text,
      lokasiObject: fieldLokasiObjectController.text,
      minsuranceId: fieldComboMInsurance?.minsuranceId,
      polisAkhir: polis.berakhir,
      polisMulai: polis.mulai,
      polisNo: fieldPolisNoController.text,
      regklaim1Id: regklaim1Id,
    );

    if (context.read<AuthenticationBloc>().state is AuthenticationAuthenticated) {
      User user = (context.read<AuthenticationBloc>().state as AuthenticationAuthenticated).user;
      if (user.userType == "C"){
        if (regklaim1Id.isNotEmpty) {
          regklaim1formBloc.add(Regklaim1CrudUbahEvent(record: record));
        } else {
          regklaim1formBloc.add(Regklaim1CrudTambahEvent(record: record));
        }
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Only Client user can perform this action.'),
          ),
        );
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

    final noPolis = fieldPolisNoController.text.trim();
    if (noPolis.isEmpty) {
      setErr('form1.noPolis', kStringNullError);
      ok = false;
    }

    final nama = fieldInsuredNamaController.text.trim();
    if (nama.isEmpty) {
      setErr('form1.namaTertanggung', kStringNullError);
      ok = false;
    }

    final lokasi = fieldLokasiObjectController.text.trim();
    if (lokasi.isEmpty) {
      setErr('form1.alamatTertanggung', kAddressNullError);
      ok = false;
    }

    final tglMulai = context.read<PolisTanggalBloc>().state.mulai;

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

  Widget buildFieldMinsuranceId() => ReusableComboBox<ComboMInsuranceModel>(
    hintText: "Kategori Asuransi",
    initItem: fieldComboMInsurance,
    dataLoader: () async {
      final data = await ComboMInsuranceRepository().getComboMInsurance("");
      return _filterInsurance(data);
    },
    displayText: (item) => item.insuranceName,
    compareItems: (a, b) => a.minsuranceId == b.minsuranceId,
    validatorCallback: (_) => err('form1.kategoryInsurance'),
    errorText: err('form1.kategoryInsurance'),
    onChangedCallback: (v) {
      fieldComboMInsurance = v;
      if (v != null) clearErr('form1.kategoryInsurance');
    },
    onSaveCallback: (value) => fieldComboMInsurance = value,
  );

  Widget buildFieldPolisNo() => appTextField(
    label: "No Polis",
    controller: fieldPolisNoController,
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
    ],
    errorText: err('form1.noPolis'),
    validator: (_) => err('form1.noPolis'),
    onChanged: (v) {
      if (v.trim().isNotEmpty) clearErr('form1.noPolis');
    },
  );

  Widget buildFieldPolisMulai() {
    return BlocBuilder<PolisTanggalBloc, PolisTanggalState>(
      buildWhen: (prev, curr) => prev.mulai != curr.mulai,
      builder: (context, state) {
        final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

        return AppDateField(
          label: 'Tanggal Mulai',
          initialValue: state.mulai,
          firstDate: today,
          lastDate: DateTime(2100),
          validator: (_) => null,
          onChanged: (dt) {
            if (dt == null) return;
            context.read<PolisTanggalBloc>().add(PolisMulaiChanged(dt));
          },
        );
      },
    );
  }

  Widget buildFieldPolisBerakhir() {
    return BlocBuilder<PolisTanggalBloc, PolisTanggalState>(
      buildWhen: (prev, curr) => prev.berakhir != curr.berakhir,
      builder: (context, state) {
        return AppDateField(
          key: ValueKey(state.berakhir.toIso8601String()),
          label: 'Tanggal Berakhir',
          enabled: false,
          initialValue: state.berakhir,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          validator: (_) => null,
          onChanged: (_) {},
        );
      },
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

  Widget buildFieldLokasiResiko() => appTextField(
    label: "Lokasi Risiko",
    controller: fieldLokasiObjectController,
    maxLines: 4,
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
    ],
    errorText: err('form1.alamatTertanggung'),
    validator: (_) => err('form1.alamatTertanggung'),
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
