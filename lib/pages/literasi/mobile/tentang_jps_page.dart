import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

import '../widgets/company_profile_widget.dart';
import '../../../widgets/klien_jps_widget.dart';
import '../widgets/milestone_jps_widget.dart';
import '../widgets/peran_jps_widget.dart';
import '../widgets/tentang_jps_widget.dart';
import '../../../widgets/testimoni_widget.dart';

class TentangJPSPage extends StatefulWidget {
  const TentangJPSPage({super.key});

  @override
  State<TentangJPSPage> createState() => _TentangJPSPageState();
}

class _TentangJPSPageState extends State<TentangJPSPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBlackColor,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // 🔹 Tentang JPS
              TentangCardWidget(),
              const SizedBox(height: 40),

              // 🔹 Company Profile
              CompanyProfileCard(),
              const SizedBox(height: 40),

              // 🔹 Testimoni
              TestimonialSection(),
              const SizedBox(height: 40),

              // 🔹 Klien
              ClientSection(),
            ],
          ),
        ),
      ),
    );
  }
}
