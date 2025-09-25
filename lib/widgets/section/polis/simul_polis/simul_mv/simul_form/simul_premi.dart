import 'package:joss_app/widgets/form_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

class SimulmvFormPremiPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulmvFormPremiPage(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulmvCrudFormPageFormPremiState createState() =>
      SimulmvCrudFormPageFormPremiState();
}

class SimulmvCrudFormPageFormPremiState
    extends State<SimulmvFormPremiPage> {
  late SimulmvCrudBloc simulmvCrudBloc;
  final _formKey = GlobalKey<FormState>();
  var fieldPremiAddController = TextEditingController();
  var fieldPremiCascoController = TextEditingController();
  var fieldPremiTotalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SimulmvCrudBloc>();

    return BlocConsumer<SimulmvCrudBloc, SimulmvCrudState>(
      listener: (context, state) {
        if ((state.isLoaded || state.isCalculated) && state.record != null) {
          final f = NumberFormat.decimalPattern('id');
          fieldPremiAddController.text   = f.format(state.record!.premiAdd ?? 0);
          fieldPremiCascoController.text = f.format(state.record!.premiCasco ?? 0);
          fieldPremiTotalController.text = f.format(state.record!.premiTotal ?? 0);
        }
      },
      buildWhen: (p, c) =>
      p.isCalculated != c.isCalculated ||
          p.isLoaded != c.isLoaded ||
          p.errors != c.errors,
      builder: (context, state) {
        return Column(
          children: [
            // ✅ TANPA tombol
            _buildReadOnlyField('Premi Casco', fieldPremiCascoController),
            const SizedBox(height: 8),
            _buildReadOnlyField('Premi Tambahan', fieldPremiAddController),
            const SizedBox(height: 8),
            _buildReadOnlyField('Premi Total', fieldPremiTotalController),
            const SizedBox(height: 16),
            FormError(errors: state.errors ?? [], key: null,),
          ],
        );
      },
    );
  }
  Widget _buildReadOnlyField(String label, TextEditingController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan custom decoration
        TextFormField(
          readOnly: true,
          textAlign: TextAlign.right,
          controller: c,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau (sama seperti field lainnya)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            // Background abu-abu muda untuk menunjukkan read-only
            fillColor: Colors.white,
            filled: true,
            labelText: null,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ],
    );
  }

// Revisi buildFieldPremiAdd dengan desain yang konsisten
  Widget buildFieldPremiAdd() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        const Text(
          'Premi Tambahan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan custom decoration
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [ThousandsSeparatorInputFormatter()],
          controller: fieldPremiAddController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            suffixText: ",-",
            suffixStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            labelText: null,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              //removeError(error: kStringNullError);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field Premi Tambahan tidak boleh kosong";
            }
            return null;
          },
        ),
      ],
    );
  }

// Revisi buildFieldPremiCasco dengan desain yang konsisten
  Widget buildFieldPremiCasco() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        const Text(
          'Premi Casco',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan custom decoration
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [ThousandsSeparatorInputFormatter()],
          controller: fieldPremiCascoController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            suffixText: ",-",
            suffixStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            labelText: null,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              //removeError(error: kStringNullError);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field Premi Casco tidak boleh kosong";
            }
            return null;
          },
        ),
      ],
    );
  }

// Revisi buildFieldPremiTotal dengan desain yang konsisten
  Widget buildFieldPremiTotal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        const Text(
          'Premi Total',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan custom decoration
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [ThousandsSeparatorInputFormatter()],
          controller: fieldPremiTotalController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            suffixText: ",-",
            suffixStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            labelText: null,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              //removeError(error: kStringNullError);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field Premi Total tidak boleh kosong";
            }
            return null;
          },
        ),
      ],
    );
  }
}
