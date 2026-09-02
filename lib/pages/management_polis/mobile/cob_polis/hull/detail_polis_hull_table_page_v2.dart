import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/gen_detail_sts_sppa/mdetailstssppacari_bloc.dart';
import '../../../../../blocs/gen_aset_hull/sppa2hullcari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../widgets/listpage_filter_bar_ui.dart';
import '../../../../base/base_background_sidepage.dart';
import '../../../../gen_button_cob_app/button_group_detail_sts_sppa.dart';
import 'detail_polis_hull_table_widget.dart';

class DetailPolisHullTablePageV2 extends StatefulWidget {
  final String sppa1Id;

  const DetailPolisHullTablePageV2({
    super.key,
    required this.sppa1Id,
  });

  @override
  State<DetailPolisHullTablePageV2> createState() =>
      _DetailPolisHullTablePageV2State();
}

class _DetailPolisHullTablePageV2State
    extends State<DetailPolisHullTablePageV2> {
  late final Sppa2hullCariBloc sppa2hullCariBloc;

  final TextEditingController searchController = TextEditingController();
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();

    sppa2hullCariBloc = context.read<Sppa2hullCariBloc>();

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
    sppa2hullCariBloc.add(
      RefreshSppa2hullCariEvent(
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
    final selectedDetailStatusId =
        context.select<MDetailStsSppaCariBloc, String>(
      (bloc) => bloc.state.selectedDetailStsSppaId,
    );

    return BaseBackgroundSidePage(
      title: 'Detail Polis',
      child: Container(
        color: secondaryBlackColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            hPadding * 1.5,
            hPadding,
            hPadding * 1.5,
            hPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ButtonGroupDetailStsSppaWidget(),
              const SizedBox(height: hPadding),
              Text(
                'Detail Polis Hull V2',
                style: bodyTextStyle(
                  context,
                  fontSize: getResponsiveFont(context, 16),
                ),
              ),
              const SizedBox(height: hPadding),
              ListPageFilterBarUIWidget(
                searchController: searchController,
                searchButton: buildSearchButton(),
                hintText: 'Nama Kapal/Kerangka',
              ),
              const SizedBox(height: hPadding),
              Expanded(
                child: selectedDetailStatusId == '10001'
                    ? BlocBuilder<Sppa2hullCariBloc, Sppa2hullCariState>(
                        buildWhen: (p, c) =>
                            p.status != c.status ||
                            p.items != c.items ||
                            p.hasReachedMax != c.hasReachedMax ||
                            p.isFetching != c.isFetching,
                        builder: (context, state) {
                          if (state.status == ListStatus.initial) {
                            return const Center(child: LoadingIndicator());
                          }

                          if (state.status == ListStatus.failure) {
                            return _buildEmptyState('Gagal memuat data.');
                          }

                          if (state.items.isEmpty) {
                            return _buildEmptyState(
                              'Data polis tidak ditemukan.',
                            );
                          }

                          return Align(
                            alignment: Alignment.topCenter,
                            child: DetailPolisHullTableWidget(
                              items: state.items,
                              isLoadingMore: state.isFetching,
                              onLoadMore: () {
                                if (!state.hasReachedMax && !state.isFetching) {
                                  context
                                      .read<Sppa2hullCariBloc>()
                                      .add(FetchSppa2hullCariEvent());
                                }
                              },
                            ),
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
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
