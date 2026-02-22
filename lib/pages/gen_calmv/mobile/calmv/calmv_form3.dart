import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';


class CalmvForm3Section extends StatefulWidget {
  final bool isExpanded;

  final Map<String, dynamic>? initialPayload;

  const CalmvForm3Section({
    super.key,
    required this.isExpanded,
    this.initialPayload,
  });

  @override
  State<CalmvForm3Section> createState() => CalmvForm3SectionState();
}

class CalmvForm3SectionState extends State<CalmvForm3Section> {
  final diskonPremiCtrl = TextEditingController();
  final netCtrl = TextEditingController();
  final subtotalCtrl = TextEditingController();

  final _rupiah0 = NumberFormat.decimalPattern('id_ID'); // 1.234.567

  String formatIntRupiah(dynamic v) {
    if (v == null) return "0";
    final n = (v is num) ? v : num.tryParse(v.toString());
    if (n == null) return "0";
    return _rupiah0.format(n.round()); // atau floor()
  }

  Map<String, dynamic>? _lastPayload;

  @override
  void initState() {
    super.initState();

    // Jika parent pertama kali ngirim payload → inject
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
      diskonPremiCtrl.text = formatIntRupiah(payload["diskonPremi"]);
      netCtrl.text        = formatIntRupiah(payload["netPremi"]);
      subtotalCtrl.text   = formatIntRupiah(payload["subtotalPremi"]);
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
