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
      _showAllCobItems = false;
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

  static const int _initialVisibleCount = 8;

  bool _showAllCobItems = false;

  static const _priorityCobIds = [
    '21',
    '17',
    '47',
    '52',
    '03',
    '46',
    '14',
    '02',
  ];

  // List<ComboMCobApp1Model> _filterExcludedCob(
  //     List<ComboMCobApp1Model> items,
  //     ) {
  //   final filtered = items
  //       .where((e) =>
  //       e.mCobApp1Id != "14" &&
  //       e.mCobApp1Id != "02")
  //       .toList();
  //
  //   filtered.sort((a, b) {
  //     final aIndex = _priorityCobIds.indexOf(a.mCobApp1Id);
  //     final bIndex = _priorityCobIds.indexOf(b.mCobApp1Id);
  //
  //     final aPriority = aIndex == -1 ? 999 : aIndex;
  //     final bPriority = bIndex == -1 ? 999 : bIndex;
  //
  //     if (aPriority != bPriority) {
  //       return aPriority.compareTo(bPriority);
  //     }
  //
  //     return a.cobNama.compareTo(b.cobNama);
  //   });
  //
  //   return filtered;
  // }

  List<ComboMCobApp1Model> _filterExcludedCob(
      List<ComboMCobApp1Model> items,
      ) {
    final filtered = [...items];

    filtered.sort((a, b) {
      final aIndex = _priorityCobIds.indexOf(a.mCobApp1Id);
      final bIndex = _priorityCobIds.indexOf(b.mCobApp1Id);

      final aPriority = aIndex == -1 ? 999 : aIndex;
      final bPriority = bIndex == -1 ? 999 : bIndex;

      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }

      return a.cobNama.compareTo(b.cobNama);
    });

    return filtered;
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
    final visibleItems = _showAllCobItems
        ? items
        : items.take(_initialVisibleCount).toList();

    final hiddenCount = items.length - visibleItems.length;
    final showToggle = items.length > _initialVisibleCount;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: visibleItems.length + (showToggle ? 1 : 0),
      itemBuilder: (_, index) {
        if (index < visibleItems.length) {
          return _buildCobItem(
            item: visibleItems[index],
            selectedId: selectedId,
          );
        }

        return _buildShowMoreButton(hiddenCount);
      },
    );
  }

  Widget _buildShowMoreButton(int hiddenCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: hPadding,
        horizontal: vPadding,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _showAllCobItems = !_showAllCobItems;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              _showAllCobItems
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 20,
              color: primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              _showAllCobItems
                  ? "Tampilkan Lebih Sedikit"
                  : "Lihat $hiddenCount Kategori Lainnya",
              style: bodyTextStyle(context).copyWith(
                color: primaryColor,
                fontSize: getResponsiveFont(context, 16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
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