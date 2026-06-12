import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../../../models/gen_aset_par/asetparcari_model.dart';
import '../../../../../widgets/apptheme/register_client_pop_up.dart';
import '../template_polis_table/cob_policy_table.dart';
import 'detail_polis_par_table_page.dart';

class PropertyCobTable extends StatefulWidget {
  final List<AsetParCariModel> items;
  final List<String> selectedIds;
  final void Function(AsetParCariModel item)? onSelectItem;
  final void Function(String id) selectedProsesId;
  final AsetParCariModel? selectedItem;
  final VoidCallback? onClearSelectedItem;

  final Function(String id) onSelect;
  final Function(String id) onUnselect;

  final Function(String id) onSelectFilePolisParId;
  final Function(String id) onUnselectFilePolisParId;

  final Function(String id) onSelectFilePolisEqId;
  final Function(String id) onUnselectFilePolisEqId;

  final bool readOnly;
  final bool showFooter;
  final String? title;

  final String statusId;

  const PropertyCobTable({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelectItem,
    required this.selectedProsesId,
    required this.onSelect,
    required this.onUnselect,
    required this.onSelectFilePolisParId,
    required this.onUnselectFilePolisParId,
    required this.onSelectFilePolisEqId,
    required this.onUnselectFilePolisEqId,
    required this.selectedItem,
    required this.onClearSelectedItem,
    required this.statusId,
    this.readOnly = false,
    this.showFooter = true,
    this.title,
  });

  @override
  State<PropertyCobTable> createState() => _PropertyCobTableState();
}

class _PropertyCobTableState extends State<PropertyCobTable> {
  String formatNum(num? value) =>
      NumberFormat("#,##0.00", "id_ID").format(value ?? 0);

  @override
  Widget build(BuildContext context) {
    final showColumn = widget.statusId == "10002";

    return CobPolicyTable<AsetParCariModel>(
      items: widget.items,
      selectedIds: widget.selectedIds,
      idGetter: (d) => d.asetParId,
      nomorGetter: (d, index) => d.nomor.toString(),

      title: widget.title,
      readOnly: widget.readOnly,
      showFooter: widget.showFooter,

      hasReachedMax: context.watch<AsetParCariBloc>().state.hasReachedMax,
      isFetching: context.watch<AsetParCariBloc>().state.isFetching,
      onLoadMore: () {
        context.read<AsetParCariBloc>().add(FetchAsetParCariEvent());
      },

      onSelect: widget.onSelect,
      onUnselect: widget.onUnselect,
      onSelectItem: widget.onSelectItem,
      onClearSelectedItem: widget.onClearSelectedItem,

      onSelectExtra: (d) {
        if (d.filePolisParId.isNotEmpty) {
          widget.onSelectFilePolisParId(d.filePolisParId);
        }
        if (d.filePolisEqId.isNotEmpty) {
          widget.onSelectFilePolisEqId(d.filePolisEqId);
        }
      },

      onUnselectExtra: (d) {
        if (d.filePolisParId.isNotEmpty) {
          widget.onUnselectFilePolisParId(d.filePolisParId);
        }
        if (d.filePolisEqId.isNotEmpty) {
          widget.onUnselectFilePolisEqId(d.filePolisEqId);
        }
      },

      onOpenDetail: (context, d) {
        _showSuccessPopup(context, d);
      },

      columns: [
        // if (showColumn)
        //   CobPolicyColumn<AsetParCariModel>(
        //     title: "NOMOR PROSES",
        //     valueGetter: (d) => d.prosesId.isEmpty ? "-" : d.prosesId,
        //     normalFlex: 1.4,
        //     compactWidth: 140,
        //     normalSoftWrap: false,
        //     compactSoftWrap: false,
        //   ),

        // CobPolicyColumn<AsetParCariModel>(
        //   title: "NO POLIS",
        //   valueGetter: (d) => d.polisNo,
        //   normalFlex: showColumn ? 1.2 : 1.6,
        //   compactWidth: showColumn ? 120 : 160,
        //   normalMaxLines: 1,
        //   compactMaxLines: 2,
        // ),

        CobPolicyColumn<AsetParCariModel>(
          title: "NO POLIS",
          valueGetter: (d) => d.polisNo,
          normalFlex: 1.6,
          compactWidth: 160,
          normalMaxLines: 1,
          compactMaxLines: 2,
        ),

        CobPolicyColumn<AsetParCariModel>(
          title: "JUMLAH OBJEK",
          valueGetter: (d) => "${d.jmlObject} ${d.satuan}",
          normalFlex: 1.2,
          compactWidth: 120,
          normalMaxLines: 1,
          compactMaxLines: 2,
        ),

        CobPolicyColumn<AsetParCariModel>(
          title: "PERIODE",
          valueGetter: (d) =>
          "${cobPolicyFormatDate(d.periodeMulai)} - ${cobPolicyFormatDate(d.periodeAkhir)}",
          normalFlex: 1.8,
          compactWidth: 180,
          normalMaxLines: 2,
          compactMaxLines: 2,
        ),

        CobPolicyColumn<AsetParCariModel>(
          title: "TERTANGGUNG",
          valueGetter: (d) => d.tertanggung,
          normalFlex: 1.7,
          compactWidth: 170,
          normalMaxLines: 1,
          compactMaxLines: 2,
        ),

        CobPolicyColumn<AsetParCariModel>(
          title: "NILAI PERTANGGUNGAN",
          valueGetter: (d) => "${d.curr} ${cobPolicyFormatNum(d.sumInsured)}",
          normalFlex: 1.7,
          compactWidth: 170,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),

        CobPolicyColumn<AsetParCariModel>(
          title: "PREMI",
          valueGetter: (d) => "${d.curr} ${cobPolicyFormatNum(d.premi)}",
          normalFlex: 1.4,
          compactWidth: 140,
          normalSoftWrap: false,
          compactSoftWrap: false,
        ),
      ],
    );
  }

  void _showSuccessPopup(BuildContext context, AsetParCariModel d) {
    final asetParId = d.asetParId.trim();

    if (asetParId.isEmpty) {
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
          child: DetailPolisParTablePage(
            sppa1Id: asetParId,
          ),
        );
      },
    );
  }
}