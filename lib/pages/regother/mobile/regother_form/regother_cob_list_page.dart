import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/models/combobox/combomcobapp1_model.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/repositories/combobox/combomcobapp1_repository.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';

import '../../../../blocs/regother/regother1crud_bloc.dart';
import '../../../../helper/navigation_keys.dart';
import '../../../../widgets/apptheme/empty_state_page.dart';

class CobCariPage extends StatefulWidget {
  const CobCariPage({super.key});

  @override
  State<CobCariPage> createState() => _CobCariPageState();
}

class _CobCariPageState extends State<CobCariPage> {
  final ComboMCobApp1Repository _repository = ComboMCobApp1Repository();

  final TextEditingController _searchController = TextEditingController();

  late Future<List<ComboMCobApp1Model>> _futureData;

  ComboMCobApp1Model? _selectedCobModel;

  @override
  void initState() {
    super.initState();
    _futureData = _loadCobItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<ComboMCobApp1Model>> _loadCobItems() {
    return _repository.getComboMCobApp1(
      _searchController.text.trim(),
    );
  }

  void _refreshData() {
    setState(() {
      _futureData = _loadCobItems();
    });
  }

  IconButton _buildSearchButton() {
    return IconButton(
      icon: const Icon(
        Icons.autorenew_rounded,
        size: 35.0,
      ),
      onPressed: _refreshData,
    );
  }

  List<ComboMCobApp1Model> _filterExcludedCob(
      List<ComboMCobApp1Model> items,
      ) {
    return items
        .where((e) => e.mCobApp1Id != "10002" && e.mCobApp1Id != "10003")
        .toList();
  }

  void _syncSelectedModel({
    required List<ComboMCobApp1Model> items,
    required String selectedId,
  }) {
    if (_selectedCobModel != null || selectedId.isEmpty) return;

    final found = items.where((e) => e.mCobApp1Id == selectedId).toList();

    if (found.isNotEmpty) {
      _selectedCobModel = found.first;
    }
  }

  void _selectCob(ComboMCobApp1Model item) {
    setState(() {
      _selectedCobModel = item;
    });

    context.read<Regother1CrudBloc>().add(
      SelectButton(
        item.mCobApp1Id,
        item.cobNama,
      ),
    );
  }

  void _submitSelectedCob() {
    if (_selectedCobModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar("Silakan pilih kategori asuransi terlebih dahulu"),
      );
      return;
    }

    Navigator.pop(context, _selectedCobModel);
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = context.select<Regother1CrudBloc, String>(
          (bloc) => bloc.state.selectedCOBId,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        context.read<Regother1CrudBloc>().add(
          const ResetSelectedCobEvent(),
        );

        Navigator.pop(context);
      },
      child: BaseBackgroundSidePage(
        title: "Kategori Asuransi",
        onBack: () {
          context.read<Regother1CrudBloc>().add(
            const ResetSelectedCobEvent(),
          );

          Navigator.pop(context);
        },
        onHome: () {
          context.read<Regother1CrudBloc>().add(
            const ResetSelectedCobEvent(),
          );

          final homeState = homeTabKey.currentState;

          if (homeState != null) {
            homeState.goToHeroPage();
          }

          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: secondaryBlackColor,
          padding: const EdgeInsets.symmetric(
            horizontal: hPadding * 1.5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListPageFilterBarUIWidget(
                searchController: _searchController,
                searchButton: _buildSearchButton(),
                hintText: "Cari kategori asuransi...",
              ),

              const SizedBox(height: 12),

              Expanded(
                child: FutureBuilder<List<ComboMCobApp1Model>>(
                  future: _futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoading();
                    }

                    if (snapshot.hasError) {
                      return _buildError(snapshot.error);
                    }

                    final items = _filterExcludedCob(snapshot.data ?? []);

                    if (items.isEmpty) {
                      return _buildEmpty();
                    }

                    _syncSelectedModel(
                      items: items,
                      selectedId: selectedId,
                    );

                    return _buildCobList(
                      items: items,
                      selectedId: selectedId,
                    );
                  },
                ),
              ),

              const SizedBox(height: vPadding),

              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50),
        child: LoadingIndicator(),
      ),
    );
  }

  Widget _buildError(Object? error) {
    return Center(
      child: Text(
        "Gagal memuat kategori: $error",
        style: bodyTextStyle(context),
      ),
    );
  }

  Widget _buildEmpty() {
    return const EmptyStatePage(
      title: "Kategori Asuransi tidak tersedia",
      description: "Coba gunakan kata kunci lain atau muat ulang data kategori.",
    );
  }

  Widget _buildCobList({
    required List<ComboMCobApp1Model> items,
    required String selectedId,
  }) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (_, index) {
        return _buildCobItem(
          item: items[index],
          selectedId: selectedId,
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return AppButton.primary(
      text: "Lanjut",
      onPressed: _submitSelectedCob,
    );
  }

  void _resetSelectedCob() {
    setState(() {
      _selectedCobModel = null;
    });

    context.read<Regother1CrudBloc>().add(
      SelectButton('', ''),
    );
  }

  Widget _buildCobItem({
    required ComboMCobApp1Model item,
    required String selectedId,
  }) {
    final isSelected = selectedId == item.mCobApp1Id;

    return InkWell(
      onTap: () => _selectCob(item),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            RadioButton(
              isSelected: isSelected,
              onTap: () => _selectCob(item),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                item.cobNama,
                style: bodyTextStyle(
                  context,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}