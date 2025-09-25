import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/widgets/combobox/comborkonstruksiojk_widget.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/widgets/combobox/comborokupasi_widget.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SimulparFormBangunanPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparFormBangunanPage(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulparFormBangunanPageState createState() =>
      SimulparFormBangunanPageState();
}

class SimulparFormBangunanPageState
    extends State<SimulparFormBangunanPage> {
  late SimulparCrudBloc simulparCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldCoverBulanController = TextEditingController();
  ComboRKonstruksiojkModel? fieldComboRKonstruksiojk;
  final comboRKonstruksiojkKey =
  GlobalKey<DropdownSearchState<ComboRKonstruksiojkModel>>();
  ComboROkupasiModel? fieldComboROkupasi;
  final comboROkupasiKey = GlobalKey<DropdownSearchState<ComboROkupasiModel>>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      //loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    simulparCrudBloc = BlocProvider.of<SimulparCrudBloc>(context);

    return BlocConsumer<SimulparCrudBloc, SimulparCrudState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Tentukan apakah menggunakan layout 2 kolom atau 1 kolom
            final bool useDoubleColumn = constraints.maxWidth > 600;
            final double verticalSpacing = useDoubleColumn ? 16.0 : 12.0;

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: _buildResponsiveLayout(useDoubleColumn, verticalSpacing),
              ),
            );
          },
        );
      },
      listener: (context, state) {
        if (state.isLoaded) {
          if (state.record != null) {
            fieldCoverBulanController.text =
                state.record!.coverBulan.toString();
          }

          fieldComboRKonstruksiojk = state.comboRKonstruksiojk;
          fieldComboROkupasi = state.comboROkupasi;
        }
      },
    );
  }


  Widget _buildResponsiveLayout(bool useDoubleColumn, double spacing) {
    if (useDoubleColumn) {
      // Layout 2 kolom untuk desktop/tablet - sesuai gambar
      return Column(
        children: [
          // Row 1: Lama Cover (kiri) & Konstruksi (kanan)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(right: spacing / 2),
                  child: buildFieldCoverBulan(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: spacing / 2),
                  child: buildFieldKelasKonstruksi(),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          // Row 2: Okupasi (full width, kiri saja)
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(right: spacing / 2),
                  child: buildFieldOkupasi(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(), // Space kosong di kanan
              ),
            ],
          ),
        ],
      );
    } else {
      // Layout 1 kolom untuk mobile
      return Column(
        children: [
          buildFieldCoverBulan(),
          SizedBox(height: spacing),
          buildFieldKelasKonstruksi(),
          SizedBox(height: spacing),
          buildFieldOkupasi(),
        ],
      );
    }
  }

  void loadData() {
    if (widget.viewMode == "ubah") {
      simulparCrudBloc.add(SimulparCrudLihatEvent(recordId: widget.recordId));
    } else if (widget.viewMode == "tambah") {
      simulparCrudBloc.add(SimulPARCrudInitValueEvent());
    }
  }

  Widget buildFieldCoverBulan() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldCoverBulanController,
      decoration: InputDecoration(
        labelText: "Lama Cover",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: "Bulan",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: (value) {
        simulparCrudBloc.add(FieldBulanChangedEvent(bulan: int.tryParse(value) ?? 0));
      },
      textAlign: TextAlign.left,
    );
  }

  Widget buildFieldKelasKonstruksi() {
    return buildFieldComboRKonstruksiojk(
      comboKey: comboRKonstruksiojkKey,
      labelText: 'Konstruksi',
      initItem: fieldComboRKonstruksiojk,
      onChangedCallback: (value) {
        if (value != null) {
          simulparCrudBloc
              .add(ComboRKonstruksiojkChangedEvent(comboRKonstruksiojk: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboRKonstruksiojk = value;
        }
      },
    );
  }

  Widget buildFieldOkupasi() {
    return buildFieldComboROkupasi(
      comboKey: comboROkupasiKey,
      labelText: 'Okupasi',
      initItem: fieldComboROkupasi,
      onChangedCallback: (value) {
        if (value != null) {
          simulparCrudBloc.add(ComboROkupasiChangedEvent(comboROkupasi: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboROkupasi = value;
        }
      },
    );
  }
}