import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_regmv/regmv6form_bloc.dart';
import 'package:joss_app/models/gen_regmv/regmv6form_model.dart';

class Regmv6FormFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;
  final String? parentRegmv1Id;

  const Regmv6FormFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    this.parentRegmv1Id,
  });

  @override
  Regmv6FormFormPageFormState createState() => Regmv6FormFormPageFormState();
}

class Regmv6FormFormPageFormState extends State<Regmv6FormFormPage> {
  late Regmv6FormBloc regmv6FormBloc;

  // controller (readonly)
  final fieldDiskonPersenController = TextEditingController();
  final fieldPremiAddController = TextEditingController();
  final fieldPremiAwController = TextEditingController();
  final fieldPremiCascoController = TextEditingController();
  final fieldPremiDiskonController = TextEditingController();
  final fieldPremiEqController = TextEditingController();
  final fieldPremiFloodController = TextEditingController();
  final fieldPremiNetController = TextEditingController();
  final fieldPremiPadController = TextEditingController();
  final fieldPremiPapController = TextEditingController();
  final fieldPremiPllController = TextEditingController();
  final fieldPremiSrccController = TextEditingController();
  final fieldPremiSubtotalController = TextEditingController();
  final fieldPremiTbodController = TextEditingController();
  final fieldPremiTerrorismController = TextEditingController();
  final fieldPremiTjhController = TextEditingController();

  NumberFormat get _moneyFmt => NumberFormat("#,##0");

  @override
  void initState() {
    super.initState();

    debugPrint(
      "[Regmv6Form] initState -> viewMode=${widget.viewMode}, "
          "regmv6Id=${widget.recordId}, parentRegmv1Id=${widget.parentRegmv1Id}",
    );

    // Load data existing kalau mode ubah/liat
    Future.delayed(const Duration(milliseconds: 300), () {
      if ((widget.viewMode == "ubah" || widget.viewMode == "lihat") &&
          widget.recordId.isNotEmpty) {
        regmv6FormBloc.add(
          Regmv6FormLihatEvent(recordId: widget.recordId),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    regmv6FormBloc = BlocProvider.of<Regmv6FormBloc>(context);

    return BlocConsumer<Regmv6FormBloc, Regmv6FormState>(
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          final r = state.record!;

          fieldDiskonPersenController.text = _moneyFmt.format(r.diskonPersen);
          fieldPremiAddController.text = _moneyFmt.format(r.premiAdd);
          fieldPremiAwController.text = _moneyFmt.format(r.premiAw);
          fieldPremiCascoController.text = _moneyFmt.format(r.premiCasco);
          fieldPremiDiskonController.text = _moneyFmt.format(r.premiDiskon);
          fieldPremiEqController.text = _moneyFmt.format(r.premiEq);
          fieldPremiFloodController.text = _moneyFmt.format(r.premiFlood);
          fieldPremiNetController.text = _moneyFmt.format(r.premiNet);
          fieldPremiPadController.text = _moneyFmt.format(r.premiPad);
          fieldPremiPapController.text = _moneyFmt.format(r.premiPap);
          fieldPremiPllController.text = _moneyFmt.format(r.premiPll);
          fieldPremiSrccController.text = _moneyFmt.format(r.premiSrcc);
          fieldPremiSubtotalController.text =
              _moneyFmt.format(r.premiSubtotal);
          fieldPremiTbodController.text = _moneyFmt.format(r.premiTbod);
          fieldPremiTerrorismController.text =
              _moneyFmt.format(r.premiTerrorism);
          fieldPremiTjhController.text = _moneyFmt.format(r.premiTjh);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Perhitungan premi berhasil diambil")),
          );
        }

        if (state.hasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal mengambil perhitungan premi")),
          );
        }
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: pGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER TANPA EXPANSION =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Perhitungan Premi",
                    style: bodyTextStyle(context),
                  ),
                  Row(
                    children: [
                      if (state.isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      TextButton.icon(
                        onPressed: _onHitungPremi,
                        icon: const Icon(Icons.calculate, size: 18),
                        label: const Text("Hitung"),
                        style: TextButton.styleFrom(
                          foregroundColor: primaryLightColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ===== CONTENT LANGSUNG TAMPIL (NO EXPANSION) =====
              _buildField("Diskon (%)", fieldDiskonPersenController),
              const SizedBox(height: 12),
              _buildField("Premi Tambahan", fieldPremiAddController),
              const SizedBox(height: 12),
              _buildField("Premi AW", fieldPremiAwController),
              const SizedBox(height: 12),
              _buildField("Premi CASCO", fieldPremiCascoController),
              const SizedBox(height: 12),
              _buildField("Diskon Premi", fieldPremiDiskonController),
              const SizedBox(height: 12),
              _buildField("Premi EQ", fieldPremiEqController),
              const SizedBox(height: 12),
              _buildField("Premi Flood", fieldPremiFloodController),
              const SizedBox(height: 12),
              _buildField("Net Premi", fieldPremiNetController),
              const SizedBox(height: 12),
              _buildField("Premi PAD", fieldPremiPadController),
              const SizedBox(height: 12),
              _buildField("Premi PAP", fieldPremiPapController),
              const SizedBox(height: 12),
              _buildField("Premi PLL", fieldPremiPllController),
              const SizedBox(height: 12),
              _buildField("Premi SRCC", fieldPremiSrccController),
              const SizedBox(height: 12),
              _buildField("Subtotal Premi", fieldPremiSubtotalController),
              const SizedBox(height: 12),
              _buildField("Premi TBOD", fieldPremiTbodController),
              const SizedBox(height: 12),
              _buildField("Premi Terorisme", fieldPremiTerrorismController),
              const SizedBox(height: 12),
              _buildField("Premi TJH", fieldPremiTjhController),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return appTextField(
      label: label,
      controller: controller,
      keyboardType: TextInputType.number,
      enabled: false,
      prefix: Text("IDR | ", style: bodyTextStyle(context)),
      hint: "0",
    );
  }

  void _onHitungPremi() {
    final regmv1Id = widget.parentRegmv1Id ?? "";

    if (regmv1Id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("regmv1Id belum tersedia. Simpan Form 1 dahulu."),
        ),
      );
      return;
    }

    regmv6FormBloc.add(CalPremiRegMvEvent(regmv1Id: regmv1Id));
  }
}
