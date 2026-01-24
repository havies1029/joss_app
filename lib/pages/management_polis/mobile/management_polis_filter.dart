import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/gen_aset_health/asethealthcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_mv/asetmvcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_par/asetparcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/blocs/gen_status_aset/statusasetcari_bloc.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/gen_cob_app/button_group_cob_aset.dart';
import 'package:joss_app/pages/gen_status_aset/button_group_status_aset.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/asetothers/asetotherscari_bloc.dart';
import '../../../blocs/gen_aset_hull/asethullcari_bloc.dart';
import '../../../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../../../helper/expert_helper.dart';
import '../../../helper/mobile_expert_helper.dart';
import '../../../widgets/EmptyStateWidget.dart';
import '../../../widgets/apptheme/polis_button.dart';
import '../../../widgets/apptheme/popup_widget.dart';
import 'cob_polis/health_cob_table.dart';
import 'cob_polis/hull_cob_table.dart';
import 'cob_polis/kargo_cob_table.dart';
import 'cob_polis/kendaraan_cob_table.dart';
import 'cob_polis/property_cob_table.dart';
import 'package:joss_app/pages/management_polis/floating_action_menu_widget.dart';

import 'cob_polis/ringkasan_cob_table.dart';

class ManagementPolisFilter extends StatefulWidget {
  const ManagementPolisFilter({super.key});

  @override
  State<ManagementPolisFilter> createState() => _ManagementPolisFilterState();
}

class _ManagementPolisFilterState extends State<ManagementPolisFilter> {
  final TextEditingController _searchController = TextEditingController();

  // bloc refs
  late CobManPolBloc cobAsetBloc;
  late StatusAsetCariBloc statusAsetBloc;
  late AsetRingkasanCariBloc asetRingkasanCariBloc;
  late AsetParCariBloc asetParCariBloc;
  late AsetMvCariBloc asetMvCariBloc;
  late AsethullCariBloc asetHullCariBloc;
  late AsetHealthCariBloc asetHealthCariBloc;
  late AsetothersCariBloc asetOthersCariBloc;

  bool _bootstrapped = false;

  String _cobId() => context.read<CobManPolBloc>().state.selectedCOBId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bootstrapped = true;
      refreshData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // cache bloc references
    cobAsetBloc = context.read<CobManPolBloc>();
    statusAsetBloc = context.read<StatusAsetCariBloc>();
    asetRingkasanCariBloc = context.read<AsetRingkasanCariBloc>();
    asetParCariBloc = context.read<AsetParCariBloc>();
    asetMvCariBloc = context.read<AsetMvCariBloc>();
    asetHullCariBloc = context.read<AsethullCariBloc>();
    asetHealthCariBloc = context.read<AsetHealthCariBloc>();
    asetOthersCariBloc = context.read<AsetothersCariBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<StatusAsetCariBloc, StatusAsetCariState>(
          listenWhen: (prev, curr) => prev.selectedStatusId != curr.selectedStatusId,
          listener: (context, state) {
            // Hindari refresh sebelum bootstrap first frame (optional safety)
            if (!_bootstrapped) return;
            refreshData();
          },
        ),

        BlocListener<CobManPolBloc, CobManPolState>(
          listenWhen: (prev, curr) => prev.selectedCOBId != curr.selectedCOBId,
          listener: (context, state) {
            if (!_bootstrapped) return;
            if (state.selectedCOBId.isNotEmpty) refreshData();
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          BlocBuilder<CobManPolBloc, CobManPolState>(
            builder: (context, state) => _buildBodyByCob(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: secondaryBlackColor,
      padding: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: hPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ButtonGroupCobAsetWidget(),
          const SizedBox(height: hPadding),

          BlocSelector<CobManPolBloc, CobManPolState, String>(
            selector: (state) => state.selectedCOBId,
            builder: (context, selectedCobId) {
              final hideSearch = selectedCobId == "10001";

              return Row(
                mainAxisAlignment: hideSearch ? MainAxisAlignment.center : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!hideSearch) ...[
                    Expanded(
                      child: ListPageFilterBarUIWidget(
                        searchController: _searchController,
                        searchButton: buildSearchButton(),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  PolisButton(
                    assetPath: "assets/icons/unduh.svg",
                    bgColor: bGrey,
                    borderColor: bdGrey,
                    onTap: () => _showExportDialog(context),
                    iconSize: 16,
                    height: 36,
                    width: 36,
                  ),
                  const SizedBox(width: 8),
                  PolisButton(
                    assetPath: "assets/icons/bagikan.svg",
                    bgColor: bBlue,
                    borderColor: bdBlue,
                    onTap: () => _onShare(context),
                    iconSize: 16,
                    height: 36,
                    width: 36,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: hPadding),
          const ButtonGroupStatusAsetWidget(),
        ],
      ),
    );
  }

  Widget _buildBodyByCob(BuildContext context, CobManPolState state) {
    if (state.status == ListStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == ListStatus.failure) {
      return const Center(child: Text('Failed to fetch data'));
    }
    if (state.items.isEmpty) {
      return const Center(child: Text('No items found'));
    }

    final cobId = state.selectedCOBId;

    switch (cobId) {
      case "10001":
        return SizedBox(height: 400, child: _buildRingkasanTable(context));

      case "10002":
        return SizedBox(height: 400, child: _buildParTable(context));

      case "10003":
        return SizedBox(height: 400, child: _buildMvTable(context));

      case "10004":
        return SizedBox(height: 400, child: _buildHullTable(context));

      case "10005":
        return SizedBox(height: 400, child: _buildHealthTable(context));

      case "10006":
        return SizedBox(height: 400, child: _buildOthersTable(context));

      default:
        return const Center(child: Text('Belum ada Table untuk COB ini'));
    }
  }

  // --------------------------
  // Builders per COB (Fix D)
  // --------------------------

  Widget _buildRingkasanTable(BuildContext context) {
    return BlocBuilder<AsetRingkasanCariBloc, AsetRingkasanCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
              (b) => b.state.selectedStatusId,
        );

        if (s.status == ListStatus.initial || s.status == ListStatus.loadingMore) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.status == ListStatus.failure) {
          return const Center(child: Text('Failed to fetch data'));
        }
        if (s.status == ListStatus.success && s.items.isEmpty) {
          return EmptyStateWidget(statusId: statusId);
        }

        return RingkasanCobTable(items: s.items);
      },
    );
  }

  Widget _buildParTable(BuildContext context) {
    return BlocBuilder<AsetParCariBloc, AsetParCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
              (b) => b.state.selectedStatusId,
        );

        if (s.status == ListStatus.initial || s.status == ListStatus.loadingMore) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.status == ListStatus.failure) {
          return const Center(child: Text('Failed to fetch data'));
        }
        if (s.status == ListStatus.success && s.items.isEmpty) {
          return EmptyStateWidget(statusId: statusId);
        }

        return PropertyCobTable(
          items: s.items,
          selectedIds: s.selectedIds.toList(),
          onSelect: (id) => context.read<AsetParCariBloc>().add(SelectDetailEvent(id)),
          onUnselect: (id) => context.read<AsetParCariBloc>().add(UnselectDetailEvent(id)),
          onSelectFilePolisParId: (id) =>
              context.read<AsetParCariBloc>().add(SelectPolisParDetailEvent(id)),
          onUnselectFilePolisParId: (id) =>
              context.read<AsetParCariBloc>().add(UnselectPolisParDetailEvent(id)),
          onSelectFilePolisEqId: (id) =>
              context.read<AsetParCariBloc>().add(SelectPolisEqDetailEvent(id)),
          onUnselectFilePolisEqId: (id) =>
              context.read<AsetParCariBloc>().add(UnselectPolisEqDetailEvent(id)),
          readOnly: false,
        );
      },
    );
  }

  Widget _buildMvTable(BuildContext context) {
    return BlocBuilder<AsetMvCariBloc, AsetMvCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
              (b) => b.state.selectedStatusId,
        );

        if (s.status == ListStatus.initial || s.status == ListStatus.loadingMore) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.status == ListStatus.failure) {
          return const Center(child: Text('Failed to fetch data'));
        }
        if (s.status == ListStatus.success && s.items.isEmpty) {
          return EmptyStateWidget(statusId: statusId);
        }

        return KendaraanCobTable(
          items: s.items,
          selectedIds: s.selectedIds.toList(),
          onSelect: (id) => context.read<AsetMvCariBloc>().add(SelectMvDetailEvent(id)),
          onUnselect: (id) => context.read<AsetMvCariBloc>().add(UnselectMvDetailEvent(id)),
          onSelectFilePolisMvId: (id) =>
              context.read<AsetMvCariBloc>().add(SelectPolisMvDetailEvent(id)),
          onUnselectFilePolisMvId: (id) =>
              context.read<AsetMvCariBloc>().add(UnselectPolisMvDetailEvent(id)),
          readOnly: false,
        );
      },
    );
  }

  Widget _buildHullTable(BuildContext context) {
    return BlocBuilder<AsethullCariBloc, AsethullCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
              (b) => b.state.selectedStatusId,
        );

        if (s.status == ListStatus.initial || s.status == ListStatus.loadingMore) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.status == ListStatus.failure) {
          return const Center(child: Text('Failed to fetch data'));
        }
        if (s.status == ListStatus.success && s.items.isEmpty) {
          return EmptyStateWidget(statusId: statusId);
        }

        return HullCobTable(
          items: s.items,
          selectedIds: s.selectedIds.toList(),
          onSelect: (id) => context.read<AsethullCariBloc>().add(SelectHullDetailEvent(id)),
          onUnselect: (id) => context.read<AsethullCariBloc>().add(UnselectHullDetailEvent(id)),
          onSelectFilePolisHullId: (id) =>
              context.read<AsethullCariBloc>().add(SelectPolisHullDetailEvent(id)),
          onUnselectFilePolisHullId: (id) =>
              context.read<AsethullCariBloc>().add(UnselectPolisHullDetailEvent(id)),
          readOnly: false,
        );
      },
    );
  }

  Widget _buildHealthTable(BuildContext context) {
    return BlocBuilder<AsetHealthCariBloc, AsetHealthCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
              (b) => b.state.selectedStatusId,
        );

        if (s.status == ListStatus.initial || s.status == ListStatus.loadingMore) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.status == ListStatus.failure) {
          return const Center(child: Text('Failed to fetch data'));
        }
        if (s.status == ListStatus.success && s.items.isEmpty) {
          return EmptyStateWidget(statusId: statusId);
        }

        return HealthCobTable(
          items: s.items,
          selectedIds: s.selectedIds.toList(),
          onSelect: (id) => context.read<AsetHealthCariBloc>().add(SelectHealthDetailEvent(id)),
          onUnselect: (id) => context.read<AsetHealthCariBloc>().add(UnselectHealthDetailEvent(id)),
          onSelectFilePolisHealthId: (id) =>
              context.read<AsetHealthCariBloc>().add(SelectPolisHealthDetailEvent(id)),
          onUnselectFilePolisHealthId: (id) =>
              context.read<AsetHealthCariBloc>().add(UnselectPolisHealthDetailEvent(id)),
          readOnly: false,
        );
      },
    );
  }

  Widget _buildOthersTable(BuildContext context) {
    return BlocBuilder<AsetothersCariBloc, AsetothersCariState>(
      builder: (context, s) {
        final statusId = context.select<StatusAsetCariBloc, String>(
              (b) => b.state.selectedStatusId,
        );

        if (s.status == ListStatus.initial || s.status == ListStatus.loadingMore) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.status == ListStatus.failure) {
          return const Center(child: Text('Failed to fetch data'));
        }
        if (s.status == ListStatus.success && s.items.isEmpty) {
          return EmptyStateWidget(statusId: statusId);
        }

        return KargoCobTable(
          items: s.items,
          selectedIds: s.selectedIds.toList(),
          onSelect: (id) => context.read<AsetothersCariBloc>().add(SelectOthersDetailEvent(id)),
          onUnselect: (id) => context.read<AsetothersCariBloc>().add(UnselectOthersDetailEvent(id)),
          onSelectFilePolisHealthId: (id) =>
              context.read<AsetothersCariBloc>().add(SelectPolisOthersDetailEvent(id)),
          onUnselectFilePolisHealthId: (id) =>
              context.read<AsetothersCariBloc>().add(UnselectPolisOthersDetailEvent(id)),
          readOnly: false,
        );
      },
    );
  }


  IconButton buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 35.0),
      onPressed: refreshData,
    );
  }

  void refreshData() {
    var stateCob = cobAsetBloc.state;
    var stateStatus = statusAsetBloc.state;

    if (stateCob.selectedCOBId == "10001") {
      asetRingkasanCariBloc.add(RefreshAsetRingkasanCariEvent(
        statusId: stateStatus.selectedStatusId,
        searchText: _searchController.text,
      ));
    } else if (stateCob.selectedCOBId == "10002") {
      asetParCariBloc.add(RefreshAsetParCariEvent(
        statusId: stateStatus.selectedStatusId,
        searchText: _searchController.text,
      ));
    } else if (stateCob.selectedCOBId == "10003") {
      asetMvCariBloc.add(RefreshAsetMvCariEvent(
        statusId: stateStatus.selectedStatusId,
        searchText: _searchController.text,
      ));
    } else if (stateCob.selectedCOBId == "10004") {
      asetHullCariBloc.add(RefreshAsethullCariEvent(
        statusId: stateStatus.selectedStatusId,
        searchText: _searchController.text,
      ));
    } else if (stateCob.selectedCOBId == "10005") {
      asetHealthCariBloc.add(RefreshAsetHealthCariEvent(
        statusId: stateStatus.selectedStatusId,
        searchText: _searchController.text,
      ));
    } else if (stateCob.selectedCOBId == "10006") {
      asetOthersCariBloc.add(RefreshAsetothersCariEvent(
        statusId: stateStatus.selectedStatusId,
        searchText: _searchController.text, cobId: stateCob.selectedCOBId,
      ));
    }
  }

  bool hasSelectedhasSelected(BuildContext context) {
    final cobId = _cobId();

    // if (cobId == "10001") return context.select((AsetRingkasanCariBloc b) => b.state.selectedIds.isNotEmpty);
    if (cobId == "10002") return context.select((AsetParCariBloc b) => b.state.selectedIds.isNotEmpty);
    if (cobId == "10003") return context.select((AsetMvCariBloc b) => b.state.selectedIds.isNotEmpty);
    if (cobId == "10004") return context.select((AsethullCariBloc b) => b.state.selectedIds.isNotEmpty);
    if (cobId == "10005") return context.select((AsetHealthCariBloc b) => b.state.selectedIds.isNotEmpty);
    if (cobId == "10006") return context.select((AsetothersCariBloc b) => b.state.selectedIds.isNotEmpty);

    return false;
  }

  List<Map<String, dynamic>> _exportRows() {
    final cobId = _cobId();


    if (cobId == "10002") {
      final st = context.read<AsetParCariBloc>().state;

      return st.items
          .where((x) => st.selectedIds.contains(x.asetParId))
          .map((d) => {
        "No": d.nomor,
        "Tertanggung": d.tertanggung,
        "Alamat": d.alamat,
        "Periode Mulai": "${d.periodeMulai}",
        "Periode Akhir": "${d.periodeAkhir}",
        "Nilai Pertanggungan": d.sumInsured,
        "Premi": d.premi,
        "Status": d.status,
      })
          .toList();
    }

    if (cobId == "10003") {
      final st = context.read<AsetMvCariBloc>().state;

      return st.items
          .where((x) => st.selectedIds.contains(x.asetMvId))
          .map((d) => {
        "No": d.nomor,
        "Tertanggung": d.tertanggung,
        "Periode Mulai": "${d.periodeMulai}",
        "Periode Akhir": "${d.periodeAkhir}",
        "Merk Kendaraan": d.merk,
        "Nomor Polisi": d.noPolisi,
        "Nilai Tertanggung": d.sumInsured,
        "Premi": d.premi,
        "Status": d.status,
      })
          .toList();
    }

    if (cobId == "10004") {
      final st = context.read<AsethullCariBloc>().state;

      return st.items
          .where((x) => st.selectedIds.contains(x.asetHullId))
          .map((d) => {
        "No": st.items.indexOf(d) + 1,
        "Tertanggung": d.tertanggung,
        "Detail Rangka Kapal": d.namaKapal,
        "Nilai Tertanggung": d.tsi,
        "Premi": d.premi,
        "Status": d.status,
      })
          .toList();
    }

    if (cobId == "10005") {
      final st = context.read<AsetHealthCariBloc>().state;

      return st.items
          .where((x) => st.selectedIds.contains(x.asethealthId))
          .map((d) => {
        "No": d.nomor,
        "Nama": d.nama,
        "Status": d.status,
      })
          .toList();
    }

    if (cobId == "10001") {
      final st = context.read<AsetRingkasanCariBloc>().state;

      // Kalau kamu mau hanya yang terpilih, uncomment baris filter ini dan sesuaikan selectedIds-nya:
      // return st.items
      //   .where((x) => st.selectedIds.contains(x.asetRingkasanId))
      //   .map(...)

      return st.items
          .map((d) => {
        "No": st.items.indexOf(d) + 1,
        "Jenis Polis": d.asetNama,
        "Currency": d.curr,
        "Jumlah": d.jmlAset,
        "Nilai": d.nilaiAset,
        "Premi": d.nilaiPremi,
        "Nomor Urut": d.noUrut,
        "Satuan": d.satuan,
        // kalau kamu perlu id buat audit/export:
        // "ID": d.asetRingkasanId,
      })
          .toList();
    }

    if (cobId == "10006") {
      final st = context.read<AsetothersCariBloc>().state;

      return st.items
          .where((x) => st.selectedIds.contains(x.asetOthersId))
          .map((d) => {
        "No": d.nomor,
        "Object": d.objectDesc,
        "Polis No": d.polisNo,
        "Currency": d.curr,
        "Sum Insured": d.sumInsured,
        "Premi": d.premi,
        "Status": d.status,
      })
          .toList();
    }
    return [];
  }


  String _exportLabel() {
    final cobId = _cobId();
    if (cobId == "10001") return "RINGKASAN";
    if (cobId == "10002") return "PROPERTY";
    if (cobId == "10003") return "MV";
    if (cobId == "10004") return "HULL";
    if (cobId == "10005") return "HEALTH";
    if (cobId == "10006") return "KARGO";
    return "UNKNOWN";
  }

  CategoryType _exportCategory() {
    final cobId = _cobId();
    // if (cobId == "10001") return CategoryType.ringkasan;
    if (cobId == "10002") return CategoryType.properti;
    if (cobId == "10003") return CategoryType.kendaraan;
    if (cobId == "10004") return CategoryType.hull;
    if (cobId == "10005") return CategoryType.kesehatan;
    if (cobId == "10006") return CategoryType.marineKargo;

    return CategoryType.ringkasan;
  }

  void _showExportDialog(BuildContext context) {
    final rows = _exportRows();

    if (rows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(infoSnackBar("Pilih data terlebih dahulu"));
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: PopupWidget(
              title: "Pilih format file untuk diunduh",
              subtitle: "Tersedia Excel dan PDF",
              button1Text: "Excel",
              button2Text: "PDF",
              onExportSelected: (format) async {
                Navigator.pop(context);
                await _exportData(context, format, rows);
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
    );
  }

  Future<void> _exportData(
      BuildContext context,
      ExportFormat format,
      List<Map<String, dynamic>> rows,
      ) async {
    final ext = (format == ExportFormat.excel) ? "xlsx" : "pdf";
    final exportFormat = (format == ExportFormat.excel) ? "excel" : "pdf";

    final fileName = "Aset_${_exportLabel()}_${DateTime.now().millisecondsSinceEpoch}.$ext";

    try {
      if (kIsWeb) {
        await ExportHelper.export(exportFormat, rows, _exportCategory());
      } else {
        await MobileDownloadHelper.download(
          context: context,
          fileName: fileName,
          data: rows,
          format: exportFormat,
        );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          successSnackBar("Berhasil ekspor ${rows.length} item"),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar("Gagal ekspor: $e"),
        );
      }
    }
  }

  void _onShare(BuildContext context) {
    final rows = _exportRows();

    if (rows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        infoSnackBar("Pilih data terlebih dahulu"),
      );
      return;
    }

    final cobLabel = _exportLabel();

    String fmt(dynamic v) {
      if (v == null) return "-";
      if (v is num) return NumberFormat.decimalPattern().format(v);
      return v.toString();
    }

    final detailText = rows.map((m) {
      final parts = m.entries.map((e) => "${e.key}: ${fmt(e.value)}").join(" | ");
      return "• $parts";
    }).join("\n");

    final message = '''
📄 Rincian Terpilih ($cobLabel)

Jumlah Data: ${rows.length}

Detail:
$detailText
''';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // penting
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.share, color: primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    "Bagikan Rincian ($cobLabel)",
                    style: bodyTextStyle(context),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Text(
                "Total data terpilih: ${rows.length}",
                style: bodyTextStyle(context, fontSize: 14),
              ),

              const SizedBox(height: 20),

              AppButton.iconLeft(
                text: "Salin Rincian",
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    successSnackBar("Rincian berhasil disalin"),
                  );
                },
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*

class ManagementPolisFilter extends StatefulWidget {
  const ManagementPolisFilter({super.key});

  @override
  State<ManagementPolisFilter> createState() => _ManagementPolisFilterState();
}

class _ManagementPolisFilterState extends State<ManagementPolisFilter> {
  final TextEditingController _searchController = TextEditingController();
  late CobManPolBloc cobAsetBloc;
  late StatusAsetCariBloc statusAsetBloc;
  late AsetRingkasanCariBloc asetRingkasanCariBloc;
  late AsetParCariBloc asetParCariBloc;
  late AsetMvCariBloc asetMvCariBloc;
  late AsethullCariBloc asetHullCariBloc;
  late AsetHealthCariBloc asetHealthCariBloc;
  late AsetothersCariBloc asetOthersCariBloc;

  String _cobId() => context.read<CobManPolBloc>().state.selectedCOBId;

  String _selectedStatusLabel(BuildContext context) {
    final st = context.read<StatusAsetCariBloc>().state;

    if (st.selectedStatusId.isEmpty) return "Semua";

    final found = st.items.where((e) => e.mstatusasetId == st.selectedStatusId).toList();
    if (found.isEmpty) return "Semua";

    return found.first.statusNama;
  }

  @override
  Widget build(BuildContext context) {
    cobAsetBloc = context.read<CobManPolBloc>();
    statusAsetBloc = context.read<StatusAsetCariBloc>();
    asetRingkasanCariBloc = context.read<AsetRingkasanCariBloc>();
    asetParCariBloc = context.read<AsetParCariBloc>();
    asetMvCariBloc = context.read<AsetMvCariBloc>();
    asetHullCariBloc = context.read<AsethullCariBloc>();
    asetHealthCariBloc = context.read<AsetHealthCariBloc>();
    asetOthersCariBloc = context.read<AsetothersCariBloc>();

    return BlocListener<StatusAsetCariBloc, StatusAsetCariState>(
      listener: (context, state) => refreshData(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: secondaryBlackColor,
            padding: EdgeInsets.symmetric(
              horizontal: hPadding * 1.5,
              vertical: hPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ButtonGroupCobAsetWidget(),

                const SizedBox(height: hPadding),

                BlocSelector<CobManPolBloc, CobManPolState, String>(
                  selector: (state) => state.selectedCOBId,
                  builder: (context, selectedCobId) {
                    final hideSearch = selectedCobId == "10001";

                    return Row(
                      children: [
                        if (!hideSearch) ...[
                          Expanded(
                            child: ListPageFilterBarUIWidget(
                              searchController: _searchController,
                              searchButton: buildSearchButton(),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],

                        PolisButton(
                          assetPath: "assets/icons/unduh.svg",
                          bgColor: bGrey,
                          borderColor: bdGrey,
                          onTap: () => _showExportDialog(context),
                          iconSize: 16,
                          height: 36,
                          width: 36,
                        ),
                        const SizedBox(width: 8),
                        PolisButton(
                          assetPath: "assets/icons/bagikan.svg",
                          bgColor: bBlue,
                          borderColor: bdBlue,
                          onTap: () => _onShare(context),
                          iconSize: 16,
                          height: 36,
                          width: 36,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: hPadding),

                const ButtonGroupStatusAsetWidget(),
              ],
            ),
          ),
          // const SizedBox(height: 12),
          BlocConsumer<CobManPolBloc, CobManPolState>(
            builder: (context, state) {
              if (state.status == ListStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == ListStatus.failure) {
                return const Center(child: Text('Failed to fetch data'));
              }
              if (state.items.isEmpty) {
                return const Center(child: Text('No items found'));
              }

              if (state.selectedCOBId == "10001"){
                return SizedBox(
                  height: 400,
                  child: BlocBuilder<AsetRingkasanCariBloc, AsetRingkasanCariState>(
                    builder: (context, ringkasanState) {
                      var stateStatus = statusAsetBloc.state;

                      if (ringkasanState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (ringkasanState.status == ListStatus.failure) {
                        return const Center(child: Text('Failed to fetch data'));
                      }

                      if (ringkasanState.items.isEmpty) {
                        return EmptyStateWidget(statusId: stateStatus.selectedStatusId);
                      }

                      return RingkasanCobTable(
                        // title: "Polis Property",
                        items: ringkasanState.items,
                      );
                    },
                  ),
                );
              } else if (state.selectedCOBId == "10002") {
                return SizedBox(
                  height: 400,
                  child: BlocBuilder<AsetParCariBloc, AsetParCariState>(
                    builder: (context, parState) {
                      var stateStatus = statusAsetBloc.state;

                      if (parState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (parState.status == ListStatus.failure) {
                        return const Center(child: Text('Failed to fetch data'));
                      }

                      if (parState.items.isEmpty) {
                        return EmptyStateWidget(statusId: stateStatus.selectedStatusId);
                      }

                      return PropertyCobTable(
                        // title: "Polis Property",
                        items: parState.items,
                        selectedIds: parState.selectedIds.toList(),
                        onSelect: (id) => context.read<AsetParCariBloc>().add(SelectDetailEvent(id)),
                        onUnselect: (id) => context.read<AsetParCariBloc>().add(UnselectDetailEvent(id)),
                        onSelectFilePolisParId: (id) => context.read<AsetParCariBloc>().add(SelectPolisParDetailEvent(id)),
                        onUnselectFilePolisParId: (id) => context.read<AsetParCariBloc>().add(UnselectPolisParDetailEvent(id)),
                        onSelectFilePolisEqId: (id) =>  context.read<AsetParCariBloc>().add(SelectPolisEqDetailEvent(id)),
                        onUnselectFilePolisEqId: (id) =>  context.read<AsetParCariBloc>().add(UnselectPolisEqDetailEvent(id)),
                        readOnly: false,
                      );
                    },
                  ),
                );
              } else if (state.selectedCOBId == "10003") {
                return SizedBox(
                  height: 400,
                  child: BlocBuilder<AsetMvCariBloc, AsetMvCariState>(
                    builder: (context, mvState) {
                      var stateStatus = statusAsetBloc.state;

                      if (mvState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (mvState.status == ListStatus.failure) {
                        return const Center(child: Text('Failed to fetch data'));
                      }
                      if (mvState.items.isEmpty) {
                        return EmptyStateWidget(statusId: stateStatus.selectedStatusId);
                      }

                      return KendaraanCobTable(
                        // title: "Polis Property",
                        items: mvState.items,
                        selectedIds: mvState.selectedIds.toList(),
                        onSelect: (id) => context.read<AsetMvCariBloc>().add(SelectMvDetailEvent(id)),
                        onUnselect: (id) => context.read<AsetMvCariBloc>().add(UnselectMvDetailEvent(id)),
                        onSelectFilePolisMvId: (id) => context.read<AsetMvCariBloc>().add(SelectPolisMvDetailEvent(id)),
                        onUnselectFilePolisMvId: (id) => context.read<AsetMvCariBloc>().add(UnselectPolisMvDetailEvent(id)),
                        readOnly: false,
                      );
                    },
                  ),
                );
              } else if (state.selectedCOBId == "10004") {
                return SizedBox(
                  height: 400,
                  child: BlocBuilder<AsethullCariBloc, AsethullCariState>(
                    builder: (context, HullState) {
                      var stateStatus = statusAsetBloc.state;

                      if (HullState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (HullState.status == ListStatus.failure) {
                        return const Center(child: Text(
                            'Failed to fetch data'));
                      }
                      if (HullState.items.isEmpty) {
                        return EmptyStateWidget(statusId: stateStatus.selectedStatusId);
                      }

                      return HullCobTable(
                        // title: "Polis Property",
                        items: HullState.items,
                        selectedIds: HullState.selectedIds.toList(),
                        onSelect: (id) => context.read<AsethullCariBloc>().add(SelectHullDetailEvent(id)),
                        onUnselect: (id) =>context.read<AsethullCariBloc>().add(UnselectHullDetailEvent(id)),
                        onSelectFilePolisHullId: (id) => context.read<AsethullCariBloc>().add(SelectPolisHullDetailEvent(id)),
                        onUnselectFilePolisHullId: (id) => context.read<AsethullCariBloc>().add(UnselectPolisHullDetailEvent(id)),
                        readOnly: false,
                      );
                    },
                  ),
                );
              } else if (state.selectedCOBId == "10005") {
                return SizedBox(
                  height: 400,
                  child: BlocBuilder<AsetHealthCariBloc, AsetHealthCariState>(
                    builder: (context, healthState) {
                      var stateStatus = statusAsetBloc.state;

                      if (healthState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (healthState.status == ListStatus.failure) {
                        return const Center(child: Text('Failed to fetch data'));
                      }
                      if (healthState.items.isEmpty) {
                        return EmptyStateWidget(statusId: stateStatus.selectedStatusId);
                      }

                      return HealthCobTable(
                        // title: "Polis Property",
                        items: healthState.items,
                        selectedIds: healthState.selectedIds.toList(),
                        onSelect: (id) => context.read<AsetHealthCariBloc>().add(SelectHealthDetailEvent(id)),
                        onUnselect: (id) => context.read<AsetHealthCariBloc>().add(UnselectHealthDetailEvent(id)),
                        onSelectFilePolisHealthId: (id) => context.read<AsetHealthCariBloc>().add(SelectPolisHealthDetailEvent(id)),
                        onUnselectFilePolisHealthId: (id) => context.read<AsetHealthCariBloc>().add(UnselectPolisHealthDetailEvent(id)),
                        readOnly: false,
                      );
                    },
                  ),
                );
              }else if (state.selectedCOBId == "10006") {
                return SizedBox(
                  height: 400,
                  child: BlocBuilder<AsetothersCariBloc, AsetothersCariState>(
                    builder: (context, othersState) {
                      var stateStatus = statusAsetBloc.state;

                      if (othersState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (othersState.status == ListStatus.failure) {
                        return const Center(child: Text('Failed to fetch data'));
                      }
                      if (othersState.items.isEmpty) {
                        return EmptyStateWidget(statusId: stateStatus.selectedStatusId);
                      }

                      return KargoCobTable(
                        // title: "Polis Property",
                        items: othersState.items,
                        selectedIds: othersState.selectedIds.toList(),
                        onSelect: (id) => context.read<AsetothersCariBloc>().add(SelectOthersDetailEvent(id)),
                        onUnselect: (id) => context.read<AsetothersCariBloc>().add(UnselectOthersDetailEvent(id)),
                        onSelectFilePolisHealthId: (id) => context.read<AsetothersCariBloc>().add(SelectPolisOthersDetailEvent(id)),
                        onUnselectFilePolisHealthId: (id) => context.read<AsetothersCariBloc>().add(UnselectPolisOthersDetailEvent(id)),
                        readOnly: false,
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('Belum ada Table untuk COB ini'),
                );
              }
            },
            listener: (context, state) {
              if (state.selectedCOBId.isNotEmpty) refreshData();
            },
          ),
        ],
      ),
    );
  }
*/