import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/section/polis/real_polis/sppa_par/sppa_form/sppaparcrud_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../common/constants.dart';

class SppaParPage extends StatefulWidget {
  const SppaParPage({super.key});

  @override
  State<SppaParPage> createState() => _SppaParPageState();
}

class _SppaParPageState extends State<SppaParPage> {
  final _formKey = GlobalKey<FormState>();
  final bool _showPremiSection = true;

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: 'Beli Polis Properti',
      child:  LayoutBuilder(
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

                      Text("Data Properti", style: bodyTextStyle(context)),
                      SppaparFormPage(viewMode: "tambah", recordId: ""),
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
          // SVG
          SvgPicture.asset("assets/icons/properti.svg", width: 40, height: 40),
          const SizedBox(width: 10),

          // Teks Header
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Polis Rumah & Properti',
                  style: bodyTextStyle(context, fontSize: 20),
                ),
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
              widthFactor: _showPremiSection ? 1.0 : 0.5,
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
          _showPremiSection ? '100%' : '50%',
          style: bodyTextStyle(context, fontSize: 16),
        ),
      ],
    );
  }
}