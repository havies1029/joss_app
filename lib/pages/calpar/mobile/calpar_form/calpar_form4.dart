import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/calpar/calpar4form_bloc.dart';
import 'package:joss_app/models/calpar/calpar4form_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Calpar4FormPage extends StatefulWidget {
  final bool isExpanded;

  final Map<String, dynamic>? initialPayload;

  const Calpar4FormPage({super.key,
    required this.isExpanded,
    this.initialPayload,});

  @override
  Calpar4FormPageFormState createState() => Calpar4FormPageFormState();
}

class Calpar4FormPageFormState extends State<Calpar4FormPage> {
  final diskonPremiCtrl = TextEditingController();
  final netCtrl = TextEditingController();
  final subtotalCtrl = TextEditingController();
  Map<String, dynamic>? _lastPayload;

  @override
  void initState() {
    super.initState();

    if (widget.initialPayload != null) {
      injectPayload(widget.initialPayload!);
    }
  }
  
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
      diskonPremiCtrl.text = payload["discPersen"]?.toString() ?? "0";
      netCtrl.text = payload["premiNet"]?.toString() ?? "0";
      subtotalCtrl.text = payload["premiOther"]?.toString() ?? "0";
    });
  }

  @override
  Widget build(BuildContext context) {
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
              // toggle kalau nanti mau
            },
          ),

          if (widget.isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "(Perhitungan 1 tahun)",
                    style: bodyTextStyle(context).copyWith(
                      color: primaryColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: hPadding * 1.5),

                  appTextField(
                    label: 'Subtotal Premi',
                    controller: subtotalCtrl,
                    enabled: false,
                  ),

                  const SizedBox(height: hPadding * 1.5),

                  appTextField(
                    label: 'Premi Diskon',
                    controller: diskonPremiCtrl,
                    enabled: false,
                  ),

                  const SizedBox(height: hPadding * 1.5),

                  appTextField(
                    label: 'Premi Bersih',
                    controller: netCtrl,
                    enabled: false,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
