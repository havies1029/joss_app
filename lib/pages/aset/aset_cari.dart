import 'package:joss_app/blocs/gen_aset_health/asethealthcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_mv/asetmvcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_par/asetparcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/blocs/gen_cob_app/cobcari_bloc.dart';
import 'package:joss_app/blocs/gen_status_aset/statusasetcari_bloc.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/gen_aset_health/asethealthcari_list.dart';
import 'package:joss_app/pages/gen_aset_health/asethealthcari_list_widget.dart';
import 'package:joss_app/pages/gen_aset_mv/asetmvcari_list.dart';
import 'package:joss_app/pages/gen_aset_mv/asetmvcari_list_widget.dart';
import 'package:joss_app/pages/gen_aset_par/asetparcari_list.dart';
import 'package:joss_app/pages/gen_aset_par/asetparcari_list_widget.dart';
import 'package:joss_app/pages/gen_aset_ringkasan/asetringkasancari_list.dart';
import 'package:joss_app/pages/gen_aset_ringkasan/asetringkasancari_list_widget.dart';
import 'package:joss_app/pages/gen_cob_app/button_group_cob_aset.dart';
import 'package:joss_app/pages/gen_status_aset/button_group_status_aset.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class AsetCariPage extends StatefulWidget {
  const AsetCariPage({super.key});

  @override
  State<AsetCariPage> createState() => _AsetCariPageState();
}

class _AsetCariPageState extends State<AsetCariPage> {
  final TextEditingController _searchController = TextEditingController();
  late CobCariBloc cobAsetBloc;
  late StatusAsetCariBloc statusAsetBloc;
  late AsetRingkasanCariBloc asetRingkasanCariBloc;
  late AsetParCariBloc asetParCariBloc;
  late AsetMvCariBloc asetMvCariBloc;
  late AsetHealthCariBloc asetHealthCariBloc;

  @override
  Widget build(BuildContext context) {
    cobAsetBloc = BlocProvider.of<CobCariBloc>(context);
    statusAsetBloc = BlocProvider.of<StatusAsetCariBloc>(context);
    asetRingkasanCariBloc = BlocProvider.of<AsetRingkasanCariBloc>(context);
    asetParCariBloc = BlocProvider.of<AsetParCariBloc>(context);
    asetMvCariBloc = BlocProvider.of<AsetMvCariBloc>(context);
    asetHealthCariBloc = BlocProvider.of<AsetHealthCariBloc>(context);

    return Scaffold( // ✅ Tambahkan ini
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BlocListener<StatusAsetCariBloc, StatusAsetCariState>(
          listener: (context, state) {
            refreshData();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const ButtonGroupCobAsetWidget(),
                ListPageFilterBarUIWidget(
                  searchController: _searchController,
                  searchButton: buildSearchButton(),
                ),
                const ButtonGroupStatusAsetWidget(),
                BlocConsumer<CobCariBloc, CobCariState>(
                  builder: (context, state) {
                    if (state.status == ListStatus.initial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status == ListStatus.failure) {
                      return const Center(child: Text('Failed to fetch data'));
                    }
                    if (state.items.isEmpty) {
                      return const Center(child: Text('No items found'));
                    }

                    if (state.selectedCOBId == "10001") {
                      return SizedBox(
                        height: 400,
                        child: AsetRingkasanCariListWidget(
                          searchText: _searchController.text,
                        ),
                      );
                    } else if (state.selectedCOBId == "10002") {
                      return SizedBox(
                        height: 400,
                        child: AsetParCariListWidget(
                          searchText: _searchController.text,
                        ),
                      );
                    } else if (state.selectedCOBId == "10003") {
                      return SizedBox(
                        height: 400,
                        child: AsetMvCariListWidget(
                          searchText: _searchController.text,
                        ),
                      );
                    } else if (state.selectedCOBId == "10005") {
                      return SizedBox(
                        height: 400,
                        child: AsetHealthCariListWidget(
                          searchText: _searchController.text,
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('Belum ada Table untuk COB ini'),
                      );
                    }
                  },
                  listener: (context, state) {
                    if (state.selectedCOBId.isNotEmpty) {
                      refreshData();
                    }
                  },
                ),
              ],
            ),
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

  void refreshData() {
    var stateCob = cobAsetBloc.state;
    var stateStatus = statusAsetBloc.state;

    if (stateCob.selectedCOBId == "10001") {
      asetRingkasanCariBloc.add(RefreshAsetRingkasanCariEvent(
        statusId: stateStatus.selectedStatusId,
        searchText: _searchController.text,
      ));
    } else if (stateCob.selectedCOBId == "10002") {
      asetParCariBloc.add(RefreshAsetParCariEvent(
        statusId: stateStatus.selectedStatusId,
        searchText: _searchController.text,
      ));
    } else if (stateCob.selectedCOBId == "10003") {
      asetMvCariBloc.add(RefreshAsetMvCariEvent(
        statusId: stateStatus.selectedStatusId,
        searchText: _searchController.text,
      ));
    } else if (stateCob.selectedCOBId == "10005") {
      asetHealthCariBloc.add(RefreshAsetHealthCariEvent(
        statusId: stateStatus.selectedStatusId,
        searchText: _searchController.text,
      ));
    }
  }
}
