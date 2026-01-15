import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/regpar/regpar5form_bloc.dart';
import '../../../../models/regpar/regpar5form_model.dart';


class RegparForm6Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regpar1Id;

  const RegparForm6Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regpar1Id,
  });

  @override
  State<RegparForm6Section> createState() => RegparForm6SectionState();
}


class RegparForm6SectionState extends State<RegparForm6Section> {
  final _regparform6key = GlobalKey<FormState>();
  final diskonNilaiCtrl = TextEditingController();
  final premiNetCtrl = TextEditingController();
  final premiCtrl = TextEditingController();
  late final Regpar5FormBloc regpar5Bloc;
  final _rupiah0 = NumberFormat.decimalPattern('id_ID');

  String formatIntRupiah(dynamic v) {
    if (v == null) return "0";
    final n = (v is num) ? v : num.tryParse(v.toString());
    if (n == null) return "0";
    return _rupiah0.format(n.round()); // atau floor()
  }

  @override
  void initState() {
    super.initState();
    regpar5Bloc = context.read<Regpar5FormBloc>();
    // Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      regpar5Bloc.add(Regpar5FormLihatEvent(recordId: widget.regpar1Id!));
    }
  }

  @override
  void dispose() {
    diskonNilaiCtrl.dispose();
    premiNetCtrl.dispose();
    premiCtrl.dispose();
    super.dispose();
  }

  // void onOpenedByParent() {
  //   if (widget.viewMode == "ubah" && widget.regpar1Id != null) {
  //     regpar5Bloc.add(Regpar5FormLihatEvent(recordId: widget.regpar1Id!));
  //   }
  // }

  void _injectPayload(Regpar5FormModel record) {
    debugPrint("🔥 Injecting payload into Form6...");

    diskonNilaiCtrl.text = formatIntRupiah(record.diskonNilai);
    premiNetCtrl.text = formatIntRupiah(record.premiNet);
    premiCtrl.text = formatIntRupiah(record.premiTotal);

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
        BlocListener<Regpar5FormBloc, Regpar5FormState>(
          listenWhen: (prev, curr) =>
          curr.record != null,
          listener: (context, state) {
            _injectPayload(state.record!);
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Form(
          key: _regparform6key,
          child: Column(
            children: [
              appTextField(
                label: 'Premi',
                controller: premiCtrl,
                enabled: false,
              ),

              const SizedBox(height: hPadding * 1.5),

              appTextField(
                label: 'Diskon',
                controller: diskonNilaiCtrl,
                enabled: false,
              ),

              const SizedBox(height: hPadding * 1.5),

              appTextField(
                label: 'Net Premi',
                controller: premiNetCtrl,
                enabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
