import 'package:flutter/material.dart';
import 'package:joss_app/repositories/regklaim/sppapoliscari_repository.dart';
import 'package:joss_app/widgets/apptheme/dropdown2.dart';
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
            buildFieldComboSppaPolis(),
          ],
        ),
      ),
    );
  }

  Widget buildFieldComboSppaPolis() => ReusableComboBoxV2<SppapoliscariModel>(
    hintText: "No. Polis",    
    params: {
      "cobKlaimId": widget.cobKlaimId,
    },
    loader: (query) {
      return SppapoliscariRepository().getSppapoliscari(query.params["cobKlaimId"] ?? "", query.searchText, 0);
    },
    displayText: (i) => i.sppaNoRef,
    compareItems: (a, b) => a.sppaId == b.sppaId,
    onChangedCallback: (v) {
      widget.onPolisChanged(v);
    }, 
    onSaveCallback: (SppapoliscariModel? p1) {  },
  );

}