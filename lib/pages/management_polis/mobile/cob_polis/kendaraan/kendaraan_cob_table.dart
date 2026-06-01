import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/gen_aset_mv/asetmvcari_bloc.dart';
import '../../../../../models/gen_aset_mv/asetmvcari_model.dart';
import '../../../../../widgets/apptheme/register_client_pop_up.dart';
import '../template_polis_table/cob_policy_table.dart';
import 'detail_polis_mv_table_page.dart';

class KendaraanCobTable extends StatefulWidget {
  final List<AsetMvCariModel> items;
  final List<String> selectedIds;
  final void Function(AsetMvCariModel item)? onSelectItem;
  final void Function(String id) selectedProsesId;
  final AsetMvCariModel? selectedItem;
  final VoidCallback? onClearSelectedItem;

  final Function(String id) onSelect;
  final Function(String id) onUnselect;

  final Function(String id) onSelectFilePolisMvId;
  final Function(String id) onUnselectFilePolisMvId;

  final bool readOnly;
  final bool showFooter;
  final String? title;

  const KendaraanCobTable({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelectItem,
    required this.selectedProsesId,
    required this.onSelect,
    required this.onUnselect,
    required this.onSelectFilePolisMvId,
    required this.onUnselectFilePolisMvId,
    required this.selectedItem,
    required this.onClearSelectedItem,
    this.readOnly = false,
    this.showFooter = true,
    this.title,
  });

  @override
  State<KendaraanCobTable> createState() => _KendaraanCobTableState();
}
class _KendaraanCobTableState extends State<KendaraanCobTable> {
  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);

  // @override
  // Widget build(BuildContext context) {
  //   final width = MediaQuery.of(context).size.width;
  //   final bool isNarrow = width < 900;
  //
  //   final items = _filteredItems;
  //   if (items.isEmpty) return const Center(child: Text("Data kosong"));
  //
  //   return SingleChildScrollView(
  //     controller: vController,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         if (widget.title != null) ...[
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
  //             child: Text(widget.title!, style: headingStyle(context, fontSize: 14)),
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
    return CobPolicyTable<AsetMvCariModel>(
      items: widget.items,
      selectedIds: widget.selectedIds,
      idGetter: (d) => d.asetMvId,
      nomorGetter: (d, index) => d.nomor.toString(),

      title: widget.title,
      readOnly: widget.readOnly,
      showFooter: widget.showFooter,

      hasReachedMax: context.watch<AsetMvCariBloc>().state.hasReachedMax,
      isFetching: context.watch<AsetMvCariBloc>().state.isFetching,
      onLoadMore: () {
        context.read<AsetMvCariBloc>().add(FetchAsetMvCariEvent());
      },

      onSelect: widget.onSelect,
      onUnselect: widget.onUnselect,
      onSelectItem: widget.onSelectItem,
      onClearSelectedItem: widget.onClearSelectedItem,

      onSelectExtra: (d) {
        if (d.filePolisId.isNotEmpty) {
          widget.onSelectFilePolisMvId(d.filePolisId);
        }
      },

      onUnselectExtra: (d) {
        if (d.filePolisId.isNotEmpty) {
          widget.onUnselectFilePolisMvId(d.filePolisId);
        }
      },

      onOpenDetail: (context, d) {
        _showSuccessPopup(context, d);
      },

      columns: [
        CobPolicyColumn<AsetMvCariModel>(
          title: "NO POLIS",
          valueGetter: (d) => d.polisNo,
          normalFlex: 2.0,
          compactWidth: 160,
          normalMaxLines: 1,
          compactMaxLines: 2,
          normalSoftWrap: true,
          compactSoftWrap: true,
        ),

        CobPolicyColumn<AsetMvCariModel>(
          title: "JUMLAH OBJEK",
          valueGetter: (d) => "${d.jmlObject} ${d.satuan}",
          normalFlex: 1.2,
          compactWidth: 120,
          normalMaxLines: 1,
          compactMaxLines: 2,
          normalSoftWrap: true,
          compactSoftWrap: true,
        ),

        CobPolicyColumn<AsetMvCariModel>(
          title: "PERIODE",
          valueGetter: (d) =>
          "${cobPolicyFormatDate(d.periodeMulai)} - ${cobPolicyFormatDate(d.periodeAkhir)}",
          normalFlex: 2.0,
          compactWidth: 170,
          normalMaxLines: 1,
          compactMaxLines: 2,
          normalSoftWrap: true,
          compactSoftWrap: true,
        ),

        CobPolicyColumn<AsetMvCariModel>(
          title: "TERTANGGUNG",
          valueGetter: (d) => d.tertanggung,
          normalFlex: 2.4,
          compactWidth: 170,
          normalMaxLines: 1,
          compactMaxLines: 2,
          normalSoftWrap: true,
          compactSoftWrap: true,
        ),

        CobPolicyColumn<AsetMvCariModel>(
          title: "NILAI PERTANGGUNGAN",
          valueGetter: (d) =>
          "${d.curr} ${cobPolicyFormatNum(d.sumInsured)}",
          normalFlex: 2.4,
          compactWidth: 170,
          normalMaxLines: 1,
          compactMaxLines: 1,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),

        CobPolicyColumn<AsetMvCariModel>(
          title: "PREMI",
          valueGetter: (d) => "${d.curr} ${cobPolicyFormatNum(d.premi)}",
          normalFlex: 1.6,
          compactWidth: 140,
          normalMaxLines: 1,
          compactMaxLines: 1,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),
      ],
    );
  }

  void _showSuccessPopup(BuildContext context, AsetMvCariModel d) {
    final asetMvId = d.asetMvId.trim();

    if (asetMvId.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.6),
        builder: (dialogContext) => RegisterClientPopUp(
          showIcon: false,
          header: 'Detail Polis Belum Tersedia',
          description:
          'Detail polis belum dapat ditampilkan karena polis masih dalam proses.',
          buttonText: 'Mengerti',
          onPressed: () {
            // optional action
          },
        ),
      );

      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: DetailPolisMvTablePage(
            sppa1Id: asetMvId,
          ),
        );
      },
    );
  }
}
