import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';
import '../../../../../models/gen_aset_par/asetparcari_model.dart';
import '../../../../base/base_background_sidepage.dart';

class EndorseFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;
  final dynamic data;
  final AsetParCariModel? defaultPolis;

  const EndorseFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    this.data,
    this.defaultPolis,
  });

  @override
  State<EndorseFormPage> createState() => _EndorseFormPageState();
}

class _EndorseFormPageState extends State<EndorseFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final fieldEndorsTgl = TextEditingController();
  final fieldMstsendorsId = TextEditingController();
  final fieldNoteKonfirmasi = TextEditingController();
  final fieldNotePerubahan = TextEditingController();
  final fieldPeriodeAkhir = TextEditingController();
  final fieldPeriodeMulai = TextEditingController();
  final fieldPremi = TextEditingController();
  final fieldSppa1Id = TextEditingController();
  final fieldStatusEndors = TextEditingController();
  final fieldTsi = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataFromParameter();
  }

  void _loadDataFromParameter() {
    final Map<String, dynamic> dataMap = _toMap(widget.data ?? widget.defaultPolis);

    fieldEndorsTgl.text = dataMap["endorsTgl"]?.toString() ?? DateTime.now().toIso8601String();
    fieldMstsendorsId.text = dataMap["mstsendorsId"]?.toString() ?? "";
    fieldNoteKonfirmasi.text = dataMap["noteKonfirmasi"]?.toString() ?? "";
    fieldNotePerubahan.text = dataMap["notePerubahan"]?.toString() ?? "";
    fieldPeriodeAkhir.text = dataMap["periodeAkhir"]?.toString() ?? DateTime.now().toIso8601String();
    fieldPeriodeMulai.text = dataMap["periodeMulai"]?.toString() ?? DateTime.now().toIso8601String();
    fieldPremi.text = NumberFormat("#,###").format(double.tryParse(dataMap["premi"]?.toString() ?? "0") ?? 0);
    fieldSppa1Id.text = dataMap["sppa1Id"]?.toString() ?? "";
    fieldStatusEndors.text = dataMap["statusEndors"]?.toString() ?? "";
    fieldTsi.text = NumberFormat("#,###").format(double.tryParse(dataMap["tsi"]?.toString() ?? "0") ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Endorsement",
      onBack: () => Navigator.pop(context),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            color: secondaryBlackColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                buildDateField("Tanggal Endorse", fieldEndorsTgl),
                buildTextField("ID Master Endorse", fieldMstsendorsId),
                buildTextField("Catatan Konfirmasi", fieldNoteKonfirmasi, maxLines: 3),
                buildTextField("Catatan Perubahan", fieldNotePerubahan, maxLines: 3),
                buildDateField("Periode Mulai", fieldPeriodeMulai),
                buildDateField("Periode Akhir", fieldPeriodeAkhir),
                buildNumberField("Premi", fieldPremi),
                buildTextField("SPPA ID", fieldSppa1Id),
                buildTextField("Status Endorse", fieldStatusEndors),
                buildNumberField("TSI", fieldTsi),
                const SizedBox(height: 20),
                AppButton.primary(
                  text: "Simpan",
                  onPressed: onSaveForm,
                ),
                const SizedBox(height: 10),
                AppButton.primary(
                  text: "Batal",
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: unselectedColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🧩 Convert data object ke Map<String, dynamic>
  Map<String, dynamic> _toMap(dynamic obj) {
    if (obj == null) return {};
    if (obj is Map<String, dynamic>) return obj;
    try {
      return obj.toJson();
    } catch (_) {
      final result = <String, dynamic>{};
      obj.toString().replaceAll(RegExp(r'[{}]'), '').split(',').forEach((pair) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          result[parts[0].trim()] = parts[1].trim();
        }
      });
      return result;
    }
  }

  // 🧱 Builders
  Widget buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DateTimeFormField(
        mode: DateTimeFieldPickerMode.date,
        dateFormat: DateFormat('dd/MM/yyyy'),
        initialValue: DateTime.tryParse(controller.text),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (value) {
          if (value != null) controller.text = value.toIso8601String();
        },
        validator: (value) => value == null ? "Harus diisi" : null,
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        validator: (value) => value == null || value.isEmpty ? "Harus diisi" : null,
      ),
    );
  }

  Widget buildNumberField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [ThousandsSeparatorInputFormatter()],
        controller: controller,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        validator: (value) => value == null || value.isEmpty ? "Harus diisi" : null,
      ),
    );
  }

  void onSaveForm() {
    if (!_formKey.currentState!.validate()) return;

    final record = {
      "endorsTgl": fieldEndorsTgl.text,
      "mstsendorsId": fieldMstsendorsId.text,
      "noteKonfirmasi": fieldNoteKonfirmasi.text,
      "notePerubahan": fieldNotePerubahan.text,
      "periodeAkhir": fieldPeriodeAkhir.text,
      "periodeMulai": fieldPeriodeMulai.text,
      "premi": fieldPremi.text,
      "sppa1Id": fieldSppa1Id.text,
      "statusEndors": fieldStatusEndors.text,
      "tsi": fieldTsi.text,
    };

    debugPrint("💾 Data disimpan: $record");
    Navigator.pop(context, record);
  }
}
