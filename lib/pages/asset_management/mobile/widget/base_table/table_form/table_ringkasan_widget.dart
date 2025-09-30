import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/pages/gen_aset_ringkasan/asetringkasancari_list_widget.dart';

import '../../../../../../common/constants.dart';
import '../../../../../../widgets/apptheme/build_status_box.dart';
import '../../../../../../widgets/apptheme/build_status_text_box.dart';
import '../list_form/aset_list_ringkasan.dart';

class TableRingkasanWidget extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String initialStatusId;
  final double? listHeight; // <— tambahin

  const TableRingkasanWidget({
    super.key,
    this.padding,
    this.initialStatusId = '10001',
    this.listHeight, // <—
  });

  @override
  State<TableRingkasanWidget> createState() => _TableRingkasanWidgetState();
}

class _TableRingkasanWidgetState extends State<TableRingkasanWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // lebih stabil daripada delay
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
        statusId: widget.initialStatusId, // gunakan initialStatusId
        searchText: _searchController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListPageFilterBarUIWidget(
            searchController: _searchController,
            searchButton: _buildSearchButton(),
          ),
          const SizedBox(height: hPadding),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            child: Row(
              children: const [
                StatusTextBox(
                  assetPath: "assets/icons/tambah_polis_icon_polis.svg",
                  text: "Tambah",
                    bgColor: Colors.orange,
                ),
                SizedBox(width: hPadding),
                StatusTextBox(
                  assetPath: "assets/icons/unduh_data_polis.svg",
                  text: "Unduh",
                  bgColor: Colors.grey,
                ),
                SizedBox(width: hPadding),
                StatusTextBox(
                  assetPath: "assets/icons/share_data_polis.svg",
                  text: "Share",
                  bgColor: Colors.blue,
                ),
              ],
            ),
          ),

          const SizedBox(height: hPadding),


          // 📋 biarkan AsetListRingkasan handle scroll
          Expanded(
            child: AsetListRingkasan(
              searchText: _searchController.text,
            ),
          ),
        ],
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