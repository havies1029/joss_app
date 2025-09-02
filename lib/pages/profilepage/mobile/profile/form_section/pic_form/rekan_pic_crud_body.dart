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
  final VoidCallback? onCancel;

  const MRekanPicCrudFormBody({
    super.key,
    this.viewMode = 'tambah',
    this.recordId = '',
    this.onCancel,
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

    print("[⚙️ INIT] Mode: ${widget.viewMode}, RecordID: ${widget.recordId}");

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

        if (state.isSaved) {
          if (widget.onCancel != null) {
            widget.onCancel!(); // Tutup form dan refresh list
          } else {
            Navigator.of(context).pop(); // Fallback jika tidak ada callback
          }
        }
      },
      child: BlocBuilder<MRekanPicCrudBloc, MRekanPicCrudState>(
        builder: (context, state) {
          if (!state.isLoaded) {
            return _buildLoadingState();
          }
          return _buildFormContent();
        },
      ),
    );
  }


  Widget _buildLoadingState() {
    return Container(
      color: Colors.grey.shade50,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Container(
      color: Colors.grey.shade50,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Form Card
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormField(
                        label: "Nama PIC",
                        child: _buildTextField(
                          controller: fieldPicNamaController,
                          hintText: "Masukkan nama",
                          prefixIcon: Icons.person_outline,
                        ),
                      ),

                      _buildFormField(
                        label: "Email",
                        child: _buildTextField(
                          controller: fieldPicEmailController,
                          hintText: "Masukkan email",
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),

                      _buildFormField(
                        label: "No. HP",
                        child: _buildTextField(
                          controller: fieldPicHpController,
                          hintText: "Masukkan nomor HP",
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ),

                      _buildFormField(
                        label: "Jabatan",
                        child: _buildDropdownField(),
                      ),

                      _buildFormField(
                        label: "Pengaturan",
                        child: _buildCheckboxField(),
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (widget.onCancel != null) {
                widget.onCancel!(); // hanya tutup form, tidak pop context
              }
            },
            icon: const Icon(Icons.arrow_back, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.grey.shade700,
              minimumSize: const Size(40, 40),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.viewMode == 'tambah' ? 'Tambah PIC' : 'Edit PIC',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Informasi Person in Charge',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onSaveForm,
            icon: const Icon(Icons.check, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: Colors.green.shade50,
              foregroundColor: Colors.green.shade700,
              minimumSize: const Size(40, 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        child,
        if (!isLast) const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
        ),
        prefixIcon: Icon(
          prefixIcon,
          size: 18,
          color: Colors.grey.shade500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade600,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: (value) => value == null || value.trim().isEmpty
          ? 'Field tidak boleh kosong'
          : null,
    );
  }

  Widget _buildDropdownField() {
    return FormField<ComboMJabatanModel>(
      validator: (value) {
        if (fieldComboMJabatan == null) return 'Jabatan harus dipilih';
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.hasError ? Colors.red : Colors.grey.shade300,
                  width: state.hasError ? 1 : 0.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: buildFieldComboMJabatan(
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
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCheckboxField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.star_outline,
            size: 18,
            color: Colors.grey.shade500,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Jadikan sebagai PIC default',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Switch(
            value: isDefaultChecked,
            onChanged: (value) {
              setState(() => isDefaultChecked = value);
            },
            activeColor: Colors.green.shade600,
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade300,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final isTambah = widget.viewMode == "tambah";
      final recordId = isTambah ? '' : (bloc.state.record?.mrekanpicId ?? '');
      print("[🟢 DEBUG] Saving Form with ID: $recordId");

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
    } else {
      print("[❌ DEBUG] Form is invalid");
    }
  }

}