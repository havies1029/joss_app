import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/gen_regmv/regmv6form_bloc.dart';
import '../../../../models/gen_regmv/regmv6form_model.dart';


class RegmvForm7Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regmv1Id;

  const RegmvForm7Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regmv1Id,
  });

  @override
  State<RegmvForm7Section> createState() => RegmvForm7SectionState();
}


class RegmvForm7SectionState extends State<RegmvForm7Section> {
  final _regmvform6key = GlobalKey<FormState>();
  final diskonPremiCtrl = TextEditingController();
  final netCtrl = TextEditingController();
  final subtotalCtrl = TextEditingController();

  bool _isPayloadInjected = false;
  late final Regmv6FormBloc regmv6Bloc;

  @override
  void initState() {
    super.initState();
    regmv6Bloc = context.read<Regmv6FormBloc>();
  }

  @override
  void dispose() {
    diskonPremiCtrl.dispose();
    netCtrl.dispose();
    subtotalCtrl.dispose();
    super.dispose();
  }

  void onOpenedByParent() {
    if (widget.viewMode == "ubah" && widget.regmv1Id != null) {
      regmv6Bloc.add(Regmv6FormLihatEvent(recordId: widget.regmv1Id!));
    }
  }

  void _injectPayload(Regmv6FormModel record) {
    debugPrint("🔥 Injecting payload into Form1...");

    diskonPremiCtrl.text = record.premiDiskon.toString();
    netCtrl.text = record.premiNet.toString();
    subtotalCtrl.text = record.premiSubtotal.toString();

    setState(() {});

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
        BlocListener<Regmv6FormBloc, Regmv6FormState>(
          listenWhen: (prev, curr) =>
          curr.isLoaded == true && curr.record != null && !_isPayloadInjected,
          listener: (context, state) {
            _injectPayload(state.record!);
            _isPayloadInjected = true;
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Form(
          key: _regmvform6key,
          child: Column(
            children: [
              appTextField(
                label: 'Diskon Premi',
                controller: diskonPremiCtrl,
                enabled: false,
              ),

              const SizedBox(height: hPadding * 1.5),

              appTextField(
                label: 'Net Premi',
                controller: netCtrl,
                enabled: false,
              ),

              const SizedBox(height: hPadding * 1.5),

              appTextField(
                label: 'Sub total',
                controller: subtotalCtrl,
                enabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

}