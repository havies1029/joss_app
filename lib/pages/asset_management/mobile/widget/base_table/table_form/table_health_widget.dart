import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/gen_aset_health/asethealthcari_bloc.dart';
import 'package:joss_app/pages/gen_aset_health/asethealthcari_list_widget.dart';

class TableHealthWidget extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String initialStatusId;
  final double? listHeight;

  const TableHealthWidget({
    super.key,
    this.padding,
    this.initialStatusId = '10005',
    this.listHeight,
  });

  @override
  TableHealthWidgetState createState() => TableHealthWidgetState();
}

class TableHealthWidgetState extends State<TableHealthWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // lebih stabil daripada Future.delayed
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshData() {
    context.read<AsetHealthCariBloc>().add(
      RefreshAsetHealthCariEvent(
        searchText: _searchController.text,
        statusId: widget.initialStatusId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double h = widget.listHeight ?? 400; // default tinggi list

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListPageFilterBarUIWidget(
            searchController: _searchController,
            searchButton: IconButton(
              icon: const Icon(Icons.autorenew_rounded, size: 28),
              tooltip: 'Refresh',
              onPressed: _refreshData,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: h,
            child: Scrollbar(
              thumbVisibility: true,
              child: AsetHealthCariListWidget(
                searchText: _searchController.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
