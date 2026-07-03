import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/asetothers/sppa2otherscari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../widgets/listpage_filter_bar_ui.dart';
import 'detail_polis_others_table_widget.dart';

class DetailPolisOthersTablePage extends StatefulWidget {
  final String sppa1Id;

  const DetailPolisOthersTablePage({
    super.key,
    required this.sppa1Id,
  });

  @override
  State<DetailPolisOthersTablePage> createState() =>
      _DetailPolisOthersTablePageState();
}

class _DetailPolisOthersTablePageState
    extends State<DetailPolisOthersTablePage> {
  late final Sppa2othersCariBloc sppa2othersCariBloc;

  final TextEditingController searchController = TextEditingController();
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();

    sppa2othersCariBloc = context.read<Sppa2othersCariBloc>();

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
    sppa2othersCariBloc.add(
      RefreshSppa2othersCariEvent(
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
          maxWidth: 760,
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
                hintText: "Info/Deskripsi",
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(hPadding),
              child: BlocBuilder<Sppa2othersCariBloc, Sppa2othersCariState>(
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

                  return DetailPolisOthersTableWidget(
                    items: state.items,
                    isLoadingMore: state.isFetching,
                    onLoadMore: () {
                      if (!state.hasReachedMax && !state.isFetching) {
                        context
                            .read<Sppa2othersCariBloc>()
                            .add(FetchSppa2othersCariEvent());
                      }
                    },
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
              "Detail Polis Others",
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
