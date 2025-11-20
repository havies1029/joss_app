import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

import '../../../../blocs/gen_regmv/regmv1crud_bloc.dart';
import '../../../../models/gen_regmv/regmv1crud_model.dart';

class RegmvForm1Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regmv1id;

  const RegmvForm1Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regmv1id
  });

  @override
  State<RegmvForm1Section> createState() => RegmvForm1SectionState();
}


class RegmvForm1SectionState extends State<RegmvForm1Section> {
  final _regmvform1key = GlobalKey<FormState>();

  final fieldCalmv1IdController = TextEditingController();
  final fieldTtgAlamatController = TextEditingController();
  final fieldTtgNamaController = TextEditingController();

  late final Regmv1CrudBloc regmv1Bloc;

  @override
  void initState() {
    super.initState();
    regmv1Bloc = context.read<Regmv1CrudBloc>();
    Future.microtask(_loadData);
  }

  void _loadData() {
    if (widget.viewMode == "ubah" && widget.recordId != null) {
      regmv1Bloc.add(Regmv1CrudLihatEvent(recordId: widget.recordId!));
    }
  }


  @override
  void dispose() {
    fieldCalmv1IdController.dispose();
    fieldTtgAlamatController.dispose();
    fieldTtgNamaController.dispose();
    super.dispose();
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
      title: Text("Data Tertanggung", style: bodyTextStyle(context)),
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
    return BlocBuilder<Regmv1CrudBloc, Regmv1CrudState>(
      buildWhen: (prev, curr) => curr.isLoaded == true,
      builder: (context, state) {
        if (state.isLoaded && state.record != null) {
          _injectPayload(state.record!);
        }
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Form(
            key: _regmvform1key,
            child: Column(
              children: [
                buildFieldCalmv1Id(),
                const SizedBox(height: 12),
                buildFieldTtgAlamat(),
                const SizedBox(height: 12),
                buildFieldTtgNama(),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  void _injectPayload(Regmv1CrudModel record) {
    debugPrint("🔥 Injecting payload into Form1...");

    // Text Controllers
    fieldCalmv1IdController.text = record.calmv1Id.toString();
    fieldTtgAlamatController.text = record.ttgAlamat.toString();
    fieldTtgNamaController.text = record.ttgNama.toString();

    setState(() {});
  }


  Future<bool> validateAndReturn() async {
    return _regmvform1key.currentState?.validate() ?? false;
  }


  Future<void> saveForm1() async {
    final record = Regmv1CrudModel(
      calmv1Id: widget.recordId!,
      regmv1Id: widget.recordId!, //nanti diganti ini jadi nerima parameter dari parents
      ttgAlamat: fieldTtgAlamatController.text ?? "",
      ttgNama: fieldTtgNamaController.text ?? "",
    );

    if (widget.viewMode == "tambah") {
      debugPrint("ini tambah loh di trigger di regmvform1");
      regmv1Bloc.add(Regmv1CrudTambahEvent(record: record));
    } else {
      debugPrint("ini ubah loh di trigger di regmvform1");
      regmv1Bloc.add(Regmv1CrudUbahEvent(record: record));
    }

  }

  Widget buildFieldCalmv1Id() => appTextField(
    label: "No SPPA",
    controller: fieldCalmv1IdController,
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
      ThousandsSeparatorInputFormatter(),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      return null;
    },
  );

  Widget buildFieldTtgAlamat() => appTextField(
    label: "Nama Tertanggung",
    controller: fieldTtgAlamatController,
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      return null;
    },
  );

  Widget buildFieldTtgNama() => appTextField(
    label: "Alamat Tertanggung",
    controller: fieldTtgNamaController,
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ,.]')),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return kStringNullError;
      return null;
    },
  );

}