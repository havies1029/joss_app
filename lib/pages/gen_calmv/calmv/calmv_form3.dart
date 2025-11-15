import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:path/path.dart';
import '../../../blocs/gen_calmv/calmv3form_bloc.dart';
import '../../../blocs/reusable_connection_flow/flow_parent_state.dart';
import '../../../blocs/reusable_connection_flow/flow_parent_cubit.dart';

class CalmvForm3Section extends StatefulWidget {
  final bool isExpanded;

  const CalmvForm3Section({
    super.key,
    required this.isExpanded,
  });

  @override
  State<CalmvForm3Section> createState() => CalmvForm3SectionState();
}

class CalmvForm3SectionState extends State<CalmvForm3Section> {
  final diskonPremiCtrl = TextEditingController();
  final netCtrl = TextEditingController();
  final subtotalCtrl = TextEditingController();
  Map<String, dynamic>? _lastPayload;

  @override
  void dispose() {
    diskonPremiCtrl.dispose();
    netCtrl.dispose();
    subtotalCtrl.dispose();
    super.dispose();
  }
  void injectPayload(Map<String, dynamic> payload) {
    _lastPayload = payload;
    setState(() {
      diskonPremiCtrl.text = payload["diskonPremi"].toString();
      netCtrl.text = payload["netPremi"].toString();
      subtotalCtrl.text = payload["subtotalPremi"].toString();
    });
  }


  void activate() {
    setState(() {});
    if (_lastPayload != null) {
      injectPayload(_lastPayload!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<Calmv3FormBloc, Calmv3FormState>(
      listener: (context, state) {
        if (state.isLoaded && state.record != null) {
          final r = state.record!;
          debugPrint("🔥 [Form3] Listener nerima data premi: ${r.toJson()}");

          injectPayload({
            "diskonPremi": r.premiDiskon ?? 0,
            "netPremi": r.premiNet ?? 0,
            "subtotalPremi": r.premiSubtotal ?? 0,
          });

          debugPrint("🔥 [Form3] Inject sukses → "
              "diskon=${r.premiDiskon}, net=${r.premiNet}, subtotal=${r.premiSubtotal}");

          context.read<FlowParentCubit>().onSaveResult(
            index: 3,
            id: r.calmv3Id ?? "DONE", // kasih simbol saja
          );
        }
      },
      child: Card(
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
                // kalau butuh toggle nanti isi
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
      ),
    );
  }


}
