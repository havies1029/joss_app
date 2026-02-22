import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../models/gen_calmv/calmv3form_model.dart';

class CalmvForm3Section extends StatefulWidget {
  final bool isExpanded;
  final ValueChanged<bool> onToggle;

  const CalmvForm3Section({
    super.key,
    required this.isExpanded,
    required this.onToggle,
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    diskonPremiCtrl.dispose();
    netCtrl.dispose();
    subtotalCtrl.dispose();
    super.dispose();
  }

  // DIPANGGIL OLEH PARENT
  void injectPayload(Calmv3FormModel? form3Record) {
    if (form3Record == null) return;
    setState(() {
      diskonPremiCtrl.text = form3Record.premiDiskon.toString();
      netCtrl.text = form3Record.premiNet.toString();
      subtotalCtrl.text = form3Record.premiSubtotal.toString();
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
              widget.onToggle(!widget.isExpanded);
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
