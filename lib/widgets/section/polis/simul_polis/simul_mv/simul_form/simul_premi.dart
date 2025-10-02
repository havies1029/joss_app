import 'package:joss_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:intl/intl.dart';

class SimulmvFormPremiPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulmvFormPremiPage({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  SimulmvCrudFormPageFormPremiState createState() =>
      SimulmvCrudFormPageFormPremiState();
}

class SimulmvCrudFormPageFormPremiState extends State<SimulmvFormPremiPage> {
  late SimulmvCrudBloc simulmvCrudBloc;
  var fieldPremiAddController = TextEditingController();
  var fieldPremiCascoController = TextEditingController();
  var fieldPremiTotalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<SimulmvCrudBloc>();

    return BlocConsumer<SimulmvCrudBloc, SimulmvCrudState>(
      listener: (context, state) {
        if ((state.isLoaded || state.isCalculated) && state.record != null) {
          final f = NumberFormat.decimalPattern('id');
          fieldPremiAddController.text = f.format(state.record!.premiAdd ?? 0);
          fieldPremiCascoController.text = f.format(
            state.record!.premiCasco ?? 0,
          );
          fieldPremiTotalController.text = f.format(
            state.record!.premiTotal ?? 0,
          );
        }
      },
      buildWhen:
          (p, c) =>
              p.isCalculated != c.isCalculated ||
              p.isLoaded != c.isLoaded ||
              p.errors != c.errors,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: pGrey,
            borderRadius: BorderRadius.circular(cardBorderRadius),
          ),
          child: Column(
            children: [
              _buildReadOnlyField('Premi Casco', fieldPremiCascoController),
              const SizedBox(height: 12),
              _buildReadOnlyField('Premi Tambahan', fieldPremiAddController),
              const SizedBox(height: 12),
              _buildReadOnlyField('Premi Total', fieldPremiTotalController),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReadOnlyField(String label, TextEditingController controller) {
    return appTextField(
      label: label,
      controller: controller,
      keyboardType: TextInputType.number,
      enabled: false,
      hint: "0",
      prefix: Text("IDR | ", style: bodyTextStyle(context)),
      onTap: () {},
    );
  }
}
