import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/regklaim/mobile/main_page/rasio/klaim_rasio_main_page.dart';
import 'package:joss_app/widgets/apptheme/empty_state_page.dart';

import '../../../../blocs/klaimrasio/klaimrasiocobcari_bloc.dart';

class KlaimRasioTab extends StatefulWidget {
  const KlaimRasioTab({super.key});

  @override
  State<KlaimRasioTab> createState() => _KlaimRasioTabState();
}

class _KlaimRasioTabState extends State<KlaimRasioTab> {
  bool hasData = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<KlaimrasiocobCariBloc, KlaimrasiocobCariState>(
          listener: (context, state) {
            if (state.status == ListStatus.failure) {
              setState(() {
                hasData = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gagal memuat data rasio klaim'),
                ),
              );
            }

            if (state.status == ListStatus.success) {
              setState(() {
                hasData = state.klaimRasio.cobs.isNotEmpty;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: secondaryBlackColor,
        body: hasData
            ? const KlaimRasioMainPage()
            : const _EmptyKlaimRasioView(),
      ),
    );
  }
}

class _EmptyKlaimRasioView extends StatelessWidget {
  const _EmptyKlaimRasioView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: secondaryBlackColor,
      child: const Center(
        child: EmptyStatePage(
          iconPath: 'assets/icons/belipolis_no_file.svg',
          title: 'Tidak ada Rasio Klaim',
          description: 'Informasi rasio klaim akan muncul di sini ketika tersedia.',
        ),
      ),
    );
  }
}