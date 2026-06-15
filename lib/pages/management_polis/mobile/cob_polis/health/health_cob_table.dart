import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/gen_aset_health/asethealthcari_bloc.dart';
import '../../../../../models/gen_aset_health/asethealthcari_model.dart';
import '../../../../../widgets/apptheme/register_client_pop_up.dart';
import '../template_polis_table/cob_policy_table.dart';
import 'detail_polis_health_table_page.dart';

class HealthCobTable extends StatefulWidget {
  final List<AsetHealthCariModel> items;
  final List<String> selectedIds;

  final AsetHealthCariModel? selectedItem;
  final void Function(AsetHealthCariModel item)? onSelectItem;
  final VoidCallback? onClearSelectedItem;

  final void Function(String id) selectedProsesId;

  final Function(String id) onSelect;
  final Function(String id) onUnselect;

  final Function(String id) onSelectFilePolisHealthId;
  final Function(String id) onUnselectFilePolisHealthId;

  final bool readOnly;
  final bool showFooter;
  final String? title;

  final String statusId;

  const HealthCobTable({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.selectedItem,
    required this.onSelectItem,
    required this.onClearSelectedItem,
    required this.selectedProsesId,
    required this.onSelect,
    required this.onUnselect,
    required this.onSelectFilePolisHealthId,
    required this.onUnselectFilePolisHealthId,
    required this.statusId,
    this.readOnly = false,
    this.showFooter = true,
    this.title,
  });

  @override
  State<HealthCobTable> createState() => _HealthCobTableState();
}

class _HealthCobTableState extends State<HealthCobTable> {

  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final showColumn = widget.statusId == "10002";

    return CobPolicyTable<AsetHealthCariModel>(
      items: widget.items,
      selectedIds: widget.selectedIds,
      idGetter: (d) => d.asethealthId,
      nomorGetter: (d, index) => d.nomor.toString(),

      title: widget.title,
      readOnly: widget.readOnly,
      showFooter: widget.showFooter,

      hasReachedMax: context.watch<AsetHealthCariBloc>().state.hasReachedMax,
      isFetching: context.watch<AsetHealthCariBloc>().state.isFetching,
      onLoadMore: () {
        context.read<AsetHealthCariBloc>().add(FetchAsetHealthCariEvent());
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
          widget.onSelectFilePolisHealthId(d.filePolisId);
        }
      },

      onUnselectExtra: (d) {
        if (d.filePolisId.isNotEmpty) {
          widget.onUnselectFilePolisHealthId(d.filePolisId);
        }
      },

      onOpenDetail: (context, d) {
        _showSuccessPopup(context, d);
      },

      columns: [
        if (showColumn)
          CobPolicyColumn<AsetHealthCariModel>(
            title: "NOMOR PROSES",
            valueGetter: (d) => d.prosesId.isEmpty ? "-" : d.prosesId,
            normalFlex: 1.4,
            compactWidth: 140,
            normalSoftWrap: false,
            compactSoftWrap: false,
          ),

        CobPolicyColumn<AsetHealthCariModel>(
          title: "NO POLIS",
          valueGetter: (d) => d.polisNo,
          normalFlex: showColumn ? 1.2 : 2.0,
          compactWidth: showColumn ? 120 : 160,
          normalMaxLines: 1,
          compactMaxLines: 2,
        ),

        // CobPolicyColumn<AsetHealthCariModel>(
        //   title: "NO POLIS",
        //   valueGetter: (d) => d.polisNo,
        //   normalFlex: 2.0,
        //   compactWidth: 160,
        //   normalMaxLines: 1,
        //   compactMaxLines: 2,
        // ),

        CobPolicyColumn<AsetHealthCariModel>(
          title: "JUMLAH OBJEK",
          valueGetter: (d) => "${d.jmlObject} ${d.satuan}",
          normalFlex: 1.6,
          compactWidth: 120,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),

        CobPolicyColumn<AsetHealthCariModel>(
          title: "PERIODE",
          valueGetter: (d) =>
          "${cobPolicyFormatDate(d.periodeMulai)} - ${cobPolicyFormatDate(d.periodeAkhir)}",
          normalFlex: 2.2,
          compactWidth: 180,
          normalMaxLines: 2,
          compactMaxLines: 2,
        ),

        CobPolicyColumn<AsetHealthCariModel>(
          title: "TERTANGGUNG",
          valueGetter: (d) => d.tertanggung,
          normalFlex: 2.4,
          compactWidth: 180,
          normalMaxLines: 1,
          compactMaxLines: 2,
        ),

        CobPolicyColumn<AsetHealthCariModel>(
          title: "NILAI PERTANGGUNGAN",
          valueGetter: (d) => "${d.curr} ${cobPolicyFormatNum(d.sumInsured)}",
          normalFlex: 2.2,
          compactWidth: 170,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),

        CobPolicyColumn<AsetHealthCariModel>(
          title: "PREMI",
          valueGetter: (d) => "${d.curr} ${cobPolicyFormatNum(d.premi)}",
          normalFlex: 1.8,
          compactWidth: 140,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),
      ],
    );
  }

  void _showSuccessPopup(BuildContext context, AsetHealthCariModel d) {
    final asetHealthId = d.asethealthId.trim();

    if (asetHealthId.isEmpty) {
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
          child: DetailPolisHealthTablePage(
            sppa1Id: asetHealthId,
          ),
        );
      },
    );
  }
}