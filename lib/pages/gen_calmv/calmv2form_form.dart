import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_calmv/calmv2form_bloc.dart';
import 'package:joss_app/models/gen_calmv/calmv2form_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:quick_input_formatters/formatters/decimal_text_input_formatter.dart';
import 'package:string_validator/string_validator.dart';

class Calmv2FormFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;
  final String? calmv1Id;

  const Calmv2FormFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    this.calmv1Id,
  });

  @override
  Calmv2FormFormPageFormState createState() => Calmv2FormFormPageFormState();
}

class Calmv2FormFormPageFormState extends State<Calmv2FormFormPage> {
  late Calmv2FormBloc calmv2FormBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  // Controllers
  var fieldAwController = TextEditingController();
  var fieldIsEqController = TextEditingController();
  var fieldIsFloodController = TextEditingController();
  var fieldIsSrccController = TextEditingController();
  var fieldIsTbodController = TextEditingController();
  var fieldIsTerrorismController = TextEditingController();
  var fieldPadController = TextEditingController();
  var fieldPapController = TextEditingController();
  var fieldPassangerCountController = TextEditingController();
  var fieldPllController = TextEditingController();
  var fieldTplController = TextEditingController();
  var fieldCalmv1IdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.calmv1Id != null && widget.calmv1Id!.isNotEmpty) {
      fieldCalmv1IdController.text = widget.calmv1Id!;
      debugPrint("✅ Calmv1 ID diterima dari Form1: ${widget.calmv1Id}");
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    calmv2FormBloc = BlocProvider.of<Calmv2FormBloc>(context);

    return BlocConsumer<Calmv2FormBloc, Calmv2FormState>(
      builder: (context, state) {
        return BaseBackgroundSidePage(
          title: 'Perlindungan Tambahan',
          child: SingleChildScrollView(
            child: Form(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: pGrey,
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(flex: 1, child: buildFieldPLL()),
                        const SizedBox(width: 8),
                        Flexible(flex: 1, child: buildFieldTPL()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Flexible(flex: 1, child: buildFieldPAD()),
                        const SizedBox(width: 8),
                        Flexible(flex: 1, child: buildFieldPAP()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Flexible(flex: 1, child: buildFieldPassangerCount()),
                        const SizedBox(width: 8),
                        Flexible(flex: 1, child: buildFieldAW()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Flexible(flex: 1, child: buildFieldIsEq()),
                        const SizedBox(width: 8),
                        Flexible(flex: 1, child: buildFieldIsFlood()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Flexible(flex: 1, child: buildFieldIsSrcc()),
                        const SizedBox(width: 8),
                        Flexible(flex: 1, child: buildFieldIsTerrorism()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Flexible(flex: 1, child: buildFieldIsTbod()),
                        const SizedBox(width: 8),
                        const Flexible(flex: 1, child: SizedBox.shrink()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: ElevatedButton(
                              onPressed: _dismissDialog,
                              child: const Text(
                                'Close',
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: ElevatedButton(
                              onPressed: onSaveForm,
                              child: const Text(
                                'Save',
                                style: TextStyle(fontSize: 13.0),
                              ),
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
        );
      },
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          debugPrint("📦 [STATE LOADED] Record ditemukan:");
          debugPrint(state.record?.toJson().toString());

          // Hati-hati jangan timpa ID yang udah di-pass
          if (widget.calmv1Id == null || widget.calmv1Id!.isEmpty) {
            fieldCalmv1IdController.text = state.record!.calmv1Id;
            debugPrint(
              "ℹ️ Calmv1 ID diambil dari record bloc: ${state.record!.calmv1Id}",
            );
          }

          fieldAwController.text = NumberFormat(
            "#,###",
          ).format(state.record!.aw);
          fieldIsEqController.text = state.record!.isEq.toString();
          fieldIsFloodController.text = state.record!.isFlood.toString();
          fieldIsSrccController.text = state.record!.isSrcc.toString();
          fieldIsTbodController.text = state.record!.isTbod.toString();
          fieldIsTerrorismController.text =
              state.record!.isTerrorism.toString();
          fieldPadController.text = NumberFormat(
            "#,###",
          ).format(state.record!.pad);
          fieldPapController.text = NumberFormat(
            "#,###",
          ).format(state.record!.pap);
          fieldPassangerCountController.text =
              state.record!.passangerCount.toString();
          fieldPllController.text = NumberFormat(
            "#,###",
          ).format(state.record!.pll);
          fieldTplController.text = NumberFormat(
            "#,###",
          ).format(state.record!.tpl);
        }
      },
    );
  }

  void loadData() {
    if (widget.viewMode == "ubah") {
      calmv2FormBloc.add(Calmv2FormLihatEvent(recordId: widget.recordId));
      debugPrint(
        "🔁 [LOAD DATA] Mode ubah, ambil record ID ${widget.recordId}",
      );
    } else {
      debugPrint("🆕 [LOAD DATA] Mode tambah, skip load record");
    }
  }

  // === FIELD ===
  Widget buildFieldCalmv1Id() {
    return TextFormField(
      controller: fieldCalmv1IdController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Calmv1 ID",
        hintText: "Terisi otomatis setelah menyimpan Form 1",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.lock_outline, color: Colors.grey),
      ),
      style: TextStyle(color: Colors.grey[700]),
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: "⚠️ Calmv1 ID wajib ada (otomatis dari Form 1)");
          return "";
        }
        return null;
      },
    );
  }

  Widget buildFieldAW() {
    return appTextField(
      label: "Authorized Workshop",
      hint: "0.00",
      controller: fieldAwController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2),
      ],
      suffix: Text("%", style: bodyTextStyle(context)),
      onChanged: (value) {
        if (value.isNotEmpty) removeError(error: kStringNullError);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final awRate = double.tryParse(value);
        if (awRate == null || awRate < 0) {
          return kString0;
        }
        if (awRate > 100) {
          return "Authorized Workshop tidak boleh lebih dari 100%";
        }
        return null;
      },
    );
  }

  Widget buildFieldIsEq() => CheckboxWidget(
    leftLabel: "",
    rightLabel: "EQ",
    initialValue: toBoolean(fieldIsEqController.text),
    callback: (value) {
      setState(() => fieldIsEqController.text = value.toString());
    },
  );

  Widget buildFieldIsFlood() => CheckboxWidget(
    leftLabel: "",
    rightLabel: "Flood",
    initialValue: toBoolean(fieldIsFloodController.text),
    callback: (value) {
      setState(() => fieldIsFloodController.text = value.toString());
    },
  );

  Widget buildFieldIsSrcc() => CheckboxWidget(
    leftLabel: "",
    rightLabel: "SRCC",
    initialValue: toBoolean(fieldIsSrccController.text),
    callback: (value) {
      setState(() => fieldIsSrccController.text = value.toString());
    },
  );

  Widget buildFieldIsTbod() => CheckboxWidget(
    leftLabel: "",
    rightLabel: "TBOD",
    initialValue: toBoolean(fieldIsTbodController.text),
    callback: (value) {
      setState(() => fieldIsTbodController.text = value.toString());
    },
  );

  Widget buildFieldIsTerrorism() => CheckboxWidget(
    leftLabel: "",
    rightLabel: "Terrorism",
    initialValue: toBoolean(fieldIsTerrorismController.text),
    callback: (value) {
      setState(() => fieldIsTerrorismController.text = value.toString());
    },
  );

  Widget buildFieldPAD() {
    return appTextField(
      label: "PA Driver",
      hint: "0",
      controller: fieldPadController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
      onChanged: (value) {
        if (value.isNotEmpty) removeError(error: kStringNullError);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final clean = value.replaceAll(",", "");
        final pad = double.tryParse(clean);
        if (pad == null || pad <= 0) {
          return kString0;
        }
        return null;
      },
    );
  }

  Widget buildFieldPAP() {
    return appTextField(
      label: "PA Passenger",
      hint: "0",
      controller: fieldPapController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        if (value.isNotEmpty) removeError(error: kStringNullError);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final clean = value.replaceAll(",", "");
        final pap = double.tryParse(clean);
        if (pap == null || pap <= 0) {
          return kString0;
        }
        return null;
      },
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    );
  }

  Widget buildFieldPassangerCount() {
    return appTextField(
      label: "Passenger Count",
      hint: "0",
      controller: fieldPassangerCountController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        if (value.isNotEmpty) removeError(error: kStringNullError);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final clean = value.replaceAll(",", "");
        final pll = double.tryParse(clean);
        if (pll == null || pll <= 0) {
          return kString0;
        }
        return null;
      },
    );
  }

  Widget buildFieldPLL() {
    return appTextField(
      label: "Passenger Liability",
      hint: "0",
      controller: fieldPllController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
      onChanged: (value) {
        if (value.isNotEmpty) removeError(error: kStringNullError);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final clean = value.replaceAll(",", "");
        final pll = double.tryParse(clean);
        if (pll == null || pll <= 0) {
          return kString0;
        }
        return null;
      },
    );
  }

  Widget buildFieldTPL() {
    return appTextField(
      label: "TPL",
      hint: "0",
      controller: fieldTplController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        if (value.isNotEmpty) removeError(error: kStringNullError);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final clean = value.replaceAll(",", "");
        final tpl = double.tryParse(clean);
        if (tpl == null || tpl <= 0) {
          return kString0;
        }
        return null;
      },
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    );
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void onSaveForm() {
    debugPrint("=========== [ONSAVEFORM CALMV2] ===========");
    debugPrint("Calmv1 ID Controller Value: ${fieldCalmv1IdController.text}");
    debugPrint("============================================");

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final record = Calmv2FormModel(
        calmv2Id:
            widget.viewMode == "ubah"
                ? calmv2FormBloc.state.record?.calmv2Id ?? ''
                : '',
        calmv1Id: fieldCalmv1IdController.text,
        aw: double.tryParse(fieldAwController.text.replaceAll(',', '')) ?? 0,
        isEq: toBoolean(fieldIsEqController.text),
        isFlood: toBoolean(fieldIsFloodController.text),
        isSrcc: toBoolean(fieldIsSrccController.text),
        isTbod: toBoolean(fieldIsTbodController.text),
        isTerrorism: toBoolean(fieldIsTerrorismController.text),
        pad: double.tryParse(fieldPadController.text.replaceAll(',', '')) ?? 0,
        pap: double.tryParse(fieldPapController.text.replaceAll(',', '')) ?? 0,
        passangerCount:
            int.tryParse(
              fieldPassangerCountController.text.replaceAll(',', ''),
            ) ??
            0,
        pll: double.tryParse(fieldPllController.text.replaceAll(',', '')) ?? 0,
        tpl: double.tryParse(fieldTplController.text.replaceAll(',', '')) ?? 0,
      );

      debugPrint("📤 Record dikirim ke Bloc: ${record.toJson()}");

      if (widget.viewMode == "tambah") {
        calmv2FormBloc.add(Calmv2FormTambahEvent(record: record));
      } else {
        calmv2FormBloc.add(Calmv2FormUbahEvent(record: record));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data Calmv2 dikirim ke Bloc (cek debug log)"),
        ),
      );

      Navigator.pop(
        context,
        fieldCalmv1IdController.text,
      ); // ✅ return calmv1Id ke Form1
    } else {
      debugPrint("❌ Validasi GAGAL, error list: $errors");
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() => errors.add(error));
      debugPrint("⚠️ Error ditambah: $error");
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() => errors.remove(error));
      debugPrint("✅ Error dihapus: $error");
    }
  }
}
