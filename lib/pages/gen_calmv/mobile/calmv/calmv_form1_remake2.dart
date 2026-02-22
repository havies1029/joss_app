import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
import 'package:joss_app/models/gen_calmv/calmv1crud_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/repositories/combobox/combommvgrupojk_repository.dart';
import 'package:joss_app/repositories/combobox/combommvjnscover_repository.dart';
import 'package:joss_app/repositories/combobox/combomwilayah_repository.dart';


import '../../../../models/combobox/combommvpakai_model.dart';
import '../../../../models/combobox/combormatauang_model.dart';
import '../../../../repositories/combobox/combommvpakai_repository.dart';
import '../../../../repositories/combobox/combormatauang_repository.dart';


class CalmvForm1Section2 extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const CalmvForm1Section2({
    super.key,
    required this.formKey,
  });

  @override
  State<CalmvForm1Section2> createState() => CalmvForm1Section2State();
}

class CalmvForm1Section2State extends State<CalmvForm1Section2> {
  final _calmvform1key = GlobalKey<FormState>();
  late String calmv1Id;
  final fieldCoverBulanController = TextEditingController();
  final fieldHargaController = TextEditingController();

  ComboMMvgrupOjkModel? fieldComboMMvgrupOjk;
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  ComboMWilayahModel? fieldComboMWilayah;
  ComboRMatauangModel? fieldComboUang;
  final fieldCurrIdController = TextEditingController();
  ComboMMvpakaiModel? fieldComboMMvpakai;

  String selectedYear = "";

  late final Calmv1CrudBloc calmv1Bloc;

  @override
  void initState() {
    super.initState();
    calmv1Bloc = context.read<Calmv1CrudBloc>();

    calmv1Bloc
        .add(FieldCoverBulanChangedEvent(coverBulan:12));

    Future.microtask(_loadData);
  }

  void _loadData() {
    final calmv1State = context
        .read<Calmv1CrudBloc>()
        .state;
    calmv1Id = calmv1State.record!.calmv1Id;

    if (calmv1Id.isNotEmpty == true) {
      calmv1Bloc.add(Calmv1CrudLihatEvent(recordId: calmv1Id));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return BlocConsumer<Calmv1CrudBloc, Calmv1CrudState>(
      listenWhen: (prev, curr) =>
      prev.isLoaded != curr.isLoaded || prev.record != curr.record,
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          final r = state.record!;
          fieldCoverBulanController.text = r.coverBulan.toString();
          fieldHargaController.text = r.harga.toString();
          fieldCurrIdController.text = r.currId ?? "";
          selectedYear = r.thnBuat.toString() ?? "";

          fieldComboMMvgrupOjk = state.comboMMvgrupOjk;
          fieldComboMMvjnscover = state.comboMMvjnscover;
          fieldComboMWilayah = state.comboMWilayah;
          fieldComboUang = state.comboRMatauangModel;
          fieldComboMMvpakai = state.comboMMvpakaiModel;

          setState(() {});
        }
      },
      buildWhen: (prev, curr) =>
      prev.isLoaded != curr.isLoaded || prev.record != curr.record,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Form(
            key: _calmvform1key,
            child: Column(
              children: [
                _buildComboMMvgrupOjk(),
                const SizedBox(height: hPadding),
                Row(
                  children: [
                    Flexible(child: _buildComboMMvjnscover()),
                    const SizedBox(width: 8),
                    Flexible(child: _buildHarga()),
                  ],
                ),
                const SizedBox(height: hPadding),
                Row(
                  children: [
                    Flexible(child: _buildComboCurddId()),
                    const SizedBox(width: 8),
                    Flexible(child: buildFieldComboTahun()),
                  ],
                ),
                const SizedBox(height: hPadding),
                _buildComboMWilayah(),
                const SizedBox(height: hPadding),
                _buildFieldMmvpakaiId(),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> saveForm1() async {
  //   final record = Calmv1CrudModel(
  //     calmv1Id: widget.recordId!,
  //     harga: double.tryParse(fieldHargaController.text.replaceAll(",", "")) ?? 0,
  //     currId: fieldComboUang?.rmatauangKode ?? "",
  //     coverBulan: int.tryParse(fieldCoverBulanController.text.replaceAll(",", "")) ?? 12,
  //     thnBuat: int.tryParse(selectedYear) ?? 0,
  //     mmvgrupojkId: fieldComboMMvgrupOjk?.mmvgrupojkId,
  //     mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
  //     mmvpakaiId: fieldComboMMvpakai?.mmvpakaiId,
  //     mwilayahId: fieldComboMWilayah?.mwilayahId,
  //   );
  //
  //   if (widget.recordId?.isEmpty == true) {
  //     calmv1Bloc.add(Calmv1CrudTambahEvent(record: record));
  //   } else {
  //     calmv1Bloc.add(Calmv1CrudUbahEvent(record: record));
  //   }
  //
  // }

  //form1 field
  Widget _buildComboMMvgrupOjk() =>
      ReusableComboBox<ComboMMvgrupOjkModel>(
        hintText: "Jenis Kendaraan",
        initItem: fieldComboMMvgrupOjk,
        dataLoader: () => ComboMMvgrupOjkRepository().getComboMMvgrupOjk(),
        displayText: (i) => i.grupNama,
        compareItems: (a, b) => a.mmvgrupojkId == b.mmvgrupojkId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form1.jenisKendaraan'),
        onChangedCallback: (v) {
          fieldComboMMvgrupOjk = v;
          if (v != null) {
            clearErr('form1.jenisKendaraan');
            debugPrint("[EVT] ComboMMvgrupOjkChanged id=${v.mmvgrupojkId} nama=${v.grupNama}");
           calmv1Bloc
                .add(ComboMMvgrupOjkChangedEvent(comboMMvgrupOjk: v));
          }
        },
        onSaveCallback: (value) => fieldComboMMvgrupOjk = value,
      );

  Widget _buildComboMMvjnscover() =>
      ReusableComboBox<ComboMMvjnscoverModel>(
        hintText: "Jenis Cover",
        initItem: fieldComboMMvjnscover,
        dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
        displayText: (i) => i.coverName,
        compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form1.jenisCover'),
        onChangedCallback: (v) {
          fieldComboMMvjnscover = v;
          if (v != null) {
            clearErr('form1.jenisCover');
            debugPrint("[EVT] ComboMMvjnscoverChanged id=${v.mmvjnscoverId} nama=${v.coverName}");
           calmv1Bloc
                .add(ComboMMvjnscoverChangedEvent(comboMMvjnscover: v));
          }
        },
        onSaveCallback: (value) => fieldComboMMvjnscover = value,
      );

  Widget _buildComboMWilayah() =>
      ReusableComboBox<ComboMWilayahModel>(
        hintText: "Wilayah",
        initItem: fieldComboMWilayah,
        dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
        displayText: (i) => i.wilayahNama,
        compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form1.wilayah'),
        onChangedCallback: (v) {
          fieldComboMWilayah = v;
          if (v != null) {
            clearErr('form1.wilayah');
            debugPrint("[EVT] ComboMWilayahChanged id=${v.mwilayahId} nama=${v.wilayahNama}");
           calmv1Bloc
                .add(ComboMWilayahChangedEvent(comboMWilayah: v));
          }
        },
        onSaveCallback: (value) => fieldComboMWilayah = value,
      );

  Widget _buildComboCurddId() =>
      ReusableComboBox<ComboRMatauangModel>(
        hintText: "Mata Uang",
        initItem: fieldComboUang,
        dataLoader: () => ComboRMatauangRepository().getComboRMatauang(),
        displayText: (item) => item.rmatauangSimbol,
        compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form1.mataUang'),
        onChangedCallback: (v) {
          fieldComboUang = v;
          if (v != null) {
            clearErr('form1.mataUang');

           calmv1Bloc
                .add(ComboRMatauangChangedEvent(comboRMatauang: v));

           calmv1Bloc
                .add(FieldCurrIdChangedEvent(currId: v.rmatauangKode));
          }
        },
        onSaveCallback: (value) => fieldComboUang = value,
      );

  Widget _buildFieldMmvpakaiId() =>
      ReusableComboBox<ComboMMvpakaiModel>(
        hintText: "Penggunaan",
        initItem: fieldComboMMvpakai,
        dataLoader: () => ComboMMvpakaiRepository().getComboMMvpakai(),
        displayText: (item) => item.pakaiNama,
        compareItems: (a, b) => a.mmvpakaiId == b.mmvpakaiId,
        validatorCallback: (v) => v == null ? kStringNullError : null,
        errorText: err('form1.penggunaan'),
        onChangedCallback: (v) {
          fieldComboMMvpakai = v;
          if (v != null) {
            debugPrint("[EVT] ComboMMvpakaiChanged id=${v.mmvpakaiId} nama=${v.pakaiNama}");
            clearErr('form1.penggunaan');
           calmv1Bloc
                .add(ComboMMvpakaiChangedEvent(comboMMvpakai: v));
          }
        },
        onSaveCallback: (value) => fieldComboMMvpakai = value,
      );

  Widget buildFieldComboTahun() {
    // Buat list tahun dari sekarang → 1980
    final yearNow = DateTime
        .now()
        .year;
    final years = List<String>.generate(
      yearNow - 1980 + 1,
          (i) => (yearNow - i).toString(),
    );

    return ReusableComboBox<String>(
      hintText: "Tahun Pembuatan",
      initItem: selectedYear.isNotEmpty ? selectedYear : null,
      dataLoader: () async => years,
      displayText: (item) => item,
      compareItems: (a, b) => a == b,

      // Validator
      validatorCallback: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        return null;
      },
      errorText: err('form1.tahun'),
      onChangedCallback: (v) {
        selectedYear = v ?? "";
        if (v != null) {
          clearErr('form1.tahun');
          final thn = int.tryParse(v);
          if (thn != null) {
            debugPrint("[EVT] FieldThnBuatChanged raw=$v parsed=$thn");
           calmv1Bloc
                .add(FieldThnBuatChangedEvent(thnBuat: thn));
          }
        }
      },
      onSaveCallback: (value) {
        selectedYear = value ?? "";
      },
    );
  }

  Widget _buildHarga() =>
      appTextField(
        label: "Harga Kendaraan",
        controller: fieldHargaController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
          ThousandsSeparatorInputFormatter(),
        ],
        errorText: err('form1.hargaKendaraan'),
        validator: (_) => err('form1.hargaKendaraan'),
        onChanged: (v) {
          final clean = v.replaceAll(",", "").trim();
          final angka = double.tryParse(clean);
          if (angka != null && angka >= 0) {
            debugPrint("[EVT] FieldHargaChanged raw='$v' clean='$clean' parsed=$angka");
            clearErr('form1.hargaKendaraan');
           calmv1Bloc
                .add(FieldHargaChangedEvent(harga: angka));
          }
        },
      );
//form1 field

  final Map<String, String?> fieldErrors = {};
  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }
  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }
  void clearErrsByPrefix(String prefix) {
    setState(() {
      fieldErrors.removeWhere((k, _) => k.startsWith(prefix));
    });
  }

}