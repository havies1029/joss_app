import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_calmv/calmv1crud_bloc.dart';
import 'package:joss_app/models/gen_calmv/calmv1crud_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:joss_app/repositories/combobox/combomwilayah_repository.dart';

import '../../blocs/gen_calmv/calmv2form_bloc.dart';
import '../../repositories/combobox/combommvgrupojk_repository.dart';
import '../../repositories/combobox/combommvjnscover_repository.dart';
import '../base/base_background_sidepage.dart';
import 'calmv2form_form.dart';

class Calmv1CrudFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const Calmv1CrudFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  Calmv1CrudFormPageFormState createState() => Calmv1CrudFormPageFormState();
}

class Calmv1CrudFormPageFormState extends State<Calmv1CrudFormPage> {
  late Calmv1CrudBloc calmv1CrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldCoverBulanController = TextEditingController();
  var fieldCurrIdController = TextEditingController();
  var fieldHargaController = TextEditingController();
  ComboMMvgrupOjkModel? fieldComboMMvgrupOjk;
  final comboMMvgrupOjkKey =
      GlobalKey<DropdownSearchState<ComboMMvgrupOjkModel>>();
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  final comboMMvjnscoverKey =
      GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();
  ComboMWilayahModel? fieldComboMWilayah;
  final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();
  var fieldThnBuatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    calmv1CrudBloc = BlocProvider.of<Calmv1CrudBloc>(context);

    return BlocConsumer<Calmv1CrudBloc, Calmv1CrudState>(
      builder: (context, state) {
        return BaseBackgroundSidePage(
          title: "Kendaraan",
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Container(
                width: double.infinity,
                color: secondaryBlackColor,
                padding: EdgeInsets.all(15),
                child: Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(flex: 1, child: buildFieldMmvgrupojkId()),
                          const SizedBox(width: 8),
                          Flexible(flex: 1, child: buildFieldThnBuat()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Flexible(flex: 1, child: buildFieldMmvjnscoverId()),
                          const SizedBox(width: 8),
                          Flexible(flex: 1, child: buildFieldHarga()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      buildFieldMwilayahId(),
                      const SizedBox(height: 12),
                      buildFieldCurrId(),
                      const SizedBox(height: 12),
                      // _buildHeader(), const SizedBox(height: vPadding),
                      buildFieldCoverBulan(),
                      const SizedBox(height: 25),
                      FormError(errors: errors, key: null),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _dismissDialog();
                                },
                                child: const Text(
                                  'Close',
                                  style: TextStyle(fontSize: 13.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  onSaveForm();
                                },
                                child: const Text(
                                  'Save',
                                  style: TextStyle(fontSize: 13.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        debugPrint("========== [DEBUG: UI - LISTENER FORM1] ==========");
        debugPrint("🧩 isLoaded=${state.isLoaded}, isSaved=${state.isSaved}");
        debugPrint("🧩 hasFailure=${state.hasFailure}");
        debugPrint("🧩 record=${state.record?.toJson()}");
        debugPrint("=================================================");
        if (state.isLoaded) {
          if (state.record != null) {
            fieldCoverBulanController.text =
                state.record!.coverBulan.toString();
            fieldCurrIdController.text = state.record!.currId;
            fieldHargaController.text = NumberFormat(
              "#,###",
            ).format(state.record!.harga);
            fieldThnBuatController.text = state.record!.thnBuat.toString();
          }
          fieldComboMMvgrupOjk = state.comboMMvgrupOjk;
          fieldComboMMvjnscover = state.comboMMvjnscover;
          fieldComboMWilayah = state.comboMWilayah;
        }

        if (state.isSaved) {
          if (state.hasFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('❌ Gagal menyimpan data Calmv1')),
            );
          } else {
            final calmv1id = state.record?.calmv1Id ?? '';
            debugPrint("✅ Calmv1 berhasil disimpan dengan ID: $calmv1id");

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '✅ Data Calmv1 disimpan (ID: $calmv1id), lanjut ke Form 2',
                ),
              ),
            );

            Future.delayed(const Duration(milliseconds: 400), () async {
              if (!mounted) return;

              final returnedId = await showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: BlocProvider.of<Calmv2FormBloc>(context),
                        ),
                      ],
                      child: Calmv2FormFormPage(
                        viewMode: "tambah",
                        recordId: "",
                        calmv1Id: calmv1id,
                      ),
                    ),
              );

              // 🔹 Setelah Form2 selesai (user klik save / close)
              if (!mounted) return;
              Navigator.pop(
                context,
                returnedId ?? calmv1id,
              ); // ⬅ baru sekarang pop balik ke caller
            });
          }
        }
      },
    );
  }

  void loadData() {
    if (widget.viewMode == "ubah") {
      calmv1CrudBloc.add(Calmv1CrudLihatEvent(recordId: widget.recordId));
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

  Widget buildFieldCoverBulan() {
    return appTextField(
      label: "Lama Cover",
      hint: "0",
      controller: fieldCoverBulanController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      suffix: Text("bulan", style: bodyTextStyle(context)),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
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

  Widget buildFieldCurrId() {
    return appTextField(
      controller: fieldCurrIdController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
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
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
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
          calmv1CrudBloc.add(
            ComboMMvgrupOjkChangedEvent(comboMMvgrupOjk: value),
          );
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMMvgrupOjk = value;
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
          calmv1CrudBloc.add(
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

  Widget buildFieldThnBuat() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      controller: fieldThnBuatController,
      decoration: const InputDecoration(
        labelText: "thnBuat",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: kStringNullError);
          return "";
        }
        return null;
      },
      textAlign: TextAlign.right,
    );
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void onSaveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        Calmv1CrudModel record = Calmv1CrudModel(
          calmv1Id: '',
          // Hapus separator sebelum parsing
          coverBulan: int.parse(
            fieldCoverBulanController.text.replaceAll(',', ''),
          ),
          currId: fieldCurrIdController.text,
          harga: double.parse(fieldHargaController.text.replaceAll(',', '')),
          mmvgrupojkId: fieldComboMMvgrupOjk?.mmvgrupojkId,
          mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
          mwilayahId: fieldComboMWilayah?.mwilayahId,
          // Hapus separator sebelum parsing
          thnBuat: int.parse(fieldThnBuatController.text.replaceAll(',', '')),
        );

        debugPrint("========== [DEBUG: Calmv1CrudForm] ==========");
        debugPrint("ViewMode: ${widget.viewMode}");
        debugPrint("Record dikirim: ${record.toJson()}");
        debugPrint("=============================================");

        if (widget.viewMode == "tambah") {
          calmv1CrudBloc.add(Calmv1CrudTambahEvent(record: record));
        } else if (widget.viewMode == "ubah") {
          record.calmv1Id = calmv1CrudBloc.state.record?.calmv1Id ?? '';
          calmv1CrudBloc.add(Calmv1CrudUbahEvent(record: record));
        }

        // Tunggu response dari bloc
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          _dismissDialog();
        }
      } catch (e) {
        debugPrint("Error saat parsing data: $e");
        addError(error: "Format data tidak valid: $e");
      }
    } else {
      debugPrint("Form validation GAGAL!");
      debugPrint("Errors: $errors");
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}
