import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/models/combobox/combomkabzonagempa_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/widgets/combobox/combombiindemnityojk_widget.dart';
import 'package:joss_app/widgets/combobox/combomkabzonagempa_widget.dart';
import 'package:joss_app/widgets/combobox/combomwilayah_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:quick_input_formatters/quick_input_formatters.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SimulparFormCoverV2Page extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparFormCoverV2Page(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulparFormCoverV2PageFormState createState() =>
      SimulparFormCoverV2PageFormState();
}

class SimulparFormCoverV2PageFormState extends State<SimulparFormCoverV2Page> {
  late SimulparCrudBloc simulparCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  ComboMWilayahModel? fieldComboMWilayah;
  final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();

  ComboMKabZonaGempaModel? fieldComboMKabZonaGempa;
  final comboMKabZonaGempaKey =
  GlobalKey<DropdownSearchState<ComboMKabZonaGempaModel>>();

  ComboMBiindemnityOjkModel? fieldComboMBiindemnityOjk;
  final comboMBiindemnityOjkKey =
  GlobalKey<DropdownSearchState<ComboMBiindemnityOjkModel>>();

  var fieldRateTsfwdController = TextEditingController();
  var fieldRateParController = TextEditingController();
  var fieldRateRsmdccController = TextEditingController();
  var fieldRateEqvetController = TextEditingController();
  var fieldRateOtherController = TextEditingController();
  var fieldRateTotalController = TextEditingController();
  var fieldBiIndexRateController = TextEditingController();

  // Controllers untuk field baru sesuai gambar
  var fieldMataUangController = TextEditingController();
  var fieldMesinController = TextEditingController();
  var fieldBangunanController = TextEditingController();
  var fieldStokYangDapatDisesuaikanController = TextEditingController();
  var fieldStokController = TextEditingController();
  var fieldLainLainController = TextEditingController();
  var fieldTotalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    simulparCrudBloc = BlocProvider.of<SimulparCrudBloc>(context);

    return BlocConsumer<SimulparCrudBloc, SimulparCrudState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Tentukan apakah menggunakan layout 2 kolom atau 1 kolom
            final bool useDoubleColumn = constraints.maxWidth > 600;
            final double horizontalPadding = useDoubleColumn ? 16.0 : 8.0;
            final double verticalSpacing = useDoubleColumn ? 16.0 : 12.0;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Form(
                  key: _formKey,
                  child: _buildResponsiveLayout(useDoubleColumn, verticalSpacing),
                ),
              ),
            );
          },
        );
      },
      listener: (context, state) {
        if ((state.isLoaded) || (state.isGroupFieldRateChanged)) {
          if (state.record != null) {
            fieldRateParController.text =
                NumberFormat("##0.0###").format(state.record!.ratePar);
            fieldRateRsmdccController.text =
                NumberFormat("##0.0###").format(state.record!.rateRsmdcc);
            fieldRateTsfwdController.text =
                NumberFormat("##0.0###").format(state.record!.rateTsfwd);
            fieldRateEqvetController.text =
                NumberFormat("##0.0###").format(state.record!.rateEqvet);
            fieldRateOtherController.text =
                NumberFormat("##0.0###").format(state.record!.rateOther);
            fieldBiIndexRateController.text =
                NumberFormat("##0.0###").format(state.record!.biIndexRate);
            fieldRateTotalController.text =
                NumberFormat("##0.0###").format(state.record!.rateTotal);
          }
          fieldComboMWilayah = state.comboMWilayah;
          fieldComboMKabZonaGempa = state.comboMKabZonaGempa;
          fieldComboMBiindemnityOjk = state.comboMBiindemnityOjk;
        }
      },
    );
  }

  Widget _buildResponsiveLayout(bool useDoubleColumn, double spacing) {
    if (useDoubleColumn) {
      // Layout 2 kolom untuk desktop/tablet - sesuai gambar
      return Column(
        children: [
          // Row 1: Mata Uang & Mesin
          _buildFieldRow([
            _buildMataUangField(),
            _buildMesinField(),
          ], spacing),
          SizedBox(height: spacing),

          // Row 2: Bangunan & Stok yang Dapat Disesuaikan
          _buildFieldRow([
            _buildBangunanField(),
            _buildStokYangDapatDisesuaikanField(),
          ], spacing),
          SizedBox(height: spacing),

          // Row 3: Stok & Lain-lain
          _buildFieldRow([
            _buildStokField(),
            _buildLainLainField(),
          ], spacing),
          SizedBox(height: spacing),

          // Row 4: Total (hanya di kiri)
          _buildFieldRow([
            _buildTotalField(),
            Container(), // Space kosong di kanan
          ], spacing),
        ],
      );
    } else {
      // Layout 1 kolom untuk mobile
      return Column(
        children: [
          _buildMataUangField(),
          SizedBox(height: spacing),
          _buildMesinField(),
          SizedBox(height: spacing),
          _buildBangunanField(),
          SizedBox(height: spacing),
          _buildStokYangDapatDisesuaikanField(),
          SizedBox(height: spacing),
          _buildStokField(),
          SizedBox(height: spacing),
          _buildLainLainField(),
          SizedBox(height: spacing),
          _buildTotalField(),
        ],
      );
    }
  }

  Widget _buildFieldRow(List<Widget> children, double spacing) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(right: spacing / 2),
            child: children[0],
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: spacing / 2),
            child: children[1],
          ),
        ),
      ],
    );
  }

  // Field builders sesuai dengan gambar
  Widget _buildMataUangField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Mata Uang",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      hint: const Text("-- Pilih Mata Uang --"),
      items: const [
        DropdownMenuItem(value: "IDR", child: Text("IDR")),
        DropdownMenuItem(value: "USD", child: Text("USD")),
        DropdownMenuItem(value: "EUR", child: Text("EUR")),
      ],
      onChanged: (value) {
        // Handle dropdown change
      },
    );
  }

  Widget _buildMesinField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      decoration: InputDecoration(
        labelText: "Mesin",
        prefixText: "IDR ",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      textAlign: TextAlign.right,
      onChanged: (value) {
        // Handle field change
      },
    );
  }

  Widget _buildBangunanField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      decoration: InputDecoration(
        labelText: "Bangunan",
        prefixText: "IDR ",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      textAlign: TextAlign.right,
      onChanged: (value) {
        // Handle field change
      },
    );
  }

  Widget _buildStokYangDapatDisesuaikanField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, DecimalTextInputFormatter(2)],
      decoration: InputDecoration(
        labelText: "Stok yang Dapat Disesuaikan",
        suffixText: "%",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      textAlign: TextAlign.right,
      onChanged: (value) {
        // Handle field change
      },
    );
  }

  Widget _buildStokField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      decoration: InputDecoration(
        labelText: "Stok",
        prefixText: "IDR ",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      textAlign: TextAlign.right,
      onChanged: (value) {
        // Handle field change
      },
    );
  }

  Widget _buildLainLainField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      decoration: InputDecoration(
        labelText: "Lain-lain",
        prefixText: "IDR ",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      textAlign: TextAlign.right,
      onChanged: (value) {
        // Handle field change
      },
    );
  }

  Widget _buildTotalField() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.number,
      controller: fieldTotalController,
      decoration: InputDecoration(
        labelText: "Total",
        prefixText: "IDR ",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Methods dari kode asli yang tetap dipertahankan untuk kompatibilitas
  Widget buildFieldRatePAR() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2)
      ],
      controller: fieldRateParController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldRateRSMDCC() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2)
      ],
      controller: fieldRateRsmdccController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {
        simulparCrudBloc.add(FieldRateRsmdccChangedEvent(
            rateRsmdcc: double.tryParse(value) ?? 0));
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldWilayah() {
    return buildFieldComboMWilayah(
      comboKey: comboMWilayahKey,
      labelText: 'Wilayah',
      initItem: fieldComboMWilayah,
      onChangedCallback: (value) {
        simulparCrudBloc.add(ComboMWilayahChangedEvent(comboMWilayah: value));
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMWilayah = value;
        }
      },
    );
  }

  Widget buildFieldRateTSFWD() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2)
      ],
      controller: fieldRateTsfwdController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldKabupaten() {
    return buildFieldComboMKabZonaGempa(
      comboKey: comboMKabZonaGempaKey,
      labelText: 'Zona Gempa - Kabupaten',
      initItem: fieldComboMKabZonaGempa,
      onChangedCallback: (value) {
        if (value != null) {
          simulparCrudBloc
              .add(ComboMKabZonaGempaChangedEvent(comboMKabZonaGempa: value));
        }
      },
      onSaveCallback: (value) {},
    );
  }

  buildFieldRateEQVET() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2)
      ],
      controller: fieldRateEqvetController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  buildFieldRateOther() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2)
      ],
      controller: fieldRateOtherController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {
        simulparCrudBloc.add(
            FieldRateOthersChangedEvent(rate: double.tryParse(value) ?? 0));
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldRateTotal() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldRateTotalController,
      decoration: const InputDecoration(
        labelText: "Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " %",
      ),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldBiIndexRate() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldBiIndexRateController,
      decoration: const InputDecoration(
        labelText: "Index Rate",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (value) {},
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldBiIndemnity() {
    return buildFieldComboMBiindemnityOjk(
      comboKey: comboMBiindemnityOjkKey,
      labelText: 'Periode Indemnity',
      initItem: fieldComboMBiindemnityOjk,
      onChangedCallback: (value) {
        simulparCrudBloc.add(
            ComboMBiindemnityOjkChangedEvent(comboMBiindemnityOjk: value));
      },
      onSaveCallback: (value) {},
    );
  }
}