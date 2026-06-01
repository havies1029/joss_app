import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/management_polis/mobile/cob_polis/template_polis_table/cob_policy_table.dart';
import '../../../../blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../models/gen_aset_ringkasan/asetringkasancari_model.dart';


class RingkasanCobTable extends StatefulWidget {
  final List<AsetRingkasanCariModel> items;
  final bool showFooter;
  final String? title;

  const RingkasanCobTable({
    super.key,
    required this.items,
    this.showFooter = true,
    this.title,
  });

  @override
  State<RingkasanCobTable> createState() => _RingkasanCobTableState();
}

class _RingkasanCobTableState extends State<RingkasanCobTable> {
  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);

  // @override
  // Widget build(BuildContext context) {
  //   final width = MediaQuery.of(context).size.width;
  //   final bool isNarrow = width < 900;
  //
  //   final items = widget.items;
  //
  //   if (items.isEmpty) {
  //     return const Center(child: Text("Data kosong"));
  //   }
  //
  //   return SingleChildScrollView(
  //     controller: vController,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         if (widget.title != null) ...[
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
  //             child: Text(
  //               widget.title!,
  //               style: headingStyle(context, fontSize: 14),
  //             ),
  //           ),
  //           const SizedBox(height: hPadding),
  //         ],
  //         Padding(
  //           padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
  //           child: isNarrow
  //               ? _buildDetailTableCompact(context, items)
  //               : _buildDetailTableNormal(context, items),
  //         ),
  //         const SizedBox(height: hPadding),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return CobPolicyTable<AsetRingkasanCariModel>(
      title: widget.title,
      items: widget.items,
      selectedIds: const [],
      enablePagination: false,
      enableSelection: false,
      enableDetailTap: false,
      filterSelectedWhenReadOnly: false,
      readOnly: true,
      idGetter: (d) => d.asetNama,
      onSelect: (_) {},
      onUnselect: (_) {},
      onOpenDetail: (_, __) {},
      columns: [
        CobPolicyColumn<AsetRingkasanCariModel>(
          title: "JENIS POLIS",
          valueGetter: (d) => d.asetNama,
          normalFlex: 2.3,
          compactWidth: 160,
        ),
        CobPolicyColumn<AsetRingkasanCariModel>(
          title: "JUMLAH POLIS",
          valueGetter: (d) => d.jmlPolis.toString(),
          normalFlex: 1.4,
          compactWidth: 120,
        ),
        CobPolicyColumn<AsetRingkasanCariModel>(
          title: "NILAI PERTANGGUNGAN",
          valueGetter: (d) =>
          "${d.curr} ${formatNum(d.nilaiAset)}",
          normalFlex: 2.5,
          compactWidth: 200,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),
        CobPolicyColumn<AsetRingkasanCariModel>(
          title: "TOTAL PREMI",
          valueGetter: (d) =>
          "${d.curr} ${formatNum(d.nilaiPremi)}",
          normalFlex: 2.0,
          compactWidth: 200,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),
      ],
    );
  }
}
