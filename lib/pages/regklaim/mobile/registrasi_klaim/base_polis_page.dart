import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/user_non_polis_page.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/user_polis_page.dart';

import '../../../../blocs/authentication/authentication_bloc.dart';
import '../../../../blocs/dashboard/sumdash_bloc.dart';
import '../../../../blocs/regklaim/polissourcecari_bloc.dart';
import '../../../../models/combobox/combomjenisrugimv_model.dart';
import '../../../../models/regklaim/sppapoliscari_model.dart';
import 'button_klaim/button_polis_source.dart';

class BasePolisPage extends StatelessWidget {
  final String cobKlaimId;
  final String cobKlaimNama;

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

  @override
  Widget build(BuildContext context) {
    final jmlPolis =
        context.read<SumdashBloc>().state.record?.jmlpolis ?? 0;

    if (jmlPolis == 0) {
      return UserNonPolisPage(
        key: ValueKey('user_non_polis_${cobKlaimId}_jml0'),
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
          final currentSourceId = state.selectedPolissourceId;

          Widget content;

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
                key: ValueKey('user_non_polis_${cobKlaimId}_$currentSourceId'),
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
      ),
    );
  }
}