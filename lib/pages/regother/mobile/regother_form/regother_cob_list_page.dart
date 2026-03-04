import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';
import 'package:joss_app/models/combobox/combomcobapp1_model.dart';
import 'package:joss_app/repositories/combobox/combomcobapp1_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/regother/regother1crud_bloc.dart';

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
    futureData = ComboMCobApp1Repository().getComboMCobApp1("");
  }

  @override
  Widget build(BuildContext context) {
    // ambil selected id dari bloc (satu sumber kebenaran)
    final selectedId = context.select<Regother1CrudBloc, String>(
          (b) => b.state.selectedCOBId,
    );

    return BaseBackgroundSidePage(
      title: "Kategori Asuransi",
      child: Container(
        color: secondaryBlackColor,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: FutureBuilder<List<ComboMCobApp1Model>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Gagal memuat kategori: ${snapshot.error}",
                  style: bodyTextStyle(context),
                ),
              );
            }

            final rawItems = snapshot.data ?? [];
            final items = rawItems
                .where((e) => e.mCobApp1Id != "10002" && e.mCobApp1Id != "10003")
                .toList();

            if (items.isEmpty) {
              return Center(
                child: Text(
                  "Kategori asuransi kosong.",
                  style: bodyTextStyle(context),
                ),
              );
            }

            // kalau sudah pernah pilih sebelumnya, pastikan model lokal ikut kebaca
            if (selectedCobModel == null && selectedId.isNotEmpty) {
              final found =
              items.where((e) => e.mCobApp1Id == selectedId).toList();
              if (found.isNotEmpty) selectedCobModel = found.first;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (_, i) => _buildCobItem(
                      context,
                      items[i],
                      selectedId,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                AppButton.primary(
                  text: "Lanjut",
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

  Widget _buildCobItem(
      BuildContext context,
      ComboMCobApp1Model item,
      String selectedId,
      ) {
    final isSelected = selectedId == item.mCobApp1Id;

    void pick() {
      selectedCobModel = item;

      context.read<Regother1CrudBloc>().add(SelectButton(item.mCobApp1Id));
    }

    return InkWell(
      onTap: pick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            RadioButton(
              isSelected: isSelected,
              onTap: pick,
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
