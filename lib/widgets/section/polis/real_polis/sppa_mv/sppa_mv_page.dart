import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/section/polis/real_polis/sppa_mv/sppa_form/sppamvcrud_form.dart';
import 'package:flutter/material.dart';

class SppaMvPage extends StatefulWidget {
  const SppaMvPage({super.key});

  @override
  State<SppaMvPage> createState() => _SppaMvPageState();
}

class _SppaMvPageState extends State<SppaMvPage> {
  final _formKey = GlobalKey<FormState>();
  final bool _showPremiSection = false;

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: 'Beli Polis Kendaraan',
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Container(
                width: double.infinity,
                color: secondaryBlackColor,
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(), const SizedBox(height: vPadding),
                      _buildProgressBar(), const SizedBox(height: 15),

                      // CASCO
                      Text("Data Kendaraan", style: bodyTextStyle(context)),
                      const SizedBox(height: 10),
                      SppamvFormPage(viewMode: "tambah", recordId: ""),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SVG di kanan bawahe.asset("assets/icons/kendaraan.svg", width: 40, height: 40),
          const SizedBox(width: 10),
          // Teks Header
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Beli Polis', style: bodyTextStyle(context, fontSize: 20)),
                Text(
                  "Sebelum lanjut, pastikan data kamu sudah lengkap, ya!",
                  style: bodyTextStyle(
                    context,
                    fontSize: 16,
                  ).copyWith(color: hintGrey),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: sGrey,
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _showPremiSection ? 1.0 : 0.33,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: vPadding),
        Text(
          _showPremiSection ? '100%' : '33%',
          style: bodyTextStyle(context, fontSize: 16),
        ),
      ],
    );
  }
}
