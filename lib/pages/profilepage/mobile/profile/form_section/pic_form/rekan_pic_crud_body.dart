import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpiccrud_model.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';
import 'package:joss_app/widgets/combobox/combomjabatan_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';

class MRekanPicCrudFormBody extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const MRekanPicCrudFormBody({
    super.key,
    this.viewMode = 'tambah',
    this.recordId = '',
  });

  @override
  State<MRekanPicCrudFormBody> createState() => _MRekanPicCrudFormBodyState();
}

class _MRekanPicCrudFormBodyState extends State<MRekanPicCrudFormBody> {
  late MRekanPicCrudBloc bloc;
  final _formKey = GlobalKey<FormState>();

  final fieldPicEmailController = TextEditingController();
  final fieldPicHpController = TextEditingController();
  final fieldPicNamaController = TextEditingController();

  final comboMJabatanKey = GlobalKey<DropdownSearchState<ComboMJabatanModel>>();
  ComboMJabatanModel? fieldComboMJabatan;
  bool isDefaultChecked = false;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<MRekanPicCrudBloc>(context);

    Future.delayed(Duration.zero, () {
      if (widget.viewMode == 'ubah' && widget.recordId.isNotEmpty) {
        bloc.add(MRekanPicCrudLihatEvent(recordId: widget.recordId));
      } else {
        clearAllFields();
        bloc.emit(bloc.state.copyWith(
          isLoaded: true,
          record: null,
          comboMJabatan: null,
        ));
      }
    });
  }

  @override
  void didUpdateWidget(covariant MRekanPicCrudFormBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.recordId != oldWidget.recordId && widget.viewMode == 'ubah') {
      context.read<MRekanPicCrudBloc>().add(
        MRekanPicCrudLihatEvent(recordId: widget.recordId),
      );
    }
  }

  void clearAllFields() {
    fieldPicEmailController.clear();
    fieldPicHpController.clear();
    fieldPicNamaController.clear();
    fieldComboMJabatan = null;
    isDefaultChecked = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
      listener: (context, state) {
        if (state.isLoaded && state.record != null && widget.viewMode == 'ubah') {
          final record = state.record!;
          setState(() {
            isDefaultChecked = record.isDefault ?? false;
            fieldPicEmailController.text = record.picEmail ?? '';
            fieldPicHpController.text = record.picHp ?? '';
            fieldPicNamaController.text = record.picNama ?? '';
            fieldComboMJabatan = state.comboMJabatan;
          });
        }
      },
      child: BlocBuilder<MRekanPicCrudBloc, MRekanPicCrudState>(
        builder: (context, state) {
          if (!state.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildFormContent();
        },
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: onSaveForm,
                  child: const Text('Simpan'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('Nama PIC'),
            TextFormField(
              controller: fieldPicNamaController,
              decoration: const InputDecoration(
                hintText: 'Masukkan nama',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Field tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 16),

            const Text('Email'),
            TextFormField(
              controller: fieldPicEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Masukkan email',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Field tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 16),

            const Text('No. HP'),
            TextFormField(
              controller: fieldPicHpController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Masukkan nomor HP',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Field tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 16),

            const Text('Jabatan'),
            FormField<ComboMJabatanModel>(
              validator: (value) {
                if (fieldComboMJabatan == null) return 'Jabatan harus dipilih';
                return null;
              },
              builder: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildFieldComboMJabatan(
                      comboKey: comboMJabatanKey,
                      labelText: 'Pilih Jabatan',
                      initItem: fieldComboMJabatan,
                      onChangedCallback: (value) {
                        setState(() => fieldComboMJabatan = value);
                        state.didChange(value);
                      },
                      onSaveCallback: (value) => fieldComboMJabatan = value,
                      validatorCallback: (_) {},
                    ),
                    if (state.hasError)
                      Text(
                        state.errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Checkbox(
                  value: isDefaultChecked,
                  onChanged: (value) {
                    setState(() => isDefaultChecked = value ?? false);
                  },
                ),
                const Text('Jadikan sebagai PIC default'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final isTambah = widget.viewMode == "tambah";
      final recordId = isTambah ? '' : (bloc.state.record?.mrekanpicId ?? '');

      final record = MRekanPicCrudModel(
        isDefault: isDefaultChecked,
        mjabatanId: fieldComboMJabatan?.mjabatanId,
        mrekanpicId: recordId,
        picEmail: fieldPicEmailController.text,
        picHp: fieldPicHpController.text,
        picNama: fieldPicNamaController.text,
      );

      if (isTambah) {
        bloc.add(MRekanPicCrudTambahEvent(record: record));
      } else {
        bloc.add(MRekanPicCrudUbahEvent(record: record));
      }
    }
  }
}