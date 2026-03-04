import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/widgets/combobox/combommvgrupojk_widget.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/widgets/combobox/combommvjnscover_widget.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/widgets/combobox/combomwilayah_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SimulmvCrudFormCascoPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulmvCrudFormCascoPage(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulmvCrudFormPageFormCascoState createState() =>
      SimulmvCrudFormPageFormCascoState();
}

class SimulmvCrudFormPageFormCascoState
    extends State<SimulmvCrudFormCascoPage> {
  late SimulmvCrudBloc simulmvCrudBloc;
  final _formKey = GlobalKey<FormState>();
  var fieldCoverBulanController = TextEditingController();
  var fieldHargaController = TextEditingController();
  ComboMMvgrupOjkModel? fieldComboMMvgrupOjk;
  final comboMMvgrupOjkKey =
      GlobalKey<DropdownSearchState<ComboMMvgrupOjkModel>>();
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  final comboMMvjnscoverKey =
      GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();
  ComboMWilayahModel? fieldComboMWilayah;
  final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();
  var fieldThnBuatController =
      TextEditingController(text: DateTime.now().year.toString());
  final dropDownKeyTahun = GlobalKey<DropdownSearchState>();
  final List<String> _yearList = [];
  String selectedYear = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
      int startYear = DateTime.now().year;
      int endYear = startYear - 10;
      selectedYear = startYear.toString();
      for (int i = startYear; i >= endYear; i--) {
        debugPrint("Tahun : $i");
        _yearList.add(i.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    simulmvCrudBloc = BlocProvider.of<SimulmvCrudBloc>(context);

    return BlocConsumer<SimulmvCrudBloc, SimulmvCrudState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildFieldComboTahun()),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildFieldHarga(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    buildFieldJenisKendaraan(),
                    const SizedBox(height: 10),
                    buildFieldWilayah(),
                    const SizedBox(height: 10),
                    buildFieldJenisCover(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildFieldLamaCover()),
                        ),
                        Flexible(
                          flex: 3,
                          child: Container(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
          ),
        );
      },
      listener: (context, state) {
        if (state.isLoaded)  {
          debugPrint("listener #X01");
          if (state.record != null) {
            fieldCoverBulanController.text =
                state.record!.coverBulan.toString();
            fieldHargaController.text =
                NumberFormat("#,###").format(state.record!.harga);
            fieldThnBuatController.text = state.record!.thnBuat.toString();
            fieldCoverBulanController.text =
                state.record!.coverBulan.toString();
          }
          fieldComboMMvgrupOjk = state.comboMMvgrupOjk;
          fieldComboMMvjnscover = state.comboMMvjnscover;
          fieldComboMWilayah = state.comboMWilayah;
        }
      },
    );
  }

  void loadData() {
    if (widget.viewMode == "ubah") {
      simulmvCrudBloc.add(SimulmvCrudLihatEvent(recordId: widget.recordId));
    } else if (widget.viewMode == "tambah") {
      simulmvCrudBloc.add(SimulMVCrudInitValueEvent());
    }
  }

  Widget buildFieldComboTahun() {
    return DropdownSearch<String>(
      key: dropDownKeyTahun,
      selectedItem: selectedYear,
      items: (filter, infiniteScrollProps) => _yearList,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: 'Tahun Pembuatan',
          border: OutlineInputBorder(),
        ),
      ),
      popupProps: PopupPropsMultiSelection.modalBottomSheet(
        disableFilter: false,
        showSelectedItems: true,
        showSearchBox: false,
        itemBuilder: itemBuilderComboTahun,
      ),
      onChanged: (value) {
        simulmvCrudBloc
            .add(FieldTahunChangedEvent(tahun: int.parse(value ?? "0")));
      },
    );
  }

  Widget itemBuilderComboTahun(
      BuildContext context, String item, bool isSelected, bool isDisabled) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item),
      ),
    );
  }

  TextFormField buildFieldHarga() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldHargaController,
      decoration: const InputDecoration(
        labelText: "Harga Kendaraan",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixText: ",000,000,-",
      ),
      onChanged: (value) {
        value = value.replaceAll(",", "");
        simulmvCrudBloc
            .add(FieldHargaChangedEvent(harga: double.tryParse(value) ?? 0) );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          //addError(error: kStringNullError);
          return "";
        }
        return null;
      },
      textAlign: TextAlign.right,
    );
  }

  Widget buildFieldJenisKendaraan() {
    return buildFieldComboMMvgrupOjk(
      comboKey: comboMMvgrupOjkKey,
      labelText: 'Jenis Kendaraan',
      initItem: fieldComboMMvgrupOjk,

      onChangedCallback: (value) {
        if (value != null) {
          //removeError(error: "Field ComboMMvgrupOjk tidak boleh kosong.");
          simulmvCrudBloc
              .add(ComboMMvgrupOjkChangedEvent(comboMMvgrupOjk: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMMvgrupOjk = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          //addError(error: "Field ComboMMvgrupOjk tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldWilayah() {
    return buildFieldComboMWilayah(
      comboKey: comboMWilayahKey,
      labelText: 'Wilayah',
      initItem: fieldComboMWilayah,
      onChangedCallback: (value) {
        if (value != null) {
          //removeError(error: "Field ComboMWilayah tidak boleh kosong.");
          simulmvCrudBloc.add(ComboMWilayahChangedEvent(comboMWilayah: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMWilayah = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          //addError(error: "Field ComboMWilayah tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldJenisCover() {
    return buildFieldComboMMvjnscover(
      enabled: true,
      comboKey: comboMMvjnscoverKey,
      labelText: 'Jenis Cover',
      initItem: fieldComboMMvjnscover,
      onChangedCallback: (value) {
        if (value != null) {
          //removeError(error: "Field ComboMMvjnscover tidak boleh kosong.");
          simulmvCrudBloc
              .add(ComboMMvjnscoverChangedEvent(comboMMvjnscover: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMMvjnscover = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          //addError(error: "Field ComboMMvjnscover tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldLamaCover() {
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
        simulmvCrudBloc
            .add(FieldLamaCoverChangedEvent(lama: int.tryParse(value) ?? 0));
      },
      textAlign: TextAlign.center,
    );
  }
}
