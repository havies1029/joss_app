import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/repositories/combobox/comborkonstruksiojk_repository.dart';
import 'package:joss_app/repositories/combobox/comborokupasi_repository.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SimulparFormBangunanPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparFormBangunanPage({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  SimulparFormBangunanPageState createState() =>
      SimulparFormBangunanPageState();
}

class SimulparFormBangunanPageState extends State<SimulparFormBangunanPage> {
  late SimulparCrudBloc simulparCrudBloc;
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
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: pGrey,
            borderRadius: BorderRadius.circular(cardBorderRadius),
          ),
          child: Column(
            children: [
              buildFieldCoverBulan(),
              const SizedBox(height: 10),
              buildFieldKelasKonstruksi(),
              const SizedBox(height: 10),
              buildFieldOkupasi(),
            ],
          ),
        );
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
    return appTextField(
      label: "Lama Cover",
      hint: "0",
      controller: fieldCoverBulanController,
      keyboardType: TextInputType.number,
      suffix: Text("Bulan", style: bodyTextStyle(context)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return kStringNullError;
        }
        if (int.tryParse(value.replaceAll(",", "")) == null) {
          return "Harus berupa angka valid";
        }
        return null;
      },
      onChanged: (value) {
        simulparCrudBloc.add(
          FieldBulanChangedEvent(
            bulan: int.tryParse(value.replaceAll(",", "")) ?? 0,
          ),
        );
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget buildFieldKelasKonstruksi() {
    return ReusableComboBox<ComboRKonstruksiojkModel>(
      hintText: "Konstruksi",
      comboKey: comboRKonstruksiojkKey,
      initItem: fieldComboRKonstruksiojk,
      dataLoader:
          () => ComboRKonstruksiojkRepository().getComboRKonstruksiojk(fieldComboROkupasi?.rokupasiId ?? ""),
      displayText: (item) => item.kelasNama,
      compareItems: (a, b) => a.rkonstruksiojkId == b.rkonstruksiojkId,
      onChangedCallback: (value) {
        if (value != null) {
          simulparCrudBloc.add(
            ComboRKonstruksiojkChangedEvent(comboRKonstruksiojk: value),
          );
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboRKonstruksiojk = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) return kStringNullError;
        return null;
      },
    );
  }

  Widget buildFieldOkupasi() {
    return ReusableComboBox<ComboROkupasiModel>(
      hintText: "Okupasi",
      comboKey: comboROkupasiKey,
      initItem: fieldComboROkupasi,
      dataLoader:
          () => ComboROkupasiRepository().getComboROkupasi(""), // loader
      displayText: (item) => "${item.kodeOjk} - ${item.okupasiDesc}",
      compareItems: (a, b) => a.rokupasiId == b.rokupasiId,
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
      validatorCallback: (value) {
        if (value == null) return kStringNullError;
        return null;
      },
    );
  }
}