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
          /// 🔥 FILTER SECTION (dibungkus background)
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
                      if (ringkasanState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (ringkasanState.status == ListStatus.failure) {
                        return const Center(child: Text('Failed to fetch data'));
                      }

                      if (ringkasanState.items.isEmpty) {
                        final label = _selectedStatusLabel(context);
                        return EmptyStateWidget(statusLabel: label);
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
                      if (parState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (parState.status == ListStatus.failure) {
                        return const Center(child: Text('Failed to fetch data'));
                      }

                      if (parState.items.isEmpty) {
                        final label = _selectedStatusLabel(context);
                        return EmptyStateWidget(statusLabel: label);
                      }

                      return PropertyCobTable(
                        // title: "Polis Property",
                        items: parState.items,
                        selectedIds: parState.selectedIds.toList(),
                        onSelect: (id) => context.read<AsetParCariBloc>().add(SelectDetailEvent(id)),
                        onUnselect: (id) => context.read<AsetParCariBloc>().add(UnselectDetailEvent(id)),
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
                      if (mvState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (mvState.status == ListStatus.failure) {
                        return const Center(child: Text('Failed to fetch data'));
                      }
                      if (mvState.items.isEmpty) {
                        final label = _selectedStatusLabel(context);
                        return EmptyStateWidget(statusLabel: label);
                      }

                      return KendaraanCobTable(
                        // title: "Polis Property",
                        items: mvState.items,
                        selectedIds: mvState.selectedIds.toList(),
                        onSelect: (id) => context.read<AsetMvCariBloc>().add(SelectMvDetailEvent(id)),
                        onUnselect: (id) => context.read<AsetMvCariBloc>().add(UnselectMvDetailEvent(id)),
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
                      if (HullState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (HullState.status == ListStatus.failure) {
                        return const Center(child: Text(
                            'Failed to fetch data'));
                      }
                      if (HullState.items.isEmpty) {
                        final label = _selectedStatusLabel(context);
                        return EmptyStateWidget(statusLabel: label);
                      }

                      return HullCobTable(
                        // title: "Polis Property",
                        items: HullState.items,
                        selectedIds: HullState.selectedIds.toList(),
                        onSelect: (id) =>
                            context.read<AsethullCariBloc>().add(
                                SelectHullDetailEvent(id)),
                        onUnselect: (id) =>
                            context.read<AsethullCariBloc>().add(
                                UnselectHullDetailEvent(id)),
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
                      if (healthState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (healthState.status == ListStatus.failure) {
                        return const Center(child: Text('Failed to fetch data'));
                      }
                      if (healthState.items.isEmpty) {
                        final label = _selectedStatusLabel(context);
                        return EmptyStateWidget(statusLabel: label);
                      }

                      return HealthCobTable(
                        // title: "Polis Property",
                        items: healthState.items,
                        selectedIds: healthState.selectedIds.toList(),
                        onSelect: (id) => context.read<AsetHealthCariBloc>().add(SelectHealthDetailEvent(id)),
                        onUnselect: (id) => context.read<AsetHealthCariBloc>().add(UnselectHealthDetailEvent(id)),
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
                      if (othersState.status == ListStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (othersState.status == ListStatus.failure) {
                        return const Center(child: Text('Failed to fetch data'));
                      }
                      if (othersState.items.isEmpty) {
                        final label = _selectedStatusLabel(context);
                        return EmptyStateWidget(statusLabel: label);
                      }

                      return KargoCobTable(
                        // title: "Polis Property",
                        items: othersState.items,
                        selectedIds: othersState.selectedIds.toList(),
                        onSelect: (id) => context.read<AsetothersCariBloc>().add(SelectOthersDetailEvent(id)),
                        onUnselect: (id) => context.read<AsetothersCariBloc>().add(UnselectOthersDetailEvent(id)),
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

  bool hasSelected(BuildContext context) {
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
        "Benefit": d.benefit,
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
    final rows = _exportRows(); // hasil map export (udah sesuai COB aktif)

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

    // preview max 15 baris biar tidak kepanjangan
    final previewRows = rows.take(15).map((m) {
      // contoh format: • No: 1 | Tertanggung: A | Alamat: ... | ...
      final parts = m.entries.map((e) => "${e.key}: ${fmt(e.value)}").join(" | ");
      return "• $parts";
    }).join("\n");

    final more = rows.length > 15 ? "\n…dan ${rows.length - 15} data lainnya" : "";

    final message = '''
📄 Rincian Terpilih ($cobLabel)

Jumlah Data: ${rows.length}

Detail:
$previewRows$more
''';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.share, color: primaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  "Bagikan Rincian ($cobLabel)",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(message, style: const TextStyle(fontSize: 14, height: 1.5)),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text("Salin Rincian"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    successSnackBar("Rincian berhasil disalin", icon: Icons.copy),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text("Batal"),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
