import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart'
    show ComboRMatauangModel;
import 'package:joss_app/repositories/combobox/combormatauang_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulpar/simulparcrud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quick_input_formatters/quick_input_formatters.dart';

class SimulparFormSumInsuredPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulparFormSumInsuredPage({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  SimulparFormSumInsuredPageState createState() =>
      SimulparFormSumInsuredPageState();
}

class SimulparFormSumInsuredPageState
    extends State<SimulparFormSumInsuredPage> {
  late SimulparCrudBloc simulparCrudBloc;
  final List<String> errors = [];
  var fieldSiBuildingController = TextEditingController();
  var fieldSiContentController = TextEditingController();
  var fieldSiMachineryController = TextEditingController();
  var fieldSiOtherController = TextEditingController();
  var fieldSiStockController = TextEditingController();
  var fieldStockAdjustableController = TextEditingController();
  var fieldSiBiController = TextEditingController();
  var fieldSiTotalController = TextEditingController();
  ComboRMatauangModel? fieldComboRMatauang;
  final GlobalKey<DropdownSearchState<ComboRMatauangModel>> comboRMatauangKey =
      GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
  
  @override
  Widget build(BuildContext context) {
    simulparCrudBloc = BlocProvider.of<SimulparCrudBloc>(context);
    return BlocConsumer<SimulparCrudBloc, SimulparCrudState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: pGrey,
            borderRadius: BorderRadius.circular(cardBorderRadius),
          ),
          child: Column(
            children: [
              buildFieldCurr(),
              const SizedBox(height: 10),
              buildFieldSiMachinery(),
              const SizedBox(height: 10),
              buildFieldSiBuilding(),
              const SizedBox(height: 10),
              buildFieldSiStock(),
              const SizedBox(height: 10),
              buildFieldStockAdjustable(),
              const SizedBox(height: 10),
              buildFieldSiContent(),
              const SizedBox(height: 10),
              buildFieldSiOthers(),
              const SizedBox(height: 10),
              buildFieldSiBi(),
              const SizedBox(height: 10),
              buildFieldSiTotal(),
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state.isLoaded) {
          if (state.record != null) {
            fieldSiBuildingController.text = NumberFormat(
              "#,###",
            ).format(state.record!.siBuilding);
            fieldSiContentController.text = NumberFormat(
              "#,###",
            ).format(state.record!.siContent);
            fieldSiMachineryController.text = NumberFormat(
              "#,###",
            ).format(state.record!.siMachinery);
            fieldSiOtherController.text = NumberFormat(
              "#,###",
            ).format(state.record!.siOther);
            fieldSiStockController.text = NumberFormat(
              "#,###",
            ).format(state.record!.siStock);
            fieldStockAdjustableController.text = NumberFormat(
              "###.00",
            ).format(state.record!.stockAdjustable);
            fieldSiBiController.text = NumberFormat(
              "#,###",
            ).format(state.record!.siBi);

            fieldSiTotalController.text = NumberFormat(
              "#,###",
            ).format(state.record!.siTotal);
          }

          fieldComboRMatauang = state.comboRMatauang;
        }
      },
    );
  }

  Widget buildFieldSiBuilding() {
    return appTextField(
      label: "Bangunan",
      hint: "0",
      controller: fieldSiBuildingController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return kStringNullError;
        }
        return null;
      },
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc.add(
          FieldSiBuildingChangedEvent(si: double.tryParse(value) ?? 0),
        );
      },
    );
  }

  Widget buildFieldSiContent() {
    return appTextField(
      label: "Konten",
      hint: "0",
      controller: fieldSiContentController,
      keyboardType: TextInputType.number,
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return kStringNullError;
        }
        return null;
      },
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc.add(
          FieldSiContentChangedEvent(si: double.tryParse(value) ?? 0),
        );
      },
    );
  }

  Widget buildFieldSiMachinery() {
    return appTextField(
      label: "Mesin",
      hint: "0",
      controller: fieldSiMachineryController,
      keyboardType: TextInputType.number,
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return kStringNullError;
        }
        return null;
      },
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc.add(
          FieldSiMachineryChangedEvent(si: double.tryParse(value) ?? 0),
        );
      },
    );
  }

  Widget buildFieldSiOthers() {
    return appTextField(
      label: "Lainnya",
      hint: "0",
      controller: fieldSiOtherController,
      keyboardType: TextInputType.number,
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return kStringNullError;
        return null;
      },
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc.add(
          FieldSiOthersChangedEvent(si: double.tryParse(value) ?? 0),
        );
      },
    );
  }

  Widget buildFieldSiStock() {
    return appTextField(
      label: "Stok",
      hint: "0",
      controller: fieldSiStockController,
      keyboardType: TextInputType.number,
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return kStringNullError;
        return null;
      },
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc.add(
          FieldSiStockChangedEvent(si: double.tryParse(value) ?? 0),
        );
      },
    );
  }

  Widget buildFieldStockAdjustable() {
    return appTextField(
      label: "Stok Yang Dapat Disesuaikan",
      hint: "0",
      controller: fieldStockAdjustableController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(2),
      ],
      suffix: Text("%", style: bodyTextStyle(context)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return kStringNullError;
        }
        return null;
      },
      onChanged: (value) {
        simulparCrudBloc.add(
          FieldStockAdjustableChangedEvent(
            adjustable: double.tryParse(value) ?? 0,
          ),
        );
      },
    );
  }

  Widget buildFieldSiBi() {
    return appTextField(
      label: "BI",
      hint: "0",
      controller: fieldSiBiController,
      keyboardType: TextInputType.number,
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return kStringNullError;
        return null;
      },
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulparCrudBloc.add(
          FieldSiBiChangedEvent(si: double.tryParse(value) ?? 0),
        );
      },
    );
  }

  Widget buildFieldCurr() {
    return ReusableComboBox<ComboRMatauangModel>(
      hintText: "Mata Uang",
      comboKey: comboRMatauangKey,
      initItem: fieldComboRMatauang,
      dataLoader: () async {
        return ComboRMatauangRepository().getComboRMatauang();
      },
      displayText: (item) => item.rmatauangSimbol,
      compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
      onChangedCallback: (value) {
        if (value != null) {
          simulparCrudBloc.add(
            ComboRMatauangChangedEvent(comboRMatauang: value),
          );
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboRMatauang = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) return kStringNullError;
        return null;
      },
    );
  }

  Widget buildFieldSiTotal() {
    return appTextField(
      label: "Total",
      controller: fieldSiTotalController,
      keyboardType: TextInputType.number,
      enabled: false,
      onChanged: null,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return kStringNullError;
        }
        return null;
      },
    );
  }
}