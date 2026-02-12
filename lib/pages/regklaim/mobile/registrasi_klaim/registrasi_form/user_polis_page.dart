import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/regklaim/sppapoliscari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../models/regklaim/sppapoliscari_model.dart';
import 'polis_detail/user_polis_detail.dart';

class UserPolisPage extends StatefulWidget {
  final String cobKlaimId;
  final String cobKlaimNama;

  const UserPolisPage({
    super.key,
    required this.cobKlaimId,
    required this.cobKlaimNama,
  });

  @override
  State<UserPolisPage> createState() => _UserPolisPageState();
}

class _UserPolisPageState extends State<UserPolisPage> {
  SppapoliscariModel? fieldSppaPolis;
  bool _didLoadSppa = false;

  @override
  void didUpdateWidget(covariant UserPolisPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if COB changes, reload SPPA list + reset selection
    if (oldWidget.cobKlaimId != widget.cobKlaimId) {
      _didLoadSppa = false;
      fieldSppaPolis = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:  vPadding),
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
            // Title
            Text(
              "Cari Data Polis",
              style: TextStyle(
                color: primaryLightColor,
                fontSize: getResponsiveFont(context, 18),
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: hPadding),

            // Combo / Search Polis
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
          initItem: fieldSppaPolis,
          dataLoader: () async => state.items,
          displayText: (i) => i.sppaId,
          compareItems: (a, b) => a.sppaId == b.sppaId,
          onChangedCallback: (v) {
            if (v == null) return;

            setState(() {
              fieldSppaPolis = v;
            });
            final sppaId = v.sppaId;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserPolisDetail(
                  cobKlaimId: widget.cobKlaimId,
                  cobKlaimNama: widget.cobKlaimNama,
                  sppa1Id: sppaId,
                ),
              ),
            );
          },

          onSaveCallback: (value) => fieldSppaPolis = value,
        );
      },
    );
  }

}
