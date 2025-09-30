import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:string_validator/string_validator.dart';
import 'package:quick_input_formatters/quick_input_formatters.dart';

class SimulmvFormOpsiPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulmvFormOpsiPage(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulmvCrudFormPageFormOpsiState createState() =>
      SimulmvCrudFormPageFormOpsiState();
}

class SimulmvCrudFormPageFormOpsiState extends State<SimulmvFormOpsiPage> {
  late SimulmvCrudBloc simulmvCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldAwController = TextEditingController();
  var fieldIsEqController = TextEditingController();
  var fieldIsFloodController = TextEditingController();
  var fieldIsSrccController = TextEditingController();
  var fieldIsTerrorismController = TextEditingController();
  var fieldPadController = TextEditingController();
  var fieldPapController = TextEditingController();
  var fieldPllController = TextEditingController();
  var fieldTplController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    simulmvCrudBloc = BlocProvider.of<SimulmvCrudBloc>(context);

    return BlocConsumer<SimulmvCrudBloc, SimulmvCrudState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // 4 checkbox: EQ, Flood, SRCC, Terrorism → otomatis wrap
                LayoutBuilder(
                  builder: (context, constraints) {
                    const spacing = 8.0;
                    // Atur breakpoint & jumlah kolom sesuai kebutuhan
                    final isMobile = constraints.maxWidth < 600;
                    final crossAxisCount = isMobile ? 2 : 4;

                    // Hitung lebar item agar pas per baris & rapi saat wrap
                    final itemWidth =
                        (constraints.maxWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;

                    return Wrap(
                      spacing: spacing,     // jarak antar item dalam baris
                      runSpacing: 10,       // jarak antar baris
                      children: [
                        SizedBox(width: itemWidth, child: buildFieldIsEQ()),
                        SizedBox(width: itemWidth, child: buildFieldIsFlood()),
                        SizedBox(width: itemWidth, child: buildFieldIsSRCC()),
                        SizedBox(width: itemWidth, child: buildFieldIsTerrorism()),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Row: Passenger Liability & PA Driver
                Row(
                  children: [
                    Flexible(flex: 1, child: buildFieldPLL()),
                    const SizedBox(width: 8),
                    Flexible(flex: 1, child: buildFieldPAD()),
                  ],
                ),

                const SizedBox(height: 10),

                // Row: TPL & PAP
                Row(
                  children: [
                    Flexible(flex: 1, child: buildFieldTPL()),
                    const SizedBox(width: 8),
                    Flexible(flex: 1, child: buildFieldPAP()),
                  ],
                ),

                const SizedBox(height: 10),

                // Row: Authorized Workshop (kiri saja)
                Row(
                  children: [
                    Flexible(flex: 1, child: buildFieldAW()),
                    const SizedBox(width: 8),
                    const Flexible(flex: 1, child: SizedBox.shrink()),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if ((state.isLoaded) || (state.isFieldOpsiChanged)) {
          if (state.record != null) {
            fieldAwController.text = NumberFormat.decimalPattern().format(state.record!.aw);
            fieldIsEqController.text = state.record!.isEq.toString();
            fieldIsFloodController.text = state.record!.isFlood.toString();
            fieldIsSrccController.text = state.record!.isSrcc.toString();
            fieldIsTerrorismController.text = state.record!.isTerrorism.toString();
            fieldPadController.text = NumberFormat("#,###").format(state.record!.pad);
            fieldPapController.text = NumberFormat("#,###").format(state.record!.pap);
            fieldPllController.text = NumberFormat("#,###").format(state.record!.pll);
            fieldTplController.text = NumberFormat("#,###").format(state.record!.tpl);
          }
        }
      },
    );
  }



  Widget buildFieldAW() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        const Text(
          'Authorized Workshop',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan custom decoration
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            DecimalTextInputFormatter(2)
          ],
          controller: fieldAwController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            suffixText: " %",
            suffixStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau (sama seperti field lainnya)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            // Hilangkan floating label karena sudah ada label di atas
            labelText: null,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onChanged: (value) {
            simulmvCrudBloc
                .add(FieldAWChangedEvent(awRate: double.tryParse(value) ?? 0));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field Authorized Workshop tidak boleh kosong";
            }
            // Validasi tambahan untuk memastikan AW Rate valid
            double? awRate = double.tryParse(value);
            if (awRate == null || awRate < 0) {
              return "Authorized Workshop harus 0 atau lebih";
            }
            if (awRate > 100) {
              return "Authorized Workshop tidak boleh lebih dari 100%";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildFieldIsEQ() {
    return CheckboxWidget(
        leftLabel: "",
        rightLabel: "EQ",
        initialValue: toBoolean(fieldIsEqController.text),
        callback: (value) {
          simulmvCrudBloc.add(CheckboxIsEQChangedEvent(isChecked: value));
        });
  }

  Widget buildFieldIsFlood() {
    return CheckboxWidget(
        leftLabel: "",
        rightLabel: "Flood",
        initialValue: toBoolean(fieldIsFloodController.text),
        callback: (value) {
          simulmvCrudBloc.add(CheckboxIsFloodChangedEvent(isChecked: value));
        });
  }

  Widget buildFieldIsSRCC() {
    return CheckboxWidget(
        leftLabel: "",
        rightLabel: "SRCC",
        initialValue: toBoolean(fieldIsSrccController.text),
        callback: (value) {
          simulmvCrudBloc.add(CheckboxIsRSCCChangedEvent(isChecked: value));
        });
  }

  Widget buildFieldIsTerrorism() {
    return CheckboxWidget(
        leftLabel: "",
        rightLabel: "Terrorism",
        initialValue: toBoolean(fieldIsTerrorismController.text),
        callback: (value) {
          simulmvCrudBloc
              .add(CheckboxIsTerrorismChangedEvent(isChecked: value));
        });
  }

  Widget buildFieldPAD() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        const Text(
          'PA Driver',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan custom decoration
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [ThousandsSeparatorInputFormatter()],
          controller: fieldPadController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            suffixText: ",000,000,-",
            suffixStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau (sama seperti field lainnya)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            // Hilangkan floating label karena sudah ada label di atas
            labelText: null,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onChanged: (value) {
            value = value.replaceAll(",", "");
            simulmvCrudBloc
                .add(FieldPADChangedEvent(pad: double.tryParse(value) ?? 0));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field PA Driver tidak boleh kosong";
            }
            // Validasi tambahan untuk memastikan PA Driver > 0
            String cleanValue = value.replaceAll(",", "");
            double? pad = double.tryParse(cleanValue);
            if (pad == null || pad <= 0) {
              return "PA Driver harus lebih dari 0";
            }
            return null;
          },
        ),
      ],
    );
  }

  // Revisi buildFieldPAP dengan desain yang sama seperti buildFieldHarga
  Widget buildFieldPAP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        const Text(
          'PA Passenger',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan custom decoration
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [ThousandsSeparatorInputFormatter()],
          controller: fieldPapController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            suffixText: ",000,000,-",
            suffixStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau (sama seperti field lainnya)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            // Hilangkan floating label karena sudah ada label di atas
            labelText: null,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onChanged: (value) {
            value = value.replaceAll(",", "");
            simulmvCrudBloc
                .add(FieldPAPChangedEvent(pap: double.tryParse(value) ?? 0));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field PA Passenger tidak boleh kosong";
            }
            // Validasi tambahan untuk memastikan PA Passenger > 0
            String cleanValue = value.replaceAll(",", "");
            double? pap = double.tryParse(cleanValue);
            if (pap == null || pap <= 0) {
              return "PA Passenger harus lebih dari 0";
            }
            return null;
          },
        ),
      ],
    );
  }

  // Revisi buildFieldPLL dengan desain yang sama seperti buildFieldHarga
  Widget buildFieldPLL() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        const Text(
          'Passenger Liability',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan custom decoration
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [ThousandsSeparatorInputFormatter()],
          controller: fieldPllController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            suffixText: ",000,000,-",
            suffixStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau (sama seperti field lainnya)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            // Hilangkan floating label karena sudah ada label di atas
            labelText: null,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onChanged: (value) {
            value = value.replaceAll(",", "");
            simulmvCrudBloc
                .add(FieldPLLChangedEvent(pll: double.tryParse(value) ?? 0));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field Passenger Liability tidak boleh kosong";
            }
            // Validasi tambahan untuk memastikan Passenger Liability > 0
            String cleanValue = value.replaceAll(",", "");
            double? pll = double.tryParse(cleanValue);
            if (pll == null || pll <= 0) {
              return "Passenger Liability harus lebih dari 0";
            }
            return null;
          },
        ),
      ],
    );
  }

// Revisi buildFieldTPL dengan desain yang sama seperti buildFieldHarga
  Widget buildFieldTPL() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        const Text(
          'TPL',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan custom decoration
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [ThousandsSeparatorInputFormatter()],
          controller: fieldTplController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            suffixText: ",000,000,-",
            suffixStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau (sama seperti field lainnya)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            // Hilangkan floating label karena sudah ada label di atas
            labelText: null,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onChanged: (value) {
            value = value.replaceAll(",", "");
            simulmvCrudBloc
                .add(FieldTPLChangedEvent(tpl: double.tryParse(value) ?? 0));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field TPL tidak boleh kosong";
            }
            // Validasi tambahan untuk memastikan TPL > 0
            String cleanValue = value.replaceAll(",", "");
            double? tpl = double.tryParse(cleanValue);
            if (tpl == null || tpl <= 0) {
              return "TPL harus lebih dari 0";
            }
            return null;
          },
        ),
      ],
    );
  }
}
