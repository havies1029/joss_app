import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_regmv/regmv1crud_bloc.dart';
import 'package:joss_app/models/gen_regmv/regmv1crud_model.dart';

class Regmv1CrudFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;
  final bool initiallyExpanded;
  final void Function(String regmv1Id)? onRegmv1Created;
  final VoidCallback? onAccordionClose;

  const Regmv1CrudFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    this.initiallyExpanded = false,
    this.onRegmv1Created,
    this.onAccordionClose,
  });

  @override
  State<Regmv1CrudFormPage> createState() => Regmv1CrudFormPageState();
}

class Regmv1CrudFormPageState extends State<Regmv1CrudFormPage> {
  late Regmv1CrudBloc regmv1CrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  final fieldCalmv1IdController = TextEditingController();
  final fieldTtgAlamatController = TextEditingController();
  final fieldTtgNamaController = TextEditingController();

  String? _currentRegmv1Id;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), loadData);
  }

  void loadData() {
    if (widget.viewMode == "ubah" && widget.recordId.isNotEmpty) {
      regmv1CrudBloc.add(Regmv1CrudLihatEvent(recordId: widget.recordId));
    }
  }

  void saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final record = Regmv1CrudModel(
        calmv1Id: fieldCalmv1IdController.text,
        regmv1Id: _currentRegmv1Id ?? '',
        ttgAlamat: fieldTtgAlamatController.text,
        ttgNama: fieldTtgNamaController.text,
      );

      // Jika sudah ada regmv1Id, berarti update. Jika belum, berarti tambah
      if (_currentRegmv1Id != null && _currentRegmv1Id!.isNotEmpty) {
        debugPrint("[FORM1] Updating existing record: $_currentRegmv1Id");
        regmv1CrudBloc.add(Regmv1CrudUbahEvent(record: record));
      } else {
        debugPrint("[FORM1] Creating new record");
        regmv1CrudBloc.add(Regmv1CrudTambahEvent(record: record));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    regmv1CrudBloc = BlocProvider.of<Regmv1CrudBloc>(context);

    return BlocConsumer<Regmv1CrudBloc, Regmv1CrudState>(
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          fieldCalmv1IdController.text = state.record!.calmv1Id;
          fieldTtgAlamatController.text = state.record!.ttgAlamat;
          fieldTtgNamaController.text = state.record!.ttgNama;
          _currentRegmv1Id = state.record!.regmv1Id;
        }

        // 🔥 setelah tambah/update berhasil
        if (state.isSaved && !state.hasFailure && state.record != null) {
          final newId = state.record!.regmv1Id;
          debugPrint("🔥 [FORM1] regmv1Id from state = $newId");

          if (newId != null && newId.isNotEmpty) {
            setState(() => _currentRegmv1Id = newId);

            if (widget.onRegmv1Created != null) {
              widget.onRegmv1Created!(newId);
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data berhasil disimpan')),
            );
          }
        }

        if (state.hasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menyimpan data'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return  Form(
          key: _formKey,
          child: Column(
            children: [
              buildFieldCalmv1Id(),
              const SizedBox(height: 12),
              buildFieldTtgNama(),
              const SizedBox(height: 12),
              buildFieldTtgAlamat(),
            ],
          ),
        );
      },
    );
  }

  Widget buildFieldCalmv1Id() => appTextField(
    label: "No SPPA",
    controller: fieldCalmv1IdController,
    validator: (value) {
      if (value == null || value.isEmpty) {
        addError(error: kStringNullError);
        return "";
      }
      return null;
    },
  );

  Widget buildFieldTtgAlamat() => appTextField(
    label: "Alamat Tertanggung",
    controller: fieldTtgAlamatController,
    keyboardType: TextInputType.multiline,
    maxLines: 3,
    validator: (value) {
      if (value == null || value.isEmpty) {
        addError(error: kStringNullError);
        return "";
      }
      return null;
    },
  );

  Widget buildFieldTtgNama() => appTextField(
    label: "Nama Tertanggung",
    controller: fieldTtgNamaController,
    keyboardType: TextInputType.name,
    validator: (value) {
      if (value == null || value.isEmpty) {
        addError(error: kStringNullError);
        return "";
      }
      return null;
    },
  );

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

  @override
  void dispose() {
    fieldCalmv1IdController.dispose();
    fieldTtgAlamatController.dispose();
    fieldTtgNamaController.dispose();
    super.dispose();
  }
}