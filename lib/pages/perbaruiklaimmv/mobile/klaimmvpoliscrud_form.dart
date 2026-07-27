import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/plat_nomor_formatter.dart';
import 'package:joss_app/repositories/combobox/combominsurer_repository.dart';
import 'package:joss_app/repositories/combobox/combommvjnscover_repository.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvpoliscrud_bloc.dart';
import 'package:joss_app/models/combobox/combominsurer_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../blocs/gen_regmv/polis_tanggal_bloc.dart';
import '../../../blocs/gen_regmv/polis_tanggal_event.dart';
import '../../../blocs/gen_regmv/polis_tanggal_state.dart';
import '../../../common/rangka_no_formatter.dart';
import '../../../widgets/apptheme/dropdown2.dart';

class KlaimmvpoliscrudFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;
  final GlobalKey<FormState> formKey;

  const KlaimmvpoliscrudFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    required this.formKey,
  });

  @override
  KlaimmvpoliscrudFormPageFormState createState() =>
      KlaimmvpoliscrudFormPageFormState();
}

class KlaimmvpoliscrudFormPageFormState
    extends State<KlaimmvpoliscrudFormPage> {
  late KlaimmvpoliscrudBloc klaimmvpoliscrudBloc;

  final fieldInsuredNamaController = TextEditingController();
  final fieldLaporAsuransiController = TextEditingController();
  final fieldNoChasisController = TextEditingController();
  final fieldNoPlatController = TextEditingController();
  final fieldPolisNoController = TextEditingController();
  final fieldSppa1IdController = TextEditingController();

  ComboMInsurerModel? fieldComboMInsurer;
  final comboMInsurerKey = GlobalKey<DropdownSearchState<ComboMInsurerModel>>();

  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  final comboMMvjnscoverKey =
      GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();

  bool isPolisJps = false;
  bool _useLoadedPolisTanggal = false;
  DateTime? _loadedPolisMulai;
  DateTime? _loadedPolisBerakhir;

  final Map<String, String?> fieldErrors = {};

  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() {
      fieldErrors[key] = msg;
    });
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() {
      fieldErrors.remove(key);
    });
  }

  void clearErrsByPrefix(String prefix) {
    setState(() {
      fieldErrors.removeWhere((k, _) => k.startsWith(prefix));
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), loadData);
  }

  @override
  void dispose() {
    fieldInsuredNamaController.dispose();
    fieldLaporAsuransiController.dispose();
    fieldNoChasisController.dispose();
    fieldNoPlatController.dispose();
    fieldPolisNoController.dispose();
    fieldSppa1IdController.dispose();
    super.dispose();
  }

  bool runFullValidation() {
    final ok = validateForm();
    widget.formKey.currentState?.validate();
    return ok;
  }

  bool validateForm() {
    clearErrsByPrefix('form.');

    bool ok = true;

    final insuredNama = fieldInsuredNamaController.text.trim();
    if (insuredNama.isEmpty) {
      setErr('form.insuredNama', 'Nama Tertanggung tidak boleh kosong');
      ok = false;
    }

    final laporAsuransi =
        DateTime.tryParse(fieldLaporAsuransiController.text.trim());
    if (!isPolisJps && laporAsuransi == null) {
      setErr('form.laporAsuransi', 'Lapor Asuransi tidak boleh kosong');
      ok = false;
    }

    final noPlat = fieldNoPlatController.text.trim();
    if (noPlat.isEmpty) {
      setErr('form.noPlat', 'No Plat tidak boleh kosong');
      ok = false;
    }

    final noChasis = fieldNoChasisController.text.trim();
    if (noChasis.isEmpty) {
      setErr('form.noChasis', 'No Chasis tidak boleh kosong');
      ok = false;
    }

    if (!isPolisJps && fieldComboMInsurer == null) {
      setErr('form.minsurerId', 'Asuransi tidak boleh kosong.');
      ok = false;
    }

    final polisNo = fieldPolisNoController.text.trim();
    if (!isPolisJps && polisNo.isEmpty) {
      setErr('form.polisNo', 'Polis No tidak boleh kosong');
      ok = false;
    }

    if (!isPolisJps && fieldComboMMvjnscover == null) {
      setErr('form.mmvjnscoverId', 'Jenis Cover tidak boleh kosong.');
      ok = false;
    }

    final sppa1Id = fieldSppa1IdController.text.trim();
    if (isPolisJps && sppa1Id.isEmpty) {
      setErr('form.sppa1Id', kStringNullError);
      ok = false;
    }

    final polisTanggalState = context.read<PolisTanggalBloc>().state;
    final polisMulai = _currentPolisMulai(polisTanggalState);
    final polisBerakhir = _currentPolisBerakhir(polisTanggalState);

    if (!isPolisJps && polisMulai == null) {
      setErr('form.polisMulai', 'Polis Mulai tidak boleh kosong');
      ok = false;
    }

    if (!isPolisJps && polisBerakhir == null) {
      setErr('form.polisBerakhir', 'Polis Akhir tidak boleh kosong');
      ok = false;
    }

    return ok;
  }

  void loadData() {
    if (widget.viewMode == "ubah") {
      // klaimmvpoliscrudBloc
      // 		.add(KlaimmvpoliscrudLihatEvent(recordId: widget.recordId));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    klaimmvpoliscrudBloc = BlocProvider.of<KlaimmvpoliscrudBloc>(context);

    return BlocConsumer<KlaimmvpoliscrudBloc, KlaimmvpoliscrudState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(child: buildFieldPolisMulai()),
                    const SizedBox(width: 8),
                    Flexible(child: buildFieldPolisBerakhir()),
                  ],
                ),
                const SizedBox(height: hPadding),
                buildFieldLaporAsuransi(),
                const SizedBox(height: hPadding),
                buildFieldInsuredNama(),
                const SizedBox(height: hPadding),
                buildFieldNoPlat(),
                const SizedBox(height: hPadding),
                buildFieldNoChasis(),
                const SizedBox(height: hPadding),
                buildFieldMinsurerId(),
                const SizedBox(height: hPadding),
                buildFieldPolisNo(),
                const SizedBox(height: hPadding),
                buildFieldMmvjnscoverId(),
                if (isPolisJps) ...[
                  const SizedBox(height: hPadding),
                  buildFieldSppa1Id(),
                ],
                const SizedBox(height: hPadding),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.isLoaded) {
          if (state.record != null) {
            fieldInsuredNamaController.text = state.record!.insuredNama;
            fieldLaporAsuransiController.text =
                state.record!.laporAsuransi?.toIso8601String() ?? '';
            fieldNoChasisController.text = state.record!.noChasis;
            fieldNoPlatController.text = state.record!.noPlat;
            fieldPolisNoController.text = state.record!.polisNo;
            fieldSppa1IdController.text = state.record!.sppa1Id;

            _loadedPolisMulai = state.record!.polisMulai;
            _loadedPolisBerakhir = state.record!.polisAkhir;
            _useLoadedPolisTanggal = true;

            final mulai = state.record!.polisMulai;
            if (mulai != null) {
              context.read<PolisTanggalBloc>().add(PolisMulaiChanged(mulai));
            }
          }

          fieldComboMInsurer = state.comboMInsurer;
          fieldComboMMvjnscover = state.comboMMvjnscover;
          isPolisJps = state.record?.isPolisJps ?? false;
        }
      },
      buildWhen: (previous, current) => previous.isLoaded != current.isLoaded,
      listenWhen: (previous, current) => previous.isLoaded != current.isLoaded,
    );
  }

  Widget buildFieldInsuredNama() {
    return appTextField(
      label: 'Tertanggung',
      enabled: !isPolisJps,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      controller: fieldInsuredNamaController,
      errorText: err('form.insuredNama'),
      validator: (_) => err('form.insuredNama'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          clearErr('form.insuredNama');
        }
        klaimmvpoliscrudBloc
            .add(FieldInsuredNamaChangedEvent(insuredNama: value));
      },
    );
  }

  Widget buildFieldLaporAsuransi() {
    return AppDateField(
      label: 'Tanggal ke Asuransi',
      lastDate: DateTime(2100),
      firstDate: DateTime(2000),
      enabled: !isPolisJps,
      initialValue: DateTime.tryParse(fieldLaporAsuransiController.text),
      validator: (_) => err('form.laporAsuransi'),
      // errorText: err('form.laporAsuransi'),
      onChanged: (value) {
        if (value != null) {
          clearErr('form.laporAsuransi');
          fieldLaporAsuransiController.text = value.toIso8601String();
          klaimmvpoliscrudBloc
              .add(FieldLaporAsuransiChangedEvent(laporAsuransi: value));
        }
      },
    );
  }

  Widget buildFieldMinsurerId() {
    return ReusableComboBoxV2<ComboMInsurerModel>(
      hintText: 'Asuransi',
      comboKey: comboMInsurerKey,
      initItem: fieldComboMInsurer,
      isEnabled: !isPolisJps,
      loader: (q) {
        return ComboMInsurerRepository().getComboMInsurer(q.searchText);
      },
      displayText: (item) => item.insurerNama,
      compareItems: (item, selectedItem) =>
          item.minsurerId == selectedItem.minsurerId,
      errorText: err('form.minsurerId'),
      validatorCallback: (v) => v == null ? kStringNullError : null,
      onChangedCallback: (value) {
        if (isPolisJps) return;
        setState(() {
          fieldComboMInsurer = value;
          if (value != null) {
            clearErr('form.minsurerId');
          }
        });
        if (value != null) {
          klaimmvpoliscrudBloc.add(
            ComboMInsurerChangedEvent(comboMInsurer: value),
          );
        }
      },
      onSaveCallback: (value) {
        fieldComboMInsurer = value;
      },
    );
  }

  Widget buildFieldMmvjnscoverId() {
    return ReusableComboBoxV2<ComboMMvjnscoverModel>(
      hintText: "Jenis Cover",
      comboKey: comboMMvjnscoverKey,
      isEnabled: !isPolisJps,
      initItem: fieldComboMMvjnscover,
      loader: (q) => ComboMMvjnscoverRepository().getComboMMvjnscover(),
      clientSideSearch: true,
      displayText: (i) => i.coverName,
      compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
      errorText: err('form.mmvjnscoverId'),
      validatorCallback: (v) => v == null ? kStringNullError : null,
      onChangedCallback: (value) {
        if (isPolisJps) return;
        setState(() {
          fieldComboMMvjnscover = value;
          if (value != null) {
            clearErr('form.mmvjnscoverId');
          }
        });
        if (value != null) {
          klaimmvpoliscrudBloc.add(
            ComboMMvjnscoverChangedEvent(comboMMvjnscover: value),
          );
        }
      },
      onSaveCallback: (value) {
        fieldComboMMvjnscover = value;
      },
    );
  }

  Widget buildFieldNoChasis() {
    return appTextField(
      label: 'No Rangka',
      controller: fieldNoChasisController,
      inputFormatters: [
        RangkaNoFormatter(),
      ],
      errorText: err('form.noChasis'),
      validator: (_) => err('form.noChasis'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          clearErr('form.noChasis');
        }
        klaimmvpoliscrudBloc.add(FieldNoChasisChangedEvent(noChasis: value));
      },
    );
  }

  Widget buildFieldNoPlat() {
    return appTextField(
      label: 'No Plat',
      controller: fieldNoPlatController,
      inputFormatters: [
        PlatNomorFormatter(),
      ],
      errorText: err('form.noPlat'),
      validator: (_) => err('form.noPlat'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          clearErr('form.noPlat');
        }
        klaimmvpoliscrudBloc.add(FieldNoPlatChangedEvent(noPlat: value));
      },
    );
  }

  Widget buildFieldPolisMulai() {
    return BlocBuilder<PolisTanggalBloc, PolisTanggalState>(
      buildWhen: (prev, curr) => prev.mulai != curr.mulai,
      builder: (context, state) {
        final today = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );

        return AppDateField(
          label: 'Tanggal Mulai',
          initialValue: _currentPolisMulai(state),
          firstDate: today,
          lastDate: DateTime(2100),
          enabled: !isPolisJps,
          // errorText: err('form.polisMulai'),
          validator: (_) => err('form.polisMulai'),
          onChanged: (dt) {
            if (dt == null) return;
            clearErr('form.polisMulai');
            setState(() {
              _useLoadedPolisTanggal = true;
              _loadedPolisMulai = dt;
              _loadedPolisBerakhir = DateTime(dt.year + 1, dt.month, dt.day);
            });
            context.read<PolisTanggalBloc>().add(PolisMulaiChanged(dt));
            klaimmvpoliscrudBloc
                .add(FieldPolisMulaiChangedEvent(polisMulai: dt));
          },
        );
      },
    );
  }

  Widget buildFieldPolisBerakhir() {
    return BlocBuilder<PolisTanggalBloc, PolisTanggalState>(
      buildWhen: (prev, curr) => prev.berakhir != curr.berakhir,
      builder: (context, state) {
        return AppDateField(
          key: ValueKey(
            (_currentPolisBerakhir(state)?.toIso8601String()) ??
                'empty_berakhir',
          ),
          label: 'Tanggal Berakhir',
          enabled: !isPolisJps,
          initialValue: _currentPolisBerakhir(state),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          // errorText: err('form.polisBerakhir'),
          validator: (_) => err('form.polisBerakhir'),
          onChanged: (dt) {
            if (dt == null) return;
            clearErr('form.polisBerakhir');
            setState(() {
              _useLoadedPolisTanggal = true;
              _loadedPolisBerakhir = dt;
            });
            klaimmvpoliscrudBloc
                .add(FieldPolisAkhirChangedEvent(polisAkhir: dt));
          },
        );
      },
    );
  }

  Widget buildFieldPolisNo() {
    return appTextField(
      label: 'No Polis',
      enabled: !isPolisJps,
      controller: fieldPolisNoController,
      errorText: err('form.polisNo'),
      validator: (_) => err('form.polisNo'),
      onChanged: (value) {
        if (isPolisJps) return;
        if (value.trim().isNotEmpty) {
          clearErr('form.polisNo');
        }
        klaimmvpoliscrudBloc.add(FieldPolisNoChangedEvent(polisNo: value));
      },
    );
  }

  Widget buildFieldSppa1Id() {
    return appTextField(
      label: 'ID SPPA',
      enabled: false,
      controller: fieldSppa1IdController,
      errorText: err('form.sppa1Id'),
      validator: (_) => err('form.sppa1Id'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          clearErr('form.sppa1Id');
        }
      },
    );
  }

  DateTime? _currentPolisMulai(PolisTanggalState state) {
    if (_useLoadedPolisTanggal) {
      return _loadedPolisMulai;
    }
    return state.mulai;
  }

  DateTime? _currentPolisBerakhir(PolisTanggalState state) {
    if (_useLoadedPolisTanggal) {
      return _loadedPolisBerakhir;
    }
    return state.berakhir;
  }
}
