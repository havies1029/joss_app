import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/repositories/combobox/combommvgrupojk_repository.dart';
import 'package:joss_app/repositories/combobox/combommvjnscover_repository.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/repositories/combobox/combomwilayah_repository.dart';

class SimulmvFormCascoPage extends StatefulWidget {
  final String viewMode;
  final String recordId;
  // Tambahkan parameter untuk formKey dari parent
  final GlobalKey<FormState>? parentFormKey;

  const SimulmvFormCascoPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    this.parentFormKey,
  });

  @override
  SimulmvCrudFormPageFormCascoState createState() =>
      SimulmvCrudFormPageFormCascoState();
}

class SimulmvCrudFormPageFormCascoState extends State<SimulmvFormCascoPage> {
  late SimulmvCrudBloc simulmvCrudBloc;
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
  var fieldThnBuatController = TextEditingController(
    text: DateTime.now().year.toString(),
  );
  final dropDownKeyTahun = GlobalKey<DropdownSearchState<String>>();

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
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: pGrey,
            borderRadius: BorderRadius.circular(cardBorderRadius),
          ),
          child: Column(
            children: [
              buildFieldJenisKendaraan(),
              const SizedBox(height: 10),
              buildFieldComboTahun(),
              const SizedBox(height: 10),
              buildFieldJenisCover(),
              const SizedBox(height: 10),
              buildFieldHarga(),
              const SizedBox(height: 10),
              buildFieldWilayah(),
              const SizedBox(height: 10),
              buildFieldLamaCover(),
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state.isLoaded) {
          debugPrint("listener #X01");
          if (state.record != null) {
            fieldCoverBulanController.text =
                state.record!.coverBulan.toString();
            fieldHargaController.text = NumberFormat(
              "#,###",
            ).format(state.record!.harga);
            fieldThnBuatController.text = state.record!.thnBuat.toString();
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
    return ReusableComboBox<String>(
      hintText: "Tahun Pembuatan",
      comboKey: dropDownKeyTahun,
      initItem: selectedYear,
      dataLoader: () async {
        return _yearList;
      },
      displayText: (item) => item,
      compareItems: (a, b) => a == b,
      onChangedCallback: (value) {
        simulmvCrudBloc.add(
          FieldTahunChangedEvent(tahun: int.tryParse(value ?? "0") ?? 0),
        );
      },
      onSaveCallback: (value) {},
      validatorCallback: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        return null;
      },
    );
  }

  Widget buildFieldHarga() {
    return appTextField(
      label: "Harga Kendaraan",
      hint: "0",
      controller: fieldHargaController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        final clean = value.replaceAll(",", "");
        simulmvCrudBloc.add(
          FieldHargaChangedEvent(harga: double.tryParse(clean) ?? 0),
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final cleanValue = value.replaceAll(",", "");
        final harga = double.tryParse(cleanValue);
        if (harga == null || harga <= 0) {
          return kString0;
        }
        return null;
      },
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    );
  }

  Widget buildFieldJenisKendaraan() {
    return ReusableComboBox<ComboMMvgrupOjkModel>(
      hintText: "Jenis Kendaraan",
      showClearButton: true,
      comboKey: comboMMvgrupOjkKey,
      initItem: fieldComboMMvgrupOjk,
      dataLoader: () => ComboMMvgrupOjkRepository().getComboMMvgrupOjk(),
      displayText: (item) => item.grupNama,
      compareItems: (a, b) => a.mmvgrupojkId == b.mmvgrupojkId,
      onChangedCallback: (value) {
        if (value != null) {
          simulmvCrudBloc.add(
            ComboMMvgrupOjkChangedEvent(comboMMvgrupOjk: value),
          );
        }
      },
      onSaveCallback: (value) {
        if (value != null) fieldComboMMvgrupOjk = value;
      },
      validatorCallback: (value) {
        if (value == null) {
          return kStringNullError;
        }
        return null;
      },
    );
  }

  Widget buildFieldWilayah() {
    return ReusableComboBox<ComboMWilayahModel>(
      hintText: "Wilayah",
      comboKey: comboMWilayahKey,
      initItem: fieldComboMWilayah,
      dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
      displayText: (item) => item.wilayahNama,
      compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
      onChangedCallback: (value) {
        if (value != null) {
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
          return kStringNullError;
        }
        return null;
      },
    );
  }

  Widget buildFieldJenisCover() {
    return ReusableComboBox<ComboMMvjnscoverModel>(
      hintText: "Jenis Cover",
      comboKey: comboMMvjnscoverKey,
      initItem: fieldComboMMvjnscover,
      dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
      displayText: (item) => item.coverName,
      compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
      onChangedCallback: (value) {
        if (value != null) {
          simulmvCrudBloc.add(
            ComboMMvjnscoverChangedEvent(comboMMvjnscover: value),
          );
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMMvjnscover = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          return kStringNullError;
        }
        return null;
      },
    );
  }

  Widget buildFieldLamaCover() {
    return appTextField(
      label: "Lama Cover",
      hint: "0",
      controller: fieldCoverBulanController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      suffix: Text("bulan", style: bodyTextStyle(context)),
      onChanged: (value) {
        final clean = value.replaceAll(",", "");
        simulmvCrudBloc.add(
          FieldLamaCoverChangedEvent(lama: int.tryParse(clean) ?? 0),
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        final clean = value.replaceAll(",", "");
        final lama = int.tryParse(clean);
        if (lama == null || lama <= 0) {
          return "Lama cover harus lebih dari 0 bulan";
        }
        if (lama > 120) {
          return "Lama cover maksimal 120 bulan";
        }
        return null;
      },
    );
  }
}