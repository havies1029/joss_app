import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/widgets/combobox/comborkonstruksiojk_widget.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/widgets/combobox/comborokupasi_widget.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SimulparCrudFormBangunanPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparCrudFormBangunanPage(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulparCrudFormBangunanPageState createState() =>
      SimulparCrudFormBangunanPageState();
}

class SimulparCrudFormBangunanPageState
    extends State<SimulparCrudFormBangunanPage> {
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
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildFieldCoverBulan()),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    buildFieldOkupasi(),
                    const SizedBox(height: 10),
                    buildFieldKelasKonstruksi(),
                  ],
                )),
          ),
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
      decoration: const InputDecoration(
        labelText: "Lama Cover",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: " bulan",
      ),
      onChanged: (value) {
        simulparCrudBloc.add(FieldBulanChangedEvent(bulan: int.tryParse(value) ?? 0));
      },
      textAlign: TextAlign.center,
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
