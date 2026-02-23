import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../blocs/gen_calmv/calmv1crud_bloc.dart';
import '../../../../blocs/gen_calmv/calmv3form_bloc.dart';
import '../../../../widgets/hitung_premi_widget.dart';

class CalmvForm3Section2 extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const CalmvForm3Section2({
    super.key,
    required this.formKey,
  });

  @override
  State<CalmvForm3Section2> createState() => CalmvForm3Section2State();
}


class CalmvForm3Section2State extends State<CalmvForm3Section2> {
  final _calmvform3key = GlobalKey<FormState>();

  final fieldDiskonPersenController = TextEditingController();
  final fieldPremiAddController = TextEditingController();
  final fieldPremiCascoController = TextEditingController();
  final fieldPremiDiskonController = TextEditingController();
  final fieldPremiNetController = TextEditingController();
  final fieldPremiSubtotalController = TextEditingController();
  final fieldCalmv1IdController = TextEditingController();

  late final Calmv3FormBloc calmv3Bloc;
  late final Calmv1CrudBloc calmv1Bloc;
  late String calmv1Id;

  @override
  void initState() {
    super.initState();
    calmv3Bloc = context.read<Calmv3FormBloc>();
    calmv1Bloc = context.read<Calmv1CrudBloc>();
    Future.microtask(_loadData);
  }


  void _loadData() {
    final calmv1State = context
        .read<Calmv1CrudBloc>()
        .state;
    calmv1Id = calmv1State.record!.calmv1Id;

    if (calmv1Id.isNotEmpty == true) {
      calmv3Bloc.add(Calmv3FormLihatEvent(calmv1Id: calmv1Id));
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
    return BlocConsumer<Calmv3FormBloc, Calmv3FormState>(
      listenWhen: (prev, curr) =>
      prev.isLoaded != curr.isLoaded || prev.record != curr.record,
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          final r = state.record!;
          fieldDiskonPersenController.text = r.diskonPersen.toString();
          fieldPremiAddController.text = r.premiAdd.toString();
          fieldPremiCascoController.text = r.premiCasco.toString();

          fieldPremiDiskonController.text = r.premiDiskon.toString();
          fieldPremiNetController.text = r.premiNet.toString();
          fieldPremiSubtotalController.text = r.premiSubtotal.toString();

          setState(() {});
        }
      },
      buildWhen: (prev, curr) =>
      prev.isLoaded != curr.isLoaded || prev.record != curr.record,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Form(
            key: _calmvform3key,
            child: Column(
              children: [
                HitungPremiWidget(
                  rows: [
                    HitungPremiRow(
                      label: "Premi",
                      controller: fieldPremiSubtotalController,
                      layoutType: HitungPremiLayoutType.vertical,
                      showValueBorder: true,
                      formatNumber: true,
                      // valuePrefix: fieldComboUang?.rmatauangSimbol ?? "",
                    ),
                    HitungPremiRow(
                      label: "Diskon",
                      controller: fieldPremiDiskonController,
                      layoutType: HitungPremiLayoutType.vertical,
                      showValueBorder: true,
                      formatNumber: true,
                      // valuePrefix: fieldComboUang?.rmatauangSimbol ?? "",
                    ),
                    HitungPremiRow(
                      label: "Net Premi",
                      controller: fieldPremiNetController,
                      layoutType: HitungPremiLayoutType.vertical,
                      showValueBorder: true,
                      formatNumber: true,
                      // valuePrefix: fieldComboUang?.rmatauangSimbol ?? "",
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}