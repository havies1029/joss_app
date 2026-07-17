import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/user_non_polis_page.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/user_polis_page.dart';

import '../../../../blocs/regklaim/polissourcecari_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../models/combobox/combomjenisrugimv_model.dart';
import '../../../../models/regklaim/sppapoliscari_model.dart';
import 'button_klaim/button_polis_source.dart';

class BasePolisPage extends StatelessWidget {
  final String cobKlaimId;
  final String cobKlaimNama;
  final String userType;

  final SppapoliscariModel? selectedPolis;
  final ValueChanged<SppapoliscariModel?> onPolisChanged;

  final ComboMJenisrugimvModel? selectedJenisKerugian;
  final ValueChanged<ComboMJenisrugimvModel?> onJenisKerugianChanged;

  final String keterangan;
  final ValueChanged<String> onKeteranganChanged;

  const BasePolisPage({
    super.key,
    required this.cobKlaimId,
    required this.cobKlaimNama,
    required this.userType,
    required this.selectedPolis,
    required this.onPolisChanged,
    required this.selectedJenisKerugian,
    required this.onJenisKerugianChanged,
    required this.keterangan,
    required this.onKeteranganChanged,
  });

  void _resetUserPolisData() {
    onPolisChanged(null);
    onJenisKerugianChanged(null);
    onKeteranganChanged('');
  }

  String _resolveSourceId(PolissourcecariState state) {
    final sourceIds = state.items
        .map((e) => e.polissourceId)
        .where((id) => id == "10" || id == "20")
        .toSet();

    if (sourceIds.length == 1) {
      return sourceIds.first;
    }

    if (sourceIds.contains(state.selectedPolissourceId)) {
      return state.selectedPolissourceId;
    }

    if (sourceIds.contains("10")) {
      return "10";
    }

    if (sourceIds.contains("20")) {
      return "20";
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    if (userType.trim().isEmpty) {
      return UserNonPolisPage(
        key: ValueKey('user_non_polis_${cobKlaimId}_guest'),
        cobKlaimId: cobKlaimId,
        cobKlaimNama: cobKlaimNama,
      );
    }

    return BlocListener<PolissourcecariBloc, PolissourcecariState>(
      listenWhen: (previous, current) {
        return previous.selectedPolissourceId != current.selectedPolissourceId;
      },
      listener: (context, state) {
        _resetUserPolisData();
      },
      child: BlocBuilder<PolissourcecariBloc, PolissourcecariState>(
        builder: (context, state) {
          final currentSourceId = _resolveSourceId(state);

          Widget content;

          if (state.status == ListStatus.initial ||
              state.status == ListStatus.failure) {
            content = const SizedBox.shrink();
          } else {
            switch (currentSourceId) {
              case "10":
                content = UserPolisPage(
                  key: ValueKey('user_polis_${cobKlaimId}_$currentSourceId'),
                  cobKlaimId: cobKlaimId,
                  cobKlaimNama: cobKlaimNama,
                  selectedPolis: selectedPolis,
                  onPolisChanged: onPolisChanged,
                  selectedJenisKerugian: selectedJenisKerugian,
                  onJenisKerugianChanged: onJenisKerugianChanged,
                  keterangan: keterangan,
                  onKeteranganChanged: onKeteranganChanged,
                );
                break;

              case "20":
                content = UserNonPolisPage(
                  key: ValueKey(
                    'user_non_polis_${cobKlaimId}_$currentSourceId',
                  ),
                  cobKlaimId: cobKlaimId,
                  cobKlaimNama: cobKlaimNama,
                );
                break;

              default:
                content = const SizedBox.shrink();
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ButtonPolisSourceWidget(),
              content,
            ],
          );
        },
      ),
    );
  }
}
