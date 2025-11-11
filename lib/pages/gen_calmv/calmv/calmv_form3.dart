import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import '../../../blocs/reusable_connection_flow/reusable_connection_flow_bloc.dart';
import '../../../blocs/reusable_connection_flow/reusable_connection_flow_state.dart';

class CalmvForm3Section extends StatefulWidget {
  final bool isExpanded;

  const CalmvForm3Section({
    super.key,
    required this.isExpanded,
  });

  @override
  State<CalmvForm3Section> createState() => _CalmvForm3SectionState();
}

class _CalmvForm3SectionState extends State<CalmvForm3Section> {
  final diskonPremiCtrl = TextEditingController();
  final netCtrl = TextEditingController();
  final subtotalCtrl = TextEditingController();

  @override
  void dispose() {
    diskonPremiCtrl.dispose();
    netCtrl.dispose();
    subtotalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReusableConnectionFlow, ReusableConnectionFlowState>(
      builder: (context, state) {
        final flow = context.read<ReusableConnectionFlow>();

        // 🧩 Update textfields ketika data premi berubah
        final data = state.sharedData;
        if (data != null && data.length >= 3) {
          diskonPremiCtrl.text = data[0];
          netCtrl.text = data[1];
          subtotalCtrl.text = data[2];
        } else {
          diskonPremiCtrl.clear();
          netCtrl.clear();
          subtotalCtrl.clear();
        }

        return Card(
          color: pGrey,
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                title: Text(
                  'Hasil Perhitungan Premi',
                  style: bodyTextStyle(context),
                ),
                trailing: AnimatedRotation(
                  turns: widget.isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onTap: () {
                  // ⛔ Hindari transisi ganda
                  if (flow.state.isTransitioning || flow.state.isLoading) return;
                  flow.moveTo("form3");
                },
              ),
              if (widget.isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Column(
                    children: [
                      appTextField(
                        label: 'Premi Diskon',
                        controller: diskonPremiCtrl,
                        enabled: false,
                      ),
                      const SizedBox(height: 12),
                      appTextField(
                        label: 'Net Premi',
                        controller: netCtrl,
                        enabled: false,
                      ),
                      const SizedBox(height: 12),
                      appTextField(
                        label: 'Subtotal Premi',
                        controller: subtotalCtrl,
                        enabled: false,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
