import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../models/gen_aset_hull/asethullcari_model.dart';
import '../../../../../widgets/apptheme/register_client_pop_up.dart';
import '../template_polis_table/cob_policy_table.dart';
import 'detail_polis_hull_table_page.dart';

class HullCobTable extends StatefulWidget {
  final List<AsethullCariModel> items;
  final List<String> selectedIds;

  final void Function(AsethullCariModel item)? onSelectItem;
  final void Function(String id) selectedProsesId;

  final AsethullCariModel? selectedItem;
  final VoidCallback? onClearSelectedItem;
  final Function(String id) onSelect;
  final Function(String id) onUnselect;

  final Function(String id) onSelectFilePolisHullId;
  final Function(String id) onUnselectFilePolisHullId;

  final bool readOnly;
  final bool showFooter;
  final String? title;

  final String statusId;

  const HullCobTable({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelectItem,
    required this.selectedProsesId,
    required this.onSelect,
    required this.onUnselect,
    required this.onSelectFilePolisHullId,
    required this.onUnselectFilePolisHullId,
    required this.selectedItem,
    required this.onClearSelectedItem,
    required this.statusId,
    this.readOnly = false,
    this.showFooter = true,
    this.title,
  });

  @override
  State<HullCobTable> createState() => _HullCobTableState();
}

class _HullCobTableState extends State<HullCobTable> {
  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat('dd MMM yyyy').format(date);
  }

  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);

  String _selectionId(AsethullCariModel d) {
    final prosesId = d.prosesId.trim();
    if (widget.statusId == "10002" && prosesId.isNotEmpty) return prosesId;
    return d.asetHullId;
  }

  @override
  Widget build(BuildContext context) {
    final showColumn = widget.statusId == "10002";

    return CobPolicyTable<AsethullCariModel>(
      items: widget.items,
      selectedIds: widget.selectedIds,
      idGetter: _selectionId,
      nomorGetter: (d, index) => (index + 1).toString(),
      title: widget.title,
      readOnly: widget.readOnly,
      showFooter: widget.showFooter,
      hasReachedMax: context.watch<AsethullCariBloc>().state.hasReachedMax,
      isFetching: context.watch<AsethullCariBloc>().state.isFetching,
      onLoadMore: () {
        context.read<AsethullCariBloc>().add(FetchAsethullCariEvent());
      },
      onSelect: widget.onSelect,
      onUnselect: widget.onUnselect,
      onSelectItem: widget.onSelectItem,
      onClearSelectedItem: widget.onClearSelectedItem,
      onSelectExtra: (d) {
        if (d.prosesId.isNotEmpty) {
          widget.selectedProsesId(d.prosesId);
        }

        if (d.filePolisId.isNotEmpty) {
          widget.onSelectFilePolisHullId(d.filePolisId);
        }
      },
      onUnselectExtra: (d) {
        if (d.filePolisId.isNotEmpty) {
          widget.onUnselectFilePolisHullId(d.filePolisId);
        }
      },
      onOpenDetail: (context, d) {
        _showSuccessPopup(context, d);
      },
      columns: [
        if (showColumn)
          CobPolicyColumn<AsethullCariModel>(
            title: "NOMOR PROSES",
            valueGetter: (d) => d.prosesId.isEmpty ? "-" : d.prosesId,
            normalFlex: 1.4,
            compactWidth: 140,
            normalSoftWrap: false,
            compactSoftWrap: false,
          ),

        CobPolicyColumn<AsethullCariModel>(
          title: "NO POLIS",
          valueGetter: (d) => cobPolicyTextOrDash(d.polisNo),
          normalFlex: showColumn ? 1.2 : 2.0,
          compactWidth: showColumn ? 120 : 140,
          normalMaxLines: 1,
          compactMaxLines: 2,
          normalSoftWrap: true,
          compactSoftWrap: true,
        ),

        // CobPolicyColumn<AsethullCariModel>(
        //   title: "NO POLIS",
        //   valueGetter: (d) => d.polisNo,
        //   normalFlex: 2.0,
        //   compactWidth: 140,
        //   normalMaxLines: 1,
        //   compactMaxLines: 2,
        //   normalSoftWrap: true,
        //   compactSoftWrap: true,
        // ),

        CobPolicyColumn<AsethullCariModel>(
          title: "JUMLAH OBJEK",
          valueGetter: (d) => "${d.jmlObject} ${d.satuan}",
          normalFlex: 1.2,
          compactWidth: 100,
          normalMaxLines: 1,
          compactMaxLines: 1,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),

        CobPolicyColumn<AsethullCariModel>(
          title: "PERIODE",
          valueGetter: (d) =>
              "${cobPolicyFormatDate(d.periodeMulai)} - ${cobPolicyFormatDate(d.periodeAkhir)}",
          normalFlex: 2.2,
          compactWidth: 180,
          normalMaxLines: 2,
          compactMaxLines: 2,
          normalSoftWrap: true,
          compactSoftWrap: true,
        ),

        CobPolicyColumn<AsethullCariModel>(
          title: "TERTANGGUNG",
          valueGetter: (d) => d.tertanggung,
          normalFlex: 2.6,
          compactWidth: 170,
          normalMaxLines: 1,
          compactMaxLines: 2,
          normalSoftWrap: true,
          compactSoftWrap: true,
        ),

        CobPolicyColumn<AsethullCariModel>(
          title: "NILAI PERTANGGUNGAN",
          valueGetter: (d) => "${d.curr} ${cobPolicyFormatNum(d.tsi)}",
          normalFlex: 2.2,
          compactWidth: 170,
          normalMaxLines: 1,
          compactMaxLines: 1,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),

        CobPolicyColumn<AsethullCariModel>(
          title: "PREMI",
          valueGetter: (d) => "${d.curr} ${cobPolicyFormatNum(d.premi)}",
          normalFlex: 1.8,
          compactWidth: 130,
          normalMaxLines: 1,
          compactMaxLines: 1,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),
      ],
    );
  }

  void _showSuccessPopup(BuildContext context, AsethullCariModel d) {
    final asetHullId = d.asetHullId.trim();

    if (asetHullId.isEmpty) {
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

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailPolisHullTablePage(
          sppa1Id: asetHullId,
        ),
      ),
    );
  }
}
