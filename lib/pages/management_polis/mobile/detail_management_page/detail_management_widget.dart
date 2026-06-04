import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/models/regother/regother3cari_model.dart';
import 'package:joss_app/models/regreaktif/regreaktif2cari_model.dart';
import 'package:joss_app/models/regrenewal/regrenewal2cari_model.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/pages/management_polis/mobile/detail_management_page/polis_detail_card.dart';
import 'package:joss_app/pages/management_polis/mobile/detail_management_page/timeline_page.dart';
import 'package:joss_app/pages/management_polis/mobile/management_polis_page.dart';
import '../../../../../common/constants.dart';

import '../../../../blocs/gen_status_aset/statusasetcari_bloc.dart';
import '../../../../blocs/regendors/regendors1form_bloc.dart';
import '../../../../blocs/regendors/regendors2cari_bloc.dart';
import '../../../../blocs/regother/regother1crud_bloc.dart';
import '../../../../blocs/regother/regother3cari_bloc.dart';
import '../../../../blocs/regreaktif/regreaktif1_bloc.dart';
import '../../../../blocs/regreaktif/regreaktif2cari_bloc.dart';
import '../../../../blocs/regrenewal/regrenew1form_bloc.dart';
import '../../../../blocs/regrenewal/regrenewal2cari_bloc.dart';
import '../../../../models/regendors/regendors2cari_model.dart';

class DetailManagementPolisPage extends StatefulWidget {
  final dynamic data;
  final String cobId;
  final String? jenisProses;
  final String statusId;

  const DetailManagementPolisPage({
    super.key,
    required this.data,
    required this.cobId,
    required this.statusId,
    this.jenisProses,
  });

  @override
  State<DetailManagementPolisPage> createState() =>
      _DetailManagementPolisPageState();
}

class _DetailManagementPolisPageState extends State<DetailManagementPolisPage> {
  bool _loading = true;
  List<dynamic> _items = const [];

  late final Map<String, dynamic> _dataMap;
  late final String _sppa1Id;

  late final String _prosesSource; // "E" | "R" | "A" | ""
  late final String _prosesId;
  late final String _prosesRemarks;

  late Regendors1FormBloc regendors1;
  late Regendors2CariBloc regendors2;

  late Regreaktif1Bloc regreaktif1formBloc;
  late Regreaktif2CariBloc regreaktif2formBloc;

  late Regrenew1FormBloc regrenew1formBloc;
  late Regrenewal2CariBloc regrenew2formBloc;
  //
  // late Regothers1FormBloc regrenew1formBloc;
  late Regother1CrudBloc regother1crudBloc;
  late Regother3cariBloc regother3cariBloc;

  DateTime? Function(dynamic x)? _getDateTime;
  String Function(dynamic x)? _getStatusText;
  DateTime? _newestDate;
  int _activeIndex = -1;

  String _emptyText = "Belum ada data";

  @override
  void initState() {
    super.initState();

    _dataMap = _toMap(widget.data);
    _sppa1Id = extractAssetIdByCob(_dataMap, widget.cobId);

    _prosesSource = _dataMap["prosesSource"]?.toString() ?? "";
    _prosesId = _dataMap["prosesId"]?.toString() ?? "";
    _prosesRemarks = _dataMap["prosesRemarks"]?.toString() ?? "";

    _loading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerByProses(
        jenisProses: widget.jenisProses,
        prosesSource: _prosesSource,
        prosesId: _prosesId,
      );
    });
  }

  void _triggerByProses({
    required String? jenisProses,
    required String prosesSource,
    required String prosesId,
  }) {
    // 1) PRIORITAS: kalau prosesSource & prosesId dari dataMap ada, langsung pakai itu
    final srcFromData = prosesSource.trim().toUpperCase();
    final idFromData = prosesId.trim();

    if (srcFromData.isNotEmpty && idFromData.isNotEmpty) {
      _dispatchBySource(cleanSource: srcFromData, resolvedId: idFromData);
      return;
    }

    // 2) FALLBACK: pakai jenisProses + cari id dari bloc record (logic lama kamu)
    final cleanSource = (jenisProses ?? "").trim().toUpperCase();
    String resolvedId = "";

    if (cleanSource.isEmpty) {
      setState(() {
        _loading = false;
        _items = const [];
        _emptyText = "Belum ada proses";
        _getDateTime = null;
        _getStatusText = null;
      });
      return;
    }

    if (cleanSource == "E") {
      resolvedId = context.read<Regendors1FormBloc>().state.record?.sppa1Id ?? "";
    } else if (cleanSource == "A") {
      resolvedId = context.read<Regreaktif1Bloc>().state.record?.sppa1Id ?? "";
    } else if (cleanSource == "R") {
      resolvedId = context.read<Regrenew1FormBloc>().state.record?.sppa1Id ?? "";
    } else if (cleanSource == "O") {
      resolvedId = context.read<Regother1CrudBloc>().state.record?.regother1Id ?? "";
    }

    resolvedId = resolvedId.trim();
    if (resolvedId.isEmpty) {
      setState(() {
        _loading = false;
        _items = const [];
        _emptyText = "Belum ada proses";
        _getDateTime = null;
        _getStatusText = null;
      });
      return;
    }

    _dispatchBySource(cleanSource: cleanSource, resolvedId: resolvedId);
  }

  void _dispatchBySource({
    required String cleanSource,
    required String resolvedId,
  }) {
    switch (cleanSource) {
      case "E":
        regendors2 = context.read<Regendors2CariBloc>();
        regendors2.add(
          RefreshRegendors2CariEvent(regendors1Id: resolvedId),
        );
        break;

      case "A":
        regreaktif2formBloc = context.read<Regreaktif2CariBloc>();
        regreaktif2formBloc.add(
          RefreshRegreaktif2CariEvent(regreaktif1Id: resolvedId),
        );
        break;

      case "R":
        regrenew2formBloc = context.read<Regrenewal2CariBloc>();
        regrenew2formBloc.add(
          RefreshRegrenewal2CariEvent(regrenew1Id: resolvedId),
        );
        break;

      case "O":
        regother3cariBloc = context.read<Regother3cariBloc>();
        regother3cariBloc.add(
          RefreshRegother3cariEvent(regother1Id: resolvedId),
        );
        break;

      default:
        setState(() {
          _loading = false;
          _items = const [];
          _emptyText = "Proses tidak dikenali";
          _getDateTime = null;
          _getStatusText = null;
        });
        break;
    }
  }


  void _recomputeNewest() {
    if (_items.isEmpty || _getDateTime == null) {
      _newestDate = null;
      _activeIndex = -1;
      return;
    }

    // ambil semua tanggal yang tidak null
    final validDates = _items
        .map((e) => _getDateTime!(e))
        .where((d) => d != null)
        .cast<DateTime>()
        .toList();

    // kalau SEMUA tanggal kosong → fallback
    if (validDates.isEmpty) {
      _newestDate = null;
      _activeIndex = 0; // atau -1 kalau mau tidak ada yg nyala
      return;
    }

    // cari tanggal paling baru
    final newest = validDates.reduce((a, b) => a.isAfter(b) ? a : b);
    _newestDate = newest;

    // cari index item yg punya tanggal tersebut
    _activeIndex = _items.indexWhere(
          (e) => _getDateTime!(e)?.isAtSameMomentAs(newest) ?? false,
    );
  }



  int _findActiveIndexBySource(String prosesSource, List<dynamic> items) {
    final jp = (widget.jenisProses ?? "").trim().toUpperCase(); // "E" | "A" | "R" | ""
    final ps = prosesSource.trim().toUpperCase();

    final s = jp.isNotEmpty ? jp : ps;


    if (s.isEmpty) {
      return -1;
    }

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      switch (s) {
        case "E":
          if (item is! Regendors2CariModel) {
            continue;
          }
          if (item.regendors2Id.trim().isNotEmpty) return i;
          break;

        case "A":
          if (item is! Regreaktif2CariModel) {
            continue;
          }
          if (item.regreaktif2Id.trim().isNotEmpty) return i;
          break;

        case "R":
          if (item is! Regrenewal2CariModel) {
            continue;
          }
          if (item.regrenew2Id.trim().isNotEmpty) return i;
          break;

        case "O":
          if (item is! Regother3cariModel) {
            continue;
          }
          if (item.regother3Id.trim().isNotEmpty) return i;
          break;


        default:
          return -1;
      }
    }

    return -1;
  }


  String extractAssetIdByCob(Map<String, dynamic> dataMap, String cobId) {
    return switch (cobId) {
      "10002" => dataMap["asetParId"]?.toString() ?? "",
      "10003" => dataMap["asetMvId"]?.toString() ?? "",
      "10004" => dataMap["asetHullId"]?.toString() ?? "",
      "10005" => dataMap["asethealthId"]?.toString() ?? "",
      _ => dataMap["asetOthersId"]?.toString() ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final dataMap = _toMap(widget.data);

    String _currentProcessSource() {
      final fromData = _prosesSource.trim().toUpperCase();
      if (fromData.isNotEmpty) return fromData;

      return (widget.jenisProses ?? "").trim().toUpperCase();
    }

    void goToManagementPolis() {
      final source = _currentProcessSource();

      if (source == "O") {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const ManagementPolisPage(),
          ),
              (route) => route.isFirst,
        );
        return;
      }

      String targetStatusId;

      switch (source) {
        case "E": // Endorse
          targetStatusId = "10002";
          break;

        case "R": // Renewal
          targetStatusId = "10004";
          break;

        case "A": // Reaktif
          targetStatusId = "10003";
          break;

        default:
          targetStatusId = widget.statusId;
          break;
      }

      context.read<StatusAsetCariBloc>().add(
        SelectStatusAsetButton(targetStatusId),
      );

      int count = 0;

      Navigator.of(context).popUntil((route) {
        return count++ >= 3;
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        goToManagementPolis();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: BaseBackgroundSidePage(
            onBack: goToManagementPolis,
            title: 'Detail Manajemen Polis',
            showBackButton: false,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: secondaryBlackColor,
              child: Column(
                children: [
                  Expanded(
                    child: MultiBlocListener(
                      listeners: [
                        BlocListener<Regendors2CariBloc, Regendors2CariState>(
                          listenWhen: (prev, next) =>
                          prev.status != next.status || prev.items != next.items,
                          listener: (context, state) {
                            if (state.status == ListStatus.initial) {
                              setState(() => _loading = true);
                              return;
                            }

                            setState(() {
                              _loading = false;
                              _items = List.from(state.items);
                              _emptyText = "Belum ada proses Endorsement";
                              _getDateTime =
                                  (x) => (x as Regendors2CariModel).tglStatus;
                              _getStatusText =
                                  (x) => (x as Regendors2CariModel).progressNama;
                              _recomputeNewest();
                            });
                          },
                        ),
                        BlocListener<Regreaktif2CariBloc, Regreaktif2CariState>(
                          listenWhen: (prev, next) =>
                          prev.status != next.status || prev.items != next.items,
                          listener: (context, state) {
                            if (state.status == ListStatus.initial) {
                              setState(() => _loading = true);
                              return;
                            }

                            setState(() {
                              _loading = false;
                              _items = List.from(state.items);
                              _emptyText = "Belum ada proses Aktifkan Kembali";
                              _getDateTime =
                                  (x) => (x as Regreaktif2CariModel).tglStatus;
                              _getStatusText =
                                  (x) => (x as Regreaktif2CariModel).progressNama;
                              _recomputeNewest();
                            });
                          },
                        ),
                        BlocListener<Regrenewal2CariBloc, Regrenewal2CariState>(
                          listenWhen: (prev, next) =>
                          prev.status != next.status || prev.items != next.items,
                          listener: (context, state) {
                            if (state.status == ListStatus.initial) {
                              setState(() => _loading = true);
                              return;
                            }

                            setState(() {
                              _loading = false;
                              _items = List.from(state.items);
                              _emptyText = "Belum ada proses Perpanjang";
                              _getDateTime =
                                  (x) => (x as Regrenewal2CariModel).tglStatus;
                              _getStatusText =
                                  (x) => (x as Regrenewal2CariModel).progressNama;
                              _recomputeNewest();
                            });
                          },
                        ),
                        BlocListener<Regother3cariBloc, Regother3cariState>(
                          listenWhen: (prev, next) =>
                          prev.status != next.status || prev.items != next.items,
                          listener: (context, state) {
                            if (state.status == ListStatus.initial) {
                              setState(() => _loading = true);
                              return;
                            }

                            setState(() {
                              _loading = false;
                              _items = List.from(state.items);
                              _emptyText = "Belum ada proses Others";
                              _getDateTime =
                                  (x) => (x as Regother3cariModel).tglStatus;
                              _getStatusText =
                                  (x) => (x as Regother3cariModel).progressNama;
                            });
                          },
                        ),
                      ],
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: hPadding * 1.5,
                          // vertical: hPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PolisDetailCard(
                              cobId: widget.cobId,
                              dataMap: dataMap,
                              title: null,
                              excludeKeys: const {},
                              cardColor: pGrey,
                              borderColor: sGrey,
                              dividerColor: sGrey,
                              labelColor: hintGrey,
                              valueColor: primaryLightColor,
                              borderRadius: cardBorderRadius,
                              fontSize: (ctx, base) => getResponsiveFont(ctx, base),
                            ),
                            const SizedBox(height: 20),
                            _buildTimeline(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: secondaryBlackColor,
                    padding: EdgeInsets.only(
                      left: hPadding * 1.5,
                      right: hPadding * 1.5,
                      bottom: 0,
                    ),
                    child: AppButton(
                      text: "Kembali ke Polis",
                      onPressed: goToManagementPolis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(hPadding * 1.5),
          child: LoadingIndicator(),
        ),
      );
    }

    if (_items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: hPadding * 1.5,
          vertical: hPadding,
        ),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: sGrey),
            bottom: BorderSide(color: sGrey),
          ),
        ),
        child: Text(
          _emptyText,
          style: const TextStyle(color: primaryLightColor),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: hPadding,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: sGrey),
          bottom: BorderSide(color: sGrey),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == _items.length - 1;
            final currActive = item.tglStatus != null;
            final nextIsPlaceholder = (index < _items.length - 1)
              ? _items[index + 1].tglStatus == null
              : true;
            final isLastActive = currActive && nextIsPlaceholder;
            return TimelineItem<dynamic>(
              isLast: isLast,
              isLastActive: isLastActive,
              item: item,
              activeIndex: _activeIndex,
              getDateTime: (x) => _getDateTime!(x),
              getStatusText: (x) => _getStatusText!(x),
              activeTextColor: primaryLightColor,
              normalTextColor: hintGrey,
              activeDotColor: hintGrey,
              normalDotColor: hintGrey, index: index,
            );
          }),
        ],
      ),
    );
  }

  Map<String, dynamic> _toMap(dynamic obj) {
    if (obj == null) return {};
    if (obj is Map<String, dynamic>) return obj;
    try {
      return obj.toJson();
    } catch (_) {
      final result = <String, dynamic>{};
      obj.toString()
          .replaceAll(RegExp(r'[{}]'), '')
          .split(',')
          .forEach((pair) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          result[parts[0].trim()] = parts[1].trim();
        }
      });
      return result;
    }
  }
}
