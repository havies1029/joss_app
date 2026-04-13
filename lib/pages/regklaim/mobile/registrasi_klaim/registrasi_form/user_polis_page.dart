import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/regklaim/sppapoliscari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../models/regklaim/sppapoliscari_model.dart';

class UserPolisPage extends StatefulWidget {
  final String cobKlaimId;
  final String cobKlaimNama;
  final SppapoliscariModel? selectedPolis;
  final ValueChanged<SppapoliscariModel?> onPolisChanged;

  const UserPolisPage({
    super.key,
    required this.cobKlaimId,
    required this.cobKlaimNama,
    required this.selectedPolis,
    required this.onPolisChanged,
  });

  @override
  State<UserPolisPage> createState() => _UserPolisPageState();
}

class _UserPolisPageState extends State<UserPolisPage> {
  bool _didLoadSppa = false;

  @override
  void didUpdateWidget(covariant UserPolisPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cobKlaimId != widget.cobKlaimId) {
      _didLoadSppa = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.onPolisChanged(null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: vPadding),
      child: Container(
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Cari Data Polis",
              style: TextStyle(
                color: primaryLightColor,
                fontSize: getResponsiveFont(context, 18),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: hPadding),
            buildComboSppaPolis(
              cobKlaimId: widget.cobKlaimId,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildComboSppaPolis({required String cobKlaimId}) {
    return BlocBuilder<SppapoliscariBloc, SppapoliscariState>(
      builder: (context, state) {
        if (!_didLoadSppa && cobKlaimId.isNotEmpty) {
          _didLoadSppa = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.read<SppapoliscariBloc>().add(
              RefreshSppapoliscariEvent(
                cobKlaimId: cobKlaimId,
                searchText: "",
              ),
            );
          });
        }
        return ReusableComboBox<SppapoliscariModel>(
          key: ValueKey(
            'sppa_${cobKlaimId}_${state.status}_${state.items.length}',
          ),
          hintText: "No. Polis",
          initItem: widget.selectedPolis,
          dataLoader: () async {
            return state.items;
          },
          displayText: (i) => i.sppaNoRef,
          compareItems: (a, b) => a.sppaId == b.sppaId,
          onChangedCallback: (v) {
            widget.onPolisChanged(v);
          },
          onSaveCallback: (value) {
            widget.onPolisChanged(value);
          },
        );
      },
    );
  }
}