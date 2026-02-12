import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/user_non_polis_page.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/user_polis_page.dart';

import '../../../../blocs/regklaim/polissourcecari_bloc.dart';
import 'button_klaim/button_polis_source.dart';

class BasePolisPage extends StatelessWidget {
  final String cobKlaimId;
  final String cobKlaimNama;

  const BasePolisPage({
    super.key,
    required this.cobKlaimId,
    required this.cobKlaimNama,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PolissourcecariBloc, PolissourcecariState>(
      builder: (context, state) {
        Widget content;

        switch (state.selectedPolissourceId) {
          case "10":
            content = UserPolisPage(
              cobKlaimId: cobKlaimId,
              cobKlaimNama: cobKlaimNama,
            );
            break;

          case "20":
            content = UserNonPolisPage(
              cobKlaimId: cobKlaimId,
              cobKlaimNama: cobKlaimNama,
            );
            break;

          default:
            content = const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ButtonPolisSourceWidget(),
            content,
          ],
        );
      },
    );
  }
}
