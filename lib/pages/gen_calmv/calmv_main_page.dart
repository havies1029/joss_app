import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:string_validator/string_validator.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv2form_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv3form_bloc.dart';
import 'package:joss_app/models/gen_calmv/calmv1crud_model.dart';
import 'package:joss_app/models/gen_calmv/calmv2form_model.dart';
import 'package:joss_app/models/gen_calmv/calmv3form_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';

import 'package:joss_app/repositories/combobox/combomwilayah_repository.dart';
import 'package:joss_app/repositories/combobox/combommvgrupojk_repository.dart';
import 'package:joss_app/repositories/combobox/combommvjnscover_repository.dart';

import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:quick_input_formatters/formatters/decimal_text_input_formatter.dart';
import '../base/base_background_sidepage.dart';

class CalmvFormPage extends StatefulWidget {
  final String viewMode;
  final String? recordId;

  const CalmvFormPage({
    super.key,
    required this.viewMode,
    this.recordId,
  });

  @override
  CalmvFormPageState createState() => CalmvFormPageState();
}

class CalmvFormPageState extends State<CalmvFormPage> {
  late Calmv1CrudBloc calmv1CrudBloc;
  late Calmv2FormBloc calmv2FormBloc;
  late Calmv3FormBloc calmv3FormBloc;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  final List<String> errors = [];

  // Expansion state
  bool _isForm1Expanded = true;
  bool _isForm2Expanded = false;
  bool _isForm3Expanded = false;

  // Calmv1 ID yang akan di-share ke Form 2 dan 3
  String? _savedCalmv1Id;

  // Form 1 Controllers
  var fieldCoverBulanController = TextEditingController();
  var fieldCurrIdController = TextEditingController();
  var fieldHargaController = TextEditingController();
  ComboMMvgrupOjkModel? fieldComboMMvgrupOjk;
  final comboMMvgrupOjkKey = GlobalKey<DropdownSearchState<ComboMMvgrupOjkModel>>();
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  final comboMMvjnscoverKey = GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();
  ComboMWilayahModel? fieldComboMWilayah;
  final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();
  var fieldThnBuatController = TextEditingController();

  // Form 2 Controllers
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

  // Form 3 Controllers
  var fieldDiskonPersenController = TextEditingController();
  var fieldPremiAddController = TextEditingController();
  var fieldPremiCascoController = TextEditingController();
  var fieldPremiDiskonController = TextEditingController();
  var fieldPremiNetController = TextEditingController();
  var fieldPremiSubtotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  void dispose() {
    // Form 1
    fieldCoverBulanController.dispose();
    fieldCurrIdController.dispose();
    fieldHargaController.dispose();
    fieldThnBuatController.dispose();
    // Form 2
    fieldAwController.dispose();
    fieldIsEqController.dispose();
    fieldIsFloodController.dispose();
    fieldIsSrccController.dispose();
    fieldIsTbodController.dispose();
    fieldIsTerrorismController.dispose();
    fieldPadController.dispose();
    fieldPapController.dispose();
    fieldPassangerCountController.dispose();
    fieldPllController.dispose();
    fieldTplController.dispose();
    // Form 3
    fieldDiskonPersenController.dispose();
    fieldPremiAddController.dispose();
    fieldPremiCascoController.dispose();
    fieldPremiDiskonController.dispose();
    fieldPremiNetController.dispose();
    fieldPremiSubtotalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calmv1CrudBloc = BlocProvider.of<Calmv1CrudBloc>(context);
    calmv2FormBloc = BlocProvider.of<Calmv2FormBloc>(context);
    calmv3FormBloc = BlocProvider.of<Calmv3FormBloc>(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<Calmv1CrudBloc, Calmv1CrudState>(
          listener: _handleCalmv1State,
        ),
        BlocListener<Calmv2FormBloc, Calmv2FormState>(
          listener: _handleCalmv2State,
        ),
        BlocListener<Calmv3FormBloc, Calmv3FormState>(
          listener: _handleCalmv3State,
        ),
      ],
      child: BaseBackgroundSidePage(
        title: "Kendaraan",
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            color: secondaryBlackColor,
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: vPadding),
                _buildForm1Section(),
                const SizedBox(height: 12),
                _buildForm2Section(),
                const SizedBox(height: 12),
                _buildForm3Section(),
                const SizedBox(height: 25),
                FormError(errors: errors, key: null),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loadData() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      calmv1CrudBloc.add(Calmv1CrudLihatEvent(recordId: widget.recordId!));
      calmv2FormBloc.add(Calmv2FormLihatEvent(recordId: widget.recordId!));
      calmv3FormBloc.add(Calmv3FormLihatEvent(recordId: widget.recordId!));
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SVG
          SvgPicture.asset("assets/icons/kendaraan.svg", width: 40, height: 40),
          const SizedBox(width: 10),

          // Teks Header
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Beli Polis', style: bodyTextStyle(context, fontSize: 20)),
                Text(
                  "Sebelum lanjut, pastikan data kamu sudah lengkap, ya!",
                  style: bodyTextStyle(
                    context,
                    fontSize: 16,
                  ).copyWith(color: hintGrey),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============= FORM 1 SECTION =============
  Widget _buildForm1Section() {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            title: Text('Data Kendaraan', style: bodyTextStyle(context)),
            trailing: AnimatedRotation(
              turns: _isForm1Expanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: SvgPicture.asset(
                'assets/icons/dropdown.svg',
                width: 16,
                height: 16,
              ),
            ),
            onTap: () => setState(() => _isForm1Expanded = !_isForm1Expanded),
          ),
          if (_isForm1Expanded)
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Form(
                key: _formKey1,
                child: Column(
                  children: [
                    buildFieldMmvgrupojkId(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Flexible(flex: 1, child: buildFieldMmvjnscoverId()),
                        const SizedBox(width: 8),
                        Flexible(flex: 1, child: buildFieldHarga()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Flexible(flex: 1, child: buildFieldCurrId()),
                        const SizedBox(width: 8),
                        Flexible(flex: 1, child: buildFieldThnBuat()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    buildFieldMwilayahId(),
                    const SizedBox(height: 12),
                    buildFieldCoverBulan(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildFieldMmvgrupojkId() {
    return ReusableComboBox<ComboMMvgrupOjkModel>(
      comboKey: comboMMvgrupOjkKey,
      hintText: "Jenis Kendaraan",
      initItem: fieldComboMMvgrupOjk,
      dataLoader: () => ComboMMvgrupOjkRepository().getComboMMvgrupOjk(),
      displayText: (item) => item.grupNama,
      compareItems: (a, b) => a.mmvgrupojkId == b.mmvgrupojkId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: "Field ComboMMvgrupOjk tidak boleh kosong.");
          calmv1CrudBloc.add(ComboMMvgrupOjkChangedEvent(comboMMvgrupOjk: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) fieldComboMMvgrupOjk = value;
      },
      validatorCallback: (value) {
        if (value == null) return kStringNullError;
        return null;
      },
    );
  }

  Widget buildFieldMmvjnscoverId() {
    return ReusableComboBox<ComboMMvjnscoverModel>(
      comboKey: comboMMvjnscoverKey,
      hintText: "Jenis Cover",
      initItem: fieldComboMMvjnscover,
      dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
      displayText: (item) => item.coverName,
      compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: "Field ComboMMvjnscover tidak boleh kosong.");
          calmv1CrudBloc.add(ComboMMvjnscoverChangedEvent(comboMMvjnscover: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) fieldComboMMvjnscover = value;
      },
      validatorCallback: (value) {
        if (value == null) return kStringNullError;
        return null;
      },
    );
  }

  Widget buildFieldMwilayahId() {
    return ReusableComboBox<ComboMWilayahModel>(
      comboKey: comboMWilayahKey,
      hintText: "Wilayah",
      initItem: fieldComboMWilayah,
      dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
      displayText: (item) => item.wilayahNama,
      compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: "Field ComboMWilayah tidak boleh kosong.");
          calmv1CrudBloc.add(ComboMWilayahChangedEvent(comboMWilayah: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) fieldComboMWilayah = value;
      },
      validatorCallback: (value) {
        if (value == null) return kStringNullError;
        return null;
      },
    );
  }

  Widget buildFieldThnBuat() {
    return appTextField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldThnBuatController,
      onChanged: (value) {
        if (value.isNotEmpty) removeError(error: kStringNullError);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: kStringNullError);
          return "";
        }
        return null;
      }, label: 'Tahun Buat',
    );
  }

  Widget buildFieldCoverBulan() {
    return appTextField(
      label: "Lama Cover",
      hint: "0",
      controller: fieldCoverBulanController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      suffix: Text("bulan", style: bodyTextStyle(context)),
      onChanged: (value) {
        if (value.isNotEmpty) removeError(error: kStringNullError);
      },
      validator: (value) {
        if (value == null || value.isEmpty) return kStringNullError;
        final clean = value.replaceAll(",", "");
        final lama = int.tryParse(clean);
        if (lama == null || lama <= 0) return "Lama cover harus lebih dari 0 bulan";
        if (lama > 120) return "Lama cover maksimal 120 bulan";
        return null;
      },
    );
  }

  Widget buildFieldCurrId() {
    return appTextField(
      controller: fieldCurrIdController,
      onChanged: (value) {
        if (value.isNotEmpty) removeError(error: kStringNullError);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: kStringNullError);
          return "";
        }
        return null;
      },
      label: 'Currency',
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
        if (value.isNotEmpty) removeError(error: kStringNullError);
      },
      validator: (value) {
        if (value == null || value.isEmpty) return kStringNullError;
        final cleanValue = value.replaceAll(",", "");
        final harga = double.tryParse(cleanValue);
        if (harga == null || harga <= 0) return kString0;
        return null;
      },
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    );
  }

  // ============= FORM 2 SECTION =============
  Widget _buildForm2Section() {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            title: Text('Perlindungan Tambahan', style: bodyTextStyle(context)),
            trailing: AnimatedRotation(
              turns: _isForm1Expanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: SvgPicture.asset(
                'assets/icons/dropdown.svg',
                width: 16,
                height: 16,
              ),
            ),
            subtitle: _savedCalmv1Id != null
                ? Text('Kendaraan ID: $_savedCalmv1Id', style: TextStyle(fontSize: 12, color: sGrey))
                : Text('Simpan Data Kendaraan terlebih dahulu', style: TextStyle(fontSize: 12, color: primaryColor)),
            onTap: () {
              if (_savedCalmv1Id == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBar('Simpan Data Kendaraan terlebih dahulu'),
                );
                return;
              }
              setState(() => _isForm2Expanded = !_isForm2Expanded);
            },
          ),
          if (_isForm2Expanded && _savedCalmv1Id != null)
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Form(
                key: _formKey2,
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
                  ],
                ),
              ),
            ),
        ],
      ),
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
        if (value == null || value.isEmpty) return kStringNullError;
        final awRate = double.tryParse(value);
        if (awRate == null || awRate < 0) return kString0;
        if (awRate > 100) return "Authorized Workshop tidak boleh lebih dari 100%";
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
        if (value == null || value.isEmpty) return kStringNullError;
        final clean = value.replaceAll(",", "");
        final pad = double.tryParse(clean);
        if (pad == null || pad <= 0) return kString0;
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
        if (value == null || value.isEmpty) return kStringNullError;
        final clean = value.replaceAll(",", "");
        final pap = double.tryParse(clean);
        if (pap == null || pap <= 0) return kString0;
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
        if (value == null || value.isEmpty) return kStringNullError;
        final clean = value.replaceAll(",", "");
        final count = int.tryParse(clean);
        if (count == null || count <= 0) return kString0;
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
        if (value == null || value.isEmpty) return kStringNullError;
        final clean = value.replaceAll(",", "");
        final pll = double.tryParse(clean);
        if (pll == null || pll <= 0) return kString0;
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
        if (value == null || value.isEmpty) return kStringNullError;
        final clean = value.replaceAll(",", "");
        final tpl = double.tryParse(clean);
        if (tpl == null || tpl <= 0) return kString0;
        return null;
      },
      suffix: Text(",000,000,-", style: bodyTextStyle(context)),
    );
  }

  // ============= FORM 3 SECTION =============
  Widget _buildForm3Section() {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            title: Text('Hasil Perhitungan Premi', style: bodyTextStyle(context)),
            trailing: AnimatedRotation(
              turns: _isForm1Expanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: SvgPicture.asset(
                'assets/icons/dropdown.svg',
                width: 16,
                height: 16,
              ),
            ),
            subtitle: _savedCalmv1Id != null
                ? Text('Kendaraan ID: $_savedCalmv1Id', style: TextStyle(fontSize: 12, color: sGrey))
                : Text('Simpan Data Kendaraan terlebih dahulu', style: TextStyle(fontSize: 12, color: primaryColor)),
            onTap: () {
              if (_savedCalmv1Id == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBar('Simpan Data Kendaraan terlebih dahulu'),
                );
                return;
              }
              setState(() => _isForm3Expanded = !_isForm3Expanded);
            },
          ),
          if (_isForm3Expanded && _savedCalmv1Id != null)
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Form(
                key: _formKey3,
                child: Column(
                  children: [
                    buildFieldDiskonPersen(),
                    const SizedBox(height: 12),
                    buildFieldPremiAdd(),
                    const SizedBox(height: 12),
                    buildFieldPremiCasco(),
                    const SizedBox(height: 12),
                    buildFieldPremiDiskon(),
                    const SizedBox(height: 12),
                    buildFieldPremiNet(),
                    const SizedBox(height: 12),
                    buildFieldPremiSubtotal(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildFieldDiskonPersen() {
    return appTextField(
      label: 'Persen Diskon',
      controller: fieldDiskonPersenController,
      enabled: false,
    );
  }

  Widget buildFieldPremiAdd() {
    return appTextField(
      label: 'Premi Tambahan',
      controller: fieldPremiAddController,
      enabled: false,
    );
  }

  Widget buildFieldPremiCasco() {
    return appTextField(
      label: 'Premi CASCO',
      controller: fieldPremiCascoController,
      enabled: false,
    );
  }

  Widget buildFieldPremiDiskon() {
    return appTextField(
      label: 'Premi Diskon',
      controller: fieldPremiDiskonController,
      enabled: false,
    );
  }

  Widget buildFieldPremiNet() {
    return appTextField(
      label: 'Net Premi',
      controller: fieldPremiNetController,
      enabled: false,
    );
  }

  Widget buildFieldPremiSubtotal() {
    return appTextField(
      label: 'Subtotal Premi',
      controller: fieldPremiSubtotalController,
      enabled: false,
    );
  }

  // ============= ACTION BUTTONS =============
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(child: AppButton.primary(
            text: 'Close',
            onPressed: () => Navigator.pop(context),
            backgroundColor: formGrey
        ),),
        const SizedBox( width: 8),
        Flexible(child: AppButton.primary(
          text: 'Save',
          onPressed: onSaveAllForms,
          backgroundColor: primaryColor,
        ),)
      ],
    );
  }

  // ============= BLOC LISTENERS =============
  void _handleCalmv1State(BuildContext context, Calmv1CrudState state) {
    debugPrint("========== [DEBUG: UI - LISTENER FORM1] ==========");
    debugPrint("🧩 isLoaded=${state.isLoaded}, isSaved=${state.isSaved}");
    debugPrint("🧩 hasFailure=${state.hasFailure}");
    debugPrint("🧩 record=${state.record?.toJson()}");
    debugPrint("=================================================");

    if (state.isLoaded) {
      if (state.record != null) {
        fieldCoverBulanController.text = state.record!.coverBulan.toString();
        fieldCurrIdController.text = state.record!.currId;
        fieldHargaController.text = NumberFormat("#,###").format(state.record!.harga);
        fieldThnBuatController.text = state.record!.thnBuat.toString();
      }
      fieldComboMMvgrupOjk = state.comboMMvgrupOjk;
      fieldComboMMvjnscover = state.comboMMvjnscover;
      fieldComboMWilayah = state.comboMWilayah;
    }

    if (state.isSaved) {
      if (state.hasFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Gagal menyimpan data Kendaraan')),
        );
      } else {
        final calmv1id = state.record?.calmv1Id ?? '';
        debugPrint("✅ Calmv1 berhasil disimpan dengan ID: $calmv1id");

        setState(() {
          _savedCalmv1Id = calmv1id;
          _isForm1Expanded = false;
          _isForm2Expanded = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Data Kendaraan disimpan (ID: $calmv1id)'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _handleCalmv2State(BuildContext context, Calmv2FormState state) {
    debugPrint("========== [DEBUG: UI - LISTENER FORM2] ==========");
    debugPrint("🧩 isLoaded=${state.isLoaded}, isSaved=${state.isSaved}");
    debugPrint("=================================================");

    if (state.isLoaded && state.record != null) {
      debugPrint("📦 [STATE LOADED] Record ditemukan:");
      debugPrint(state.record?.toJson().toString());

      fieldAwController.text = NumberFormat("#,###").format(state.record!.aw);
      fieldIsEqController.text = state.record!.isEq.toString();
      fieldIsFloodController.text = state.record!.isFlood.toString();
      fieldIsSrccController.text = state.record!.isSrcc.toString();
      fieldIsTbodController.text = state.record!.isTbod.toString();
      fieldIsTerrorismController.text = state.record!.isTerrorism.toString();
      fieldPadController.text = NumberFormat("#,###").format(state.record!.pad);
      fieldPapController.text = NumberFormat("#,###").format(state.record!.pap);
      fieldPassangerCountController.text = state.record!.passangerCount.toString();
      fieldPllController.text = NumberFormat("#,###").format(state.record!.pll);
      fieldTplController.text = NumberFormat("#,###").format(state.record!.tpl);
    }

    if (state.isSaved && !state.hasFailure) {
      setState(() {
        _isForm2Expanded = false;
        _isForm3Expanded = true;
      });

      calmv3FormBloc.add(Calmv3FormLoadDataEvent(calmv1Id: "251100013"));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔄 Memuat hasil premi dari server...')),
      );
    }
  }

  void _handleCalmv3State(BuildContext context, Calmv3FormState state) {
    debugPrint("========== [DEBUG: UI - LISTENER FORM3] ==========");
    debugPrint("🧩 isLoaded=${state.isLoaded}, isSaved=${state.isSaved}");
    debugPrint("=================================================");

    if (state.isLoaded && state.record != null) {
      fieldDiskonPersenController.text = state.record!.diskonPersen.toString();
      fieldPremiAddController.text = state.record!.premiAdd.toString();
      fieldPremiCascoController.text = state.record!.premiCasco.toString();
      fieldPremiDiskonController.text = state.record!.premiDiskon.toString();
      fieldPremiNetController.text = state.record!.premiNet.toString();
      fieldPremiSubtotalController.text = state.record!.premiSubtotal.toString();
    }

    if (state.isSaved && !state.hasFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Hasil premi tersimpan di database')),
      );
    }
  }

  // ============= SAVE LOGIC =============
  void onSaveAllForms() async {
    debugPrint("========== [SAVE ALL FORMS] ==========");

    // Jika Form 1 belum disimpan
    if (_savedCalmv1Id == null) {
      if (!_formKey1.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Lengkapi Form 1 terlebih dahulu')),
        );
        setState(() => _isForm1Expanded = true);
        return;
      }

      _formKey1.currentState!.save();

      try {
        Calmv1CrudModel record = Calmv1CrudModel(
          calmv1Id: '',
          coverBulan: int.parse(fieldCoverBulanController.text.replaceAll(',', '')),
          currId: fieldCurrIdController.text,
          harga: double.parse(fieldHargaController.text.replaceAll(',', '')),
          mmvgrupojkId: fieldComboMMvgrupOjk?.mmvgrupojkId,
          mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
          mwilayahId: fieldComboMWilayah?.mwilayahId,
          thnBuat: int.parse(fieldThnBuatController.text.replaceAll(',', '')),
        );

        debugPrint("📤 Menyimpan Form 1: ${record.toJson()}");

        if (widget.viewMode == "tambah") {
          calmv1CrudBloc.add(Calmv1CrudTambahEvent(record: record));
        } else if (widget.viewMode == "ubah") {
          record.calmv1Id = calmv1CrudBloc.state.record?.calmv1Id ?? '';
          calmv1CrudBloc.add(Calmv1CrudUbahEvent(record: record));
        }

        // Tunggu response dari bloc (akan di-handle di listener)
        await Future.delayed(const Duration(milliseconds: 800));

        if (_savedCalmv1Id == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠️ Menunggu ID dari Form 1...')),
          );
          return;
        }
      } catch (e) {
        debugPrint("Error saat parsing data Form 1: $e");
        addError(error: "Format data tidak valid: $e");
        return;
      }
    }

    // Simpan Form 2
    if (_isForm2Expanded || widget.viewMode == "ubah") {
      if (!_formKey2.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Lengkapi Form 2 terlebih dahulu')),
        );
        setState(() => _isForm2Expanded = true);
        return;
      }

      _formKey2.currentState!.save();

      final record2 = Calmv2FormModel(
        calmv2Id: widget.viewMode == "ubah" ? calmv2FormBloc.state.record?.calmv2Id ?? '' : '',
        calmv1Id: _savedCalmv1Id!,
        aw: double.tryParse(fieldAwController.text.replaceAll(',', '')) ?? 0,
        isEq: toBoolean(fieldIsEqController.text),
        isFlood: toBoolean(fieldIsFloodController.text),
        isSrcc: toBoolean(fieldIsSrccController.text),
        isTbod: toBoolean(fieldIsTbodController.text),
        isTerrorism: toBoolean(fieldIsTerrorismController.text),
        pad: double.tryParse(fieldPadController.text.replaceAll(',', '')) ?? 0,
        pap: double.tryParse(fieldPapController.text.replaceAll(',', '')) ?? 0,
        passangerCount: int.tryParse(fieldPassangerCountController.text.replaceAll(',', '')) ?? 0,
        pll: double.tryParse(fieldPllController.text.replaceAll(',', '')) ?? 0,
        tpl: double.tryParse(fieldTplController.text.replaceAll(',', '')) ?? 0,
      );

      debugPrint("📤 Menyimpan Form 2: ${record2.toJson()}");

      if (widget.viewMode == "tambah") {
        calmv2FormBloc.add(Calmv2FormTambahEvent(record: record2));
      } else {
        calmv2FormBloc.add(Calmv2FormUbahEvent(record: record2));
      }

      await Future.delayed(const Duration(milliseconds: 800));
    }

    // Simpan Form 3
    if (_isForm3Expanded || widget.viewMode == "ubah") {
      if (!_formKey3.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Lengkapi Form 3 terlebih dahulu')),
        );
        setState(() => _isForm3Expanded = true);
        return;
      }

      _formKey3.currentState!.save();

      Calmv3FormModel record3 = Calmv3FormModel(
        calmv3Id: widget.viewMode == "ubah" ? calmv3FormBloc.state.record?.calmv3Id ?? '' : '',
        calmv1Id: _savedCalmv1Id!,
        diskonPersen: double.parse(fieldDiskonPersenController.text.replaceAll(',', '')),
        premiAdd: double.parse(fieldPremiAddController.text.replaceAll(',', '')),
        premiCasco: double.parse(fieldPremiCascoController.text.replaceAll(',', '')),
        premiDiskon: double.parse(fieldPremiDiskonController.text.replaceAll(',', '')),
        premiNet: double.parse(fieldPremiNetController.text.replaceAll(',', '')),
        premiSubtotal: double.parse(fieldPremiSubtotalController.text.replaceAll(',', '')),
      );

      debugPrint("📤 Menyimpan Form 3: ${record3.toJson()}");

      if (widget.viewMode == "tambah") {
        calmv3FormBloc.add(Calmv3FormTambahEvent(record: record3));
      } else {
        calmv3FormBloc.add(Calmv3FormUbahEvent(record: record3));
      }
    }
  }

  // ============= HELPER FUNCTIONS =============
  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() => errors.add(error));
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() => errors.remove(error));
    }
  }
}