import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/pages/gen_aset_ringkasan/asetringkasancari_list_widget.dart';

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
    final h = widget.listHeight ?? 400; // default tinggi list
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListPageFilterBarUIWidget(
            searchController: _searchController,
            searchButton: _buildSearchButton(),
            // opsional: kalau widget ini support trailing, kirim clearButton di sini
          ),
          const SizedBox(height: 8),
          // batasi tinggi agar tidak unbounded
          SizedBox(
            height: h,
            child: Scrollbar(
              thumbVisibility: true,
              child: AsetRingkasanCariListWidget(
                searchText: _searchController.text,
              ),
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
