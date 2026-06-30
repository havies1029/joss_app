import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/widgets/apptheme/radio_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/asetothers/asetotherscari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../models/asetothers/asetotherscari_model.dart';
import '../../../../../widgets/apptheme/register_client_pop_up.dart';
import '../template_polis_table/cob_policy_table.dart';
import 'detail_polis_others_table_page.dart';

class KargoCobTable extends StatefulWidget {
  final List<AsetothersCariModel> items;
  final List<String> selectedIds;

  final AsetothersCariModel? selectedItem;
  final void Function(AsetothersCariModel item)? onSelectItem;
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

  const KargoCobTable({
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
    this.readOnly = false,
    this.showFooter = true,
    this.title,
    required this.statusId,
  });

  @override
  State<KargoCobTable> createState() => _KargoCobTableState();
}

class _KargoCobTableState extends State<KargoCobTable> {

  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final showColumn = widget.statusId == "10002";

    return CobPolicyTable<AsetothersCariModel>(
      items: widget.items,
      selectedIds: widget.selectedIds,
      idGetter: (d) => d.asetOthersId,
      nomorGetter: (d, index) => d.nomor.toString(),

      title: widget.title,
      readOnly: widget.readOnly,
      showFooter: widget.showFooter,

      hasReachedMax: context.watch<AsetothersCariBloc>().state.hasReachedMax,
      isFetching: context.watch<AsetothersCariBloc>().state.isFetching,
      onLoadMore: () {
        context.read<AsetothersCariBloc>().add(FetchAsetothersCariEvent());
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
          CobPolicyColumn<AsetothersCariModel>(
            title: "NOMOR PROSES",
            valueGetter: (d) => d.prosesId.isEmpty ? "-" : d.prosesId,
            normalFlex: 1.4,
            compactWidth: 140,
            normalSoftWrap: false,
            compactSoftWrap: false,
          ),

        CobPolicyColumn<AsetothersCariModel>(
          title: "NO POLIS",
          valueGetter: (d) => cobPolicyTextOrDash(d.polisNo),
          normalFlex: showColumn ? 1.2 : 2.2,
          compactWidth: showColumn ? 120 : 160,
          normalMaxLines: 1,
          compactMaxLines: 2,
          normalSoftWrap: true,
          compactSoftWrap: true,
        ),

        // CobPolicyColumn<AsetothersCariModel>(
        //   title: "NO POLIS",
        //   valueGetter: (d) => d.polisNo,
        //   normalFlex: 2.2,
        //   compactWidth: 160,
        //   normalMaxLines: 1,
        //   compactMaxLines: 2,
        //   normalSoftWrap: true,
        //   compactSoftWrap: true,
        // ),

        CobPolicyColumn<AsetothersCariModel>(
          title: "JUMLAH OBJEK",
          valueGetter: (d) => "${d.jmlObject} ${d.satuan}",
          normalFlex: 1.5,
          compactWidth: 120,
          normalMaxLines: 1,
          compactMaxLines: 1,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),

        CobPolicyColumn<AsetothersCariModel>(
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

        CobPolicyColumn<AsetothersCariModel>(
          title: "TERTANGGUNG",
          valueGetter: (d) => d.tertanggung,
          normalFlex: 2.5,
          compactWidth: 170,
          normalMaxLines: 1,
          compactMaxLines: 2,
          normalSoftWrap: true,
          compactSoftWrap: true,
        ),

        CobPolicyColumn<AsetothersCariModel>(
          title: "NILAI PERTANGGUNGAN",
          valueGetter: (d) => "${d.curr} ${cobPolicyFormatNum(d.sumInsured)}",
          normalFlex: 2.3,
          compactWidth: 170,
          normalMaxLines: 1,
          compactMaxLines: 1,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),

        CobPolicyColumn<AsetothersCariModel>(
          title: "PREMI",
          valueGetter: (d) => "${d.curr} ${cobPolicyFormatNum(d.premi)}",
          normalFlex: 1.8,
          compactWidth: 140,
          normalMaxLines: 1,
          compactMaxLines: 1,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),
      ],
    );
  }

  void _showSuccessPopup(BuildContext context, AsetothersCariModel d) {
    final asetOthersId = d.asetOthersId.trim();

    if (asetOthersId.isEmpty) {
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
          child: DetailPolisOthersTablePage(
            sppa1Id: asetOthersId,
          ),
        );
      },
    );
  }
}
