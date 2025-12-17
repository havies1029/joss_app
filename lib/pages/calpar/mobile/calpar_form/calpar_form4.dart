import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/calpar/calpar4form_bloc.dart';
import 'package:joss_app/models/calpar/calpar4form_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Calpar4FormPage extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? calpar1Id;

  const Calpar4FormPage({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.calpar1Id,
  });

  @override
  Calpar4FormPageFormState createState() => Calpar4FormPageFormState();
}

class Calpar4FormPageFormState extends State<Calpar4FormPage> {
  final _calparform4key = GlobalKey<FormState>();

  final diskonPremiCtrl = TextEditingController();
  final netCtrl = TextEditingController();
  final subtotalCtrl = TextEditingController();
  late final Calpar4FormBloc calpar4Bloc;


  @override
  void initState() {
    super.initState();
    calpar4Bloc = context.read<Calpar4FormBloc>();
  }
  
  @override
  void dispose() {
    diskonPremiCtrl.dispose();
    netCtrl.dispose();
    subtotalCtrl.dispose();
    super.dispose();
  }
  
  void injectPayload(Calpar4FormModel record) {
    // diskonPremiCtrl.text = payload["discPersen"]?.toString() ?? "0";
    // netCtrl.text = payload["premiNet"]?.toString() ?? "0";
    // subtotalCtrl.text = payload["premiOther"]?.toString() ?? "0";
    //
    diskonPremiCtrl.text = record.discPersen.toString();
    netCtrl.text = record.premiNet.toString();
    subtotalCtrl.text = record.premiOther.toString();

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          _buildHeader(),
          if (widget.isExpanded) _buildForm(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: Text("Hasil Perhitungan Premi", style: bodyTextStyle(context)),
      trailing: AnimatedRotation(
        turns: widget.isExpanded ? 0.5 : 0,
        duration: const Duration(milliseconds: 250),
        child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
      ),
      onTap: () {
        widget.onToggle(!widget.isExpanded);
      },
    );
  }

  Widget _buildForm() {
    return MultiBlocListener(
      listeners: [
        BlocListener<Calpar4FormBloc, Calpar4FormState>(
          listenWhen: (prev, curr) =>
          curr.record != null,
          listener: (context, state) {
            injectPayload(state.record!);
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Form(
          key: _calparform4key,
          child: Column(
            children: [
              appTextField(
                label: 'Premi',
                controller: subtotalCtrl,
                enabled: false,
              ),

              const SizedBox(height: hPadding * 1.5),

              appTextField(
                label: 'Diskon',
                controller: diskonPremiCtrl,
                enabled: false,
              ),

              const SizedBox(height: hPadding * 1.5),

              appTextField(
                label: 'Net Premi',
                controller: netCtrl,
                enabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
