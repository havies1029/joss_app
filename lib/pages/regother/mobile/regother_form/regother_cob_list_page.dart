import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';
import 'package:joss_app/models/combobox/combomcobapp1_model.dart';
import 'package:joss_app/repositories/combobox/combomcobapp1_repository.dart';

class CobCariPage extends StatefulWidget {
  const CobCariPage({super.key});

  @override
  State<CobCariPage> createState() => _CobCariPageState();
}

class _CobCariPageState extends State<CobCariPage> {
  String? selectedCobId;
  ComboMCobApp1Model? selectedCobModel;

  late Future<List<ComboMCobApp1Model>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = ComboMCobApp1Repository().getComboMCobApp1();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Kategori Asuransi",
      child: Container(
        color: secondaryBlackColor,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: FutureBuilder<List<ComboMCobApp1Model>>(
          future: futureData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final items = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (_, i) => _buildCobItem(items[i]),
                  ),
                ),
                const SizedBox(height: 15),
                AppButton.primary(
                  text: "Selesai",
                  onPressed: selectedCobModel == null
                      ? null
                      : () => Navigator.pop(context, selectedCobModel),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCobItem(ComboMCobApp1Model item) {
    final isSelected = selectedCobId == item.mCobApp1Id;

    return InkWell(
      onTap: () {
        setState(() {
          selectedCobId = item.mCobApp1Id;
          selectedCobModel = item;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            RadioButton(
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  selectedCobId = item.mCobApp1Id;
                  selectedCobModel = item;
                });
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.cobNama,
                style: bodyTextStyle(context, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
