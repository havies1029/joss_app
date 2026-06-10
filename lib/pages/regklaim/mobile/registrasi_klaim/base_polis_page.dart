import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/user_non_polis_page.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/user_polis_page.dart';

import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../blocs/regklaim/polissourcecari_bloc.dart';
import '../../../../models/regklaim/sppapoliscari_model.dart';
import 'button_klaim/button_polis_source.dart';

class BasePolisPage extends StatelessWidget {
  final String cobKlaimId;
  final String cobKlaimNama;
  final SppapoliscariModel? selectedPolis;
  final ValueChanged<SppapoliscariModel?> onPolisChanged;

  const BasePolisPage({
    super.key,
    required this.cobKlaimId,
    required this.cobKlaimNama,
    required this.selectedPolis,
    required this.onPolisChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        final userType = authState is AuthenticationAuthenticated
            ? authState.user.userType.toUpperCase()
            : '';

        if (userType == 'U') {
          return UserNonPolisPage(
            cobKlaimId: cobKlaimId,
            cobKlaimNama: cobKlaimNama,
          );
        }

        return BlocBuilder<PolissourcecariBloc, PolissourcecariState>(
          builder: (context, state) {
            Widget content;

            switch (state.selectedPolissourceId) {
              case "10":
                content = UserPolisPage(
                  cobKlaimId: cobKlaimId,
                  cobKlaimNama: cobKlaimNama,
                  selectedPolis: selectedPolis,
                  onPolisChanged: onPolisChanged,
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
      },
    );
  }
}