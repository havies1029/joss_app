import 'package:flutter/material.dart';

import '../../../../models/polis_endors_history/polis_endors_history_model.dart';
import '../cob_polis/template_polis_table/detail_polis_table.dart';

class TemplateEndorsTable extends StatelessWidget {
  final List<PolisEndorsHistoryModel> items;
  final List<DetailPolisColumn<PolisEndorsHistoryModel>> columns;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

  const TemplateEndorsTable({
    super.key,
    required this.items,
    required this.columns,
    this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return DetailPolisTable<PolisEndorsHistoryModel>(
      items: items,
      columns: columns,
      onLoadMore: onLoadMore,
      isLoadingMore: isLoadingMore,
      emptyText: 'Belum ada riwayat endorsement.',
      maxVisibleRows: 8,
    );
  }
}
