import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/gen_aset_mv/sppa2mvcari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../widgets/listpage_filter_bar_ui.dart';
import 'detail_polis_mv_table_widget.dart';

class DetailPolisMvTablePage extends StatefulWidget {
  final String sppa1Id;

  const DetailPolisMvTablePage({
    super.key,
    required this.sppa1Id,
  });

  @override
  State<DetailPolisMvTablePage> createState() =>
      _DetailPolisMvTablePageState();
}

class _DetailPolisMvTablePageState extends State<DetailPolisMvTablePage> {
  late final Sppa2mvCariBloc sppa2mvCariBloc;

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

    sppa2mvCariBloc = context.read<Sppa2mvCariBloc>();

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
    sppa2mvCariBloc.add(
      RefreshSppa2mvCariEvent(
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
          maxWidth: 900,
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
                hintText: "Cari no polisi / rangka / mesin...",
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(hPadding),
              child: BlocBuilder<Sppa2mvCariBloc, Sppa2mvCariState>(
                buildWhen: (p, c) =>
                p.status != c.status ||
                    p.items != c.items ||
                    p.hasReachedMax != c.hasReachedMax ||
                    p.isFetching != c.isFetching,
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
                    child: DetailPolisMvTableWidget(
                      items: state.items,
                      isLoadingMore: state.isFetching,
                      onLoadMore: () {
                        if (!state.hasReachedMax && !state.isFetching) {
                          context.read<Sppa2mvCariBloc>().add(FetchSppa2mvCariEvent());
                        }
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
              "Detail Polis MV",
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