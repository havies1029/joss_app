import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/pages/management_polis/mobile/theme/polis_success.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';

import '../../../../blocs/asetothers/asetotherscari_bloc.dart';
import '../../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../blocs/regrenewal/regrenew1form_bloc.dart';
import '../../../../models/regrenewal/regrenew1form_model.dart';
import '../../detail_management_page/detail_management_widget.dart';


class RenewalFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;
  final String polisId;
  final String cobId;
  final String? pageTitle;

  const RenewalFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    required this.polisId,
    required this.cobId,
    this.pageTitle,
  });


  @override
  RenewalFormPageFormState createState() => RenewalFormPageFormState();
}

class RenewalFormPageFormState extends State<RenewalFormPage> {
  late Regrenew1FormBloc regrenewal1FormBloc;
  late MRekan1CrudBloc mrekan1crudbloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldEndorsTglController = TextEditingController(text: DateTime.now().toIso8601String());
  var fieldInsuredNamaController = TextEditingController();
  var fieldMstsendorsIdController = TextEditingController();
  var fieldNoteKonfirmasiController = TextEditingController();
  var fieldNotePerubahanController = TextEditingController();
  var fieldPeriodeAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
  var fieldPeriodeMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
  var fieldPremiController = TextEditingController();
  var fieldSppa1IdController = TextEditingController();
  var fieldStatusEndorsController = TextEditingController();
  var fieldTsiController = TextEditingController();

  dynamic _selectedItemByCob(BuildContext context, String cobId) {
    return switch (cobId) {
      "10002" => context.read<AsetParCariBloc>().state.selectedItem,
      "10003" => context.read<AsetMvCariBloc>().state.selectedItem,
      "10004" => context.read<AsethullCariBloc>().state.selectedItem,
      "10005" => context.read<AsetHealthCariBloc>().state.selectedItem,
      "10006" => context.read<AsetothersCariBloc>().state.selectedItem,
      _ => null,
    };
  }

  @override
  void initState() {
    super.initState();
    mrekan1crudbloc = context.read<MRekan1CrudBloc>();
    regrenewal1FormBloc = context.read<Regrenew1FormBloc>();
  }

  @override
  Widget build(BuildContext context) {
    regrenewal1FormBloc = BlocProvider.of<Regrenew1FormBloc>(context);

    return BlocConsumer<Regrenew1FormBloc, Regrenew1FormState>(
      builder: (context, state) {
        return BaseBackgroundSidePage(
          title: 'Perpanjangan Polis',
          child: Scaffold(
            backgroundColor: secondaryBlackColor,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: hPadding * 1.5,
                vertical: 10,
              ),
              child: AppButton.primary(
                text: 'Ajukan Perubahan',
                backgroundColor: primaryColor,
                onPressed: () {
                  final okForm1 = validateForm1();
                  if (!okForm1) {
                    return;
                  }else {
                    _showPengajuanDialog(context);
                  }
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: hPadding * 1.5,
                  vertical: 10,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Isi deskripsi perubahan untuk membantu tim kami memverifikasi permintaan Anda.",
                        style: bodyTextStyle(context).copyWith(
                          color: primaryLightColor,
                          fontSize: getResponsiveFont(context, 16),
                        ),
                      ),

                      const SizedBox(height: hPadding),
                      buildFieldNotePerubahan(),
                      const SizedBox(height: hPadding),

                      Text(
                        "*Pastikan data perubahan sesuai dengan dokumen Anda.",
                        style: bodyTextStyle(context).copyWith(
                          color: sGrey,
                          fontSize: getResponsiveFont(context, 12),
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) async {
        if (!state.isSaved || state.hasFailure) return;

        final cobId = context.read<CobManPolBloc>().state.selectedCOBId;
        final selectedItem = _selectedItemByCob(context, cobId);

        if (selectedItem == null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(infoSnackBar("Data belum dipilih / tidak ditemukan"));
          return;
        }

        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PolisSuccess(
              purpose: "R",
              display: "Pengajuan berhasil dikirim",
            ),
          ),
        );
      },

    );
  }

  Widget buildFieldEndorsTgl(){
    return AppDateField(
      label: 'Tanggal endorse', firstDate: DateTime(2000), // batas awal biar valid
      lastDate: DateTime(2100),
      initialValue: DateTime.tryParse(fieldEndorsTglController.text),
      onChanged: (value) {
        if (value != null) {
          debugPrint("🔵 [Endors1Crud] endorsTgl changed: $value");
          removeError(error: kStringNullError);
          fieldEndorsTglController.text = value.toIso8601String();
        }
      },
    );
  }

  Widget buildFieldInsuredNama(){
    return appTextField(
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      controller: fieldInsuredNamaController,
      label: 'Insured Name',
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
      },
    );
  }

  Widget buildFieldMstsendorsId(){
    return appTextField(
      controller: fieldMstsendorsIdController,label:'MstendorseID',
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
      },
    );
  }

  Widget buildFieldNoteKonfirmasi(){
    return appTextField(
      keyboardType: TextInputType.multiline,
      label: 'Note Konfirmasi',
      maxLines: 3,
      controller: fieldNoteKonfirmasiController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
      },
    );
  }

  Widget buildFieldNotePerubahan() {
    return appTextField(
      label: "Deskripsi Perubahan",
      hint: 'Contoh: "Perubahan alamat surat menyurat atau kontak penanggung."',
      controller: fieldNotePerubahanController,
      keyboardType: TextInputType.multiline,
      maxLines: 12,
      errorText: err('form1.notePerubahan'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          clearErr('form1.notePerubahan');
        }
      },
    );
  }


  Widget buildFieldPeriodeAkhir(){
    return AppDateField(
      label: 'Periode Akhir', firstDate: DateTime(2000), // batas awal biar valid
      lastDate: DateTime(2100),
      onChanged: (value) {
        if (value != null) {
          removeError(error: kStringNullError);
          fieldPeriodeAkhirController.text = value.toIso8601String();
        }
      },
    );
  }

  Widget buildFieldPeriodeMulai(){
    return AppDateField(
      initialValue: DateTime.tryParse(fieldPeriodeMulaiController.text),
      onChanged: (value) {
        if (value != null) {
          removeError(error: kStringNullError);
          fieldPeriodeMulaiController.text = value.toIso8601String();
        }
      }, label: 'Periode Mulai', firstDate: DateTime(2000), // batas awal biar valid
      lastDate: DateTime(2100),
    );
  }

  Widget buildFieldPremi(){
    return appTextField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldPremiController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
      }, label: 'Premi',
    );
  }

  Widget buildFieldSppa1Id(){
    return appTextField(
      controller: fieldSppa1IdController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
      }, label: 'SPPA ID',
    );
  }

  Widget buildFieldStatusEndors(){
    return appTextField(
      controller: fieldStatusEndorsController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
      }, label: 'Status Endorse',
    );
  }

  Widget buildFieldTsi(){
    return appTextField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldTsiController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
      }, label: 'TSI',
    );
  }

  void _showPengajuanDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: formGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Icon atas
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 12),

                // 🔹 Pesan
                Text(
                  "Pengajuan diproses tim internal.",
                  textAlign: TextAlign.center,
                  style: headingStyle(context,
                    fontSize: 17.49,
                  ),
                ),
                const SizedBox(height: 12),

                AppButton.primary(
                    text: 'Ajukan Sekarang',
                    backgroundColor: const Color(0xFF0ED7FF),
                    onPressed: onSaveForm
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void onSaveForm() {
    _dismissDialog();
    final record = Regrenew1FormModel(
      isUbah: false,
      sppa1Id: widget.polisId,
      notePerubahan: fieldNotePerubahanController.text,
    );

    regrenewal1FormBloc.add(Regrenew1FormTambahEvent(record: record));
  }

  bool validateForm1() {
    clearErrsByPrefix('form1.');
    bool ok = true;

    final note = fieldNotePerubahanController.text.trim();
    if (note.isEmpty) {
      setErr('form1.notePerubahan', 'Catatan perubahan wajib diisi');
      ok = false;
    }

    return ok;
  }

  void addError({required String error}) {
    if (!errors.contains(error)){
      setState(() {
        errors.add(error);
      });
      debugPrint("⚠️ [Endors1Crud] Error added: $error");
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)){
      setState(() {
        errors.remove(error);
      });
      debugPrint("✅ [Endors1Crud] Error removed: $error");
    }
  }

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
double _safeDouble(String? text) {
  if (text == null) return 0;
  final clean = text.replaceAll(',', '').trim();
  if (clean.isEmpty) return 0;
  return double.tryParse(clean) ?? 0;
}