import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/pages/gen_aset_ringkasan/asetringkasancari_list_widget.dart';

import '../../../../../../blocs/share_cubit/share_cubit_state.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../widgets/apptheme/build_status_box.dart';
import '../../../../../../widgets/apptheme/build_status_text_box.dart';
import '../list_form/aset_list_ringkasan.dart';

class TableRingkasanWidget extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String initialStatusId;
  final double? listHeight;

  const TableRingkasanWidget({
    super.key,
    this.padding,
    this.initialStatusId = '10001',
    this.listHeight,
  });

  @override
  State<TableRingkasanWidget> createState() => _TableRingkasanWidgetState();
}

class _TableRingkasanWidgetState extends State<TableRingkasanWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshData() {
    context.read<AsetRingkasanCariBloc>().add(
      RefreshAsetRingkasanCariEvent(
        statusId: widget.initialStatusId,
        searchText: _searchController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShareStateCubit(),
      child: MultiBlocListener(
        listeners: [
          /// Listener untuk debug ShareStateCubit
          BlocListener<ShareStateCubit, Map<String, bool>>(
            listener: (context, state) {
              final activeIds = state.entries
                  .where((e) => e.value)
                  .map((e) => e.key)
                  .toList();
              debugPrint("✅ Active IDs: $activeIds");
            },
          ),
        ],
        child: BlocBuilder<ShareStateCubit, Map<String, bool>>(
          builder: (context, map) {
            final cubit = context.read<ShareStateCubit>();

            return Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListPageFilterBarUIWidget(
                    searchController: _searchController,
                    searchButton: _buildSearchButton(),
                  ),
                  const SizedBox(height: vPadding),

                  /// Toolbar (global actions)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const StatusTextBox(
                          assetPath: "assets/icons/tambah_polis_icon_polis.svg",
                          text: "Tambah",
                          bgColor: Colors.orange,
                        ),
                        const StatusTextBox(
                          assetPath: "assets/icons/unduh_data_polis.svg",
                          text: "Unduh",
                          bgColor: Colors.grey,
                        ),
                        const StatusTextBox(
                          assetPath: "assets/icons/share_data_polis.svg",
                          text: "Share",
                          bgColor: Colors.blue,
                        ),

                        /// 🔑 Global Share (REAL IDs)
                        BlocBuilder<AsetRingkasanCariBloc,
                            AsetRingkasanCariState>(
                          builder: (context, asetState) {
                            return StatusTextBox(
                              assetPath: "assets/icons/share_data_polis.svg",
                              borderColor: primaryLightColor,
                              activeIconColor: secondaryBlackColor,
                              enableBorderClickFill: true,
                              bgColor: cubit.globalActive
                                  ? primaryLightColor
                                  : Colors.transparent,
                              iconColor: cubit.globalActive
                                  ? secondaryBlackColor
                                  : primaryLightColor,
                              onTap: () {
                                final ids = asetState.items
                                    .map((e) => e.asetRingkasanId)
                                    .toList();

                                cubit.toggleGlobal(ids);

                                debugPrint(
                                    "👉 Global Share toggled. Sekarang: ${cubit.globalActive}");
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: vPadding),

                  /// 📋 biarkan AsetListRingkasan handle scroll
                  Expanded(
                    child: AsetListRingkasan(
                      searchText: _searchController.text,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  IconButton _buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 28),
      onPressed: _refreshData,
      tooltip: 'Refresh',
    );
  }
}
