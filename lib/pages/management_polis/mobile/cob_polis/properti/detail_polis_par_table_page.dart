import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/gen_aset_par/sppa2parcari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../widgets/listpage_filter_bar_ui.dart';
import 'detail_polis_par_table_widget.dart';

class DetailPolisParTablePage extends StatefulWidget {
  final String sppa1Id;

  const DetailPolisParTablePage({
    super.key,
    required this.sppa1Id,
  });

  @override
  State<DetailPolisParTablePage> createState() =>
      _DetailPolisParTablePageState();
}

class _DetailPolisParTablePageState
    extends State<DetailPolisParTablePage> {
  late final Sppa2parCariBloc sppa2parCariBloc;

  final TextEditingController searchController = TextEditingController();
  Timer? _searchTimer;
  double _tableHeight(int itemCount) {
    const double headerHeight = 48;
    const double rowHeight = 48;
    const int maxVisibleRows = 7;

    final visibleRows = itemCount > maxVisibleRows ? maxVisibleRows : itemCount;

    return headerHeight + (visibleRows * rowHeight);
  }
  @override
  void initState() {
    super.initState();

    sppa2parCariBloc = context.read<Sppa2parCariBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshData();
    });
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void refreshData() {
    sppa2parCariBloc.add(
      RefreshSppa2parCariEvent(
        sppa1Id: widget.sppa1Id,
        searchText: searchController.text,
      ),
    );
  }

  void _onSearchChanged(String value) {
    _searchTimer?.cancel();

    _searchTimer = Timer(const Duration(milliseconds: 400), () {
      refreshData();
    });
  }

  void _clearSearch() {
    searchController.clear();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: pGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: sGrey),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 720,
          maxHeight: 680,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(hPadding),
              child: ListPageFilterBarUIWidget(
                searchController: searchController,
                searchButton: buildSearchButton(),
                hintText: "Cari lokasi / okupasi...",
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(hPadding),
              child: BlocBuilder<Sppa2parCariBloc, Sppa2parCariState>(
                buildWhen: (p, c) =>
                p.status != c.status ||
                    p.items != c.items ||
                    p.hasReachedMax != c.hasReachedMax,
                builder: (context, state) {
                  if (state.status == ListStatus.initial) {
                    return const SizedBox(
                      height: 160,
                      child: Center(child: LoadingIndicator()),
                    );
                  }

                  if (state.status == ListStatus.failure) {
                    return SizedBox(
                      height: 160,
                      child: _buildEmptyState("Gagal memuat data."),
                    );
                  }

                  if (state.items.isEmpty) {
                    return SizedBox(
                      height: 160,
                      child: _buildEmptyState("Data polis tidak ditemukan."),
                    );
                  }

                  return SizedBox(
                    height: _tableHeight(state.items.length),
                    child: DetailPolisParTableWidget(
                      items: state.items,
                      isLoadingMore: !state.hasReachedMax &&
                          state.status == ListStatus.success,
                      onLoadMore: () {
                        context
                            .read<Sppa2parCariBloc>()
                            .add(FetchSppa2parCariEvent());
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "Detail Polis PAR",
              style: bodyTextStyle(
                context,
                fontSize: getResponsiveFont(context, 16),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: primaryLightColor,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconButton buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 35.0),
      onPressed: refreshData,
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: primaryLightColor,
          fontSize: 14,
        ),
      ),
    );
  }
}