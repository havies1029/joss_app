import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/gen_detail_sts_sppa/mdetailstssppacari_bloc.dart';
import '../../../../../blocs/gen_aset_par/sppa2parcari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../widgets/listpage_filter_bar_ui.dart';
import '../../../../base/base_background_sidepage.dart';
import '../../../../gen_button_cob_app/button_group_detail_sts_sppa.dart';
import 'detail_polis_par_table_widget.dart';

class DetailPolisParTablePageV2 extends StatefulWidget {
  final String sppa1Id;

  const DetailPolisParTablePageV2({
    super.key,
    required this.sppa1Id,
  });

  @override
  State<DetailPolisParTablePageV2> createState() =>
      _DetailPolisParTablePageV2State();
}

class _DetailPolisParTablePageV2State extends State<DetailPolisParTablePageV2> {
  late final Sppa2parCariBloc sppa2parCariBloc;

  final TextEditingController searchController = TextEditingController();
  Timer? _searchTimer;

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
                'Detail Polis PAR V2',
                style: bodyTextStyle(
                  context,
                  fontSize: getResponsiveFont(context, 16),
                ),
              ),
              const SizedBox(height: hPadding),
              ListPageFilterBarUIWidget(
                searchController: searchController,
                searchButton: buildSearchButton(),
                hintText: 'Lokasi/Deskripsi',
              ),
              const SizedBox(height: hPadding),
              Expanded(
                child: selectedDetailStatusId == '10001'
                    ? BlocBuilder<Sppa2parCariBloc, Sppa2parCariState>(
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
                            child: DetailPolisParTableWidget(
                              items: state.items,
                              isLoadingMore: state.isFetching,
                              onLoadMore: () {
                                if (!state.hasReachedMax && !state.isFetching) {
                                  context
                                      .read<Sppa2parCariBloc>()
                                      .add(FetchSppa2parCariEvent());
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
