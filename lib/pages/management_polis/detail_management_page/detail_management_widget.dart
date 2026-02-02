import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/models/regreaktif/regreaktif2cari_model.dart';
import 'package:joss_app/models/regrenewal/regrenewal2cari_model.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/pages/management_polis/detail_management_page/polis_detail_card.dart';
import 'package:joss_app/pages/management_polis/detail_management_page/timeline_page.dart';
import '../../../../../common/constants.dart';
import '../../../../../widgets/apptheme/help_contact_card_widget.dart';
import 'package:joss_app/models/gen_endors/endors2cari_model.dart';

import '../../../blocs/regendors/regendors1form_bloc.dart';
import '../../../blocs/regendors/regendors2cari_bloc.dart';
import '../../../blocs/regreaktif/regreaktif1_bloc.dart';
import '../../../blocs/regreaktif/regreaktif2cari_bloc.dart';
import '../../../blocs/regrenewal/regrenew1form_bloc.dart';
import '../../../blocs/regrenewal/regrenewal2cari_bloc.dart';
import '../../../models/regendors/regendors2cari_model.dart';

class DetailManagementPolisPage extends StatefulWidget {
  final dynamic data;
  final String cobId;

  /// statusId masih diterima biar ga breaking API pemanggil,
  /// tapi tidak dipakai buat routing tracking proses.
  final String statusId;

  const DetailManagementPolisPage({
    super.key,
    required this.data,
    required this.cobId,
    required this.statusId,
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

  /// NEW: proses discriminator
  late final String _prosesSource; // "E" | "R" | "A" | ""
  late final String _prosesId;
  late final String _prosesRemarks;

  late Regendors1FormBloc regendors1;
  late Regendors2CariBloc regendors2;

  late Regreaktif1Bloc regreaktif1formBloc;
  late Regreaktif2CariBloc regreaktif2formBloc;

  late Regrenew1FormBloc regrenew1formBloc;
  late Regrenewal2CariBloc regrenew2formBloc;

  DateTime Function(dynamic item)? _getDateTime;
  String Function(dynamic item)? _getStatusText;
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

    _triggerByProses(
      prosesSource: _prosesSource,
      prosesId: _prosesId,
    );
  }

  /// NEW: routing tracking berdasarkan prosesSource + prosesId
  void _triggerByProses({
    required String prosesSource,
    required String prosesId,
  }) {
    // Kalau tidak ada proses, langsung tampilkan empty state
    if (prosesSource.isEmpty || prosesId.isEmpty) {
      setState(() {
        _loading = false;
        _items = const [];
        _emptyText = "Belum ada proses";
        _getDateTime = null;
        _getStatusText = null;
      });
      return;
    }

    switch (prosesSource) {
      case "E":
        regendors2 = context.read<Regendors2CariBloc>();
        regendors2.add(
          RefreshRegendors2CariEvent(regendors1Id: prosesId),
        );
        break;

      case "A":
        regreaktif2formBloc = context.read<Regreaktif2CariBloc>();
        regreaktif2formBloc.add(
          RefreshRegreaktif2CariEvent(regreaktif1Id: prosesId),
        );
        break;

      case "R":
        regrenew2formBloc = context.read<Regrenewal2CariBloc>();
        regrenew2formBloc.add(
          RefreshRegrenewal2CariEvent(regrenew1Id: prosesId),
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

  String extractAssetIdByCob(Map<String, dynamic> dataMap, String cobId) {
    return switch (cobId) {
      "10002" => dataMap["asetParId"]?.toString() ?? "",
      "10003" => dataMap["asetMvId"]?.toString() ?? "",
      "10004" => dataMap["asetHullId"]?.toString() ?? "",
      "10005" => dataMap["asethealthId"]?.toString() ?? "",
      "10006" => dataMap["asetOthersId"]?.toString() ?? "",
      _ => "",
    };
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final dataMap = _toMap(widget.data);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: 'Detail Management Polis',
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: secondaryBlackColor,
            child: MultiBlocListener(
              listeners: [
                BlocListener<Regendors2CariBloc, Regendors2CariState>(
                  listenWhen: (prev, next) =>
                  prev.status != next.status || prev.items != next.items,
                  listener: (context, state) {
                    if (!mounted) return;
                    if (_prosesSource != "E") return; // 🔐 GUARD

                    if (state.status == ListStatus.initial) {
                      setState(() => _loading = true);
                      return;
                    }

                    setState(() {
                      _loading = false;
                      _items = List.from(state.items);
                      _emptyText = "Belum ada proses Endorsement";
                      _getDateTime = (x) => (x as Regendors2CariModel).tglStatus;
                      _getStatusText = (x) => (x as Regendors2CariModel).remarks;
                    });
                  },
                ),

                BlocListener<Regreaktif2CariBloc, Regreaktif2CariState>(
                  listenWhen: (prev, next) =>
                  prev.status != next.status || prev.items != next.items,
                  listener: (context, state) {
                    if (!mounted) return;
                    if (_prosesSource != "A") return; // 🔐 GUARD

                    if (state.status == ListStatus.initial) {
                      setState(() => _loading = true);
                      return;
                    }

                    setState(() {
                      _loading = false;
                      _items = List.from(state.items);
                      _emptyText = "Belum ada proses Aktifkan Kembali";
                      _getDateTime = (x) => (x as Regreaktif2CariModel).tglStatus;
                      _getStatusText = (x) => (x as Regreaktif2CariModel).remarks;
                    });
                  },
                ),

                BlocListener<Regrenewal2CariBloc, Regrenewal2CariState>(
                  listenWhen: (prev, next) =>
                  prev.status != next.status || prev.items != next.items,
                  listener: (context, state) {
                    if (!mounted) return;
                    if (_prosesSource != "R") return; // 🔐 GUARD

                    if (state.status == ListStatus.initial) {
                      setState(() => _loading = true);
                      return;
                    }

                    setState(() {
                      _loading = false;
                      _items = List.from(state.items);
                      _emptyText = "Belum ada proses Perpanjang";
                      _getDateTime = (x) => (x as Regrenewal2CariModel).tglStatus;
                      _getStatusText = (x) => (x as Regrenewal2CariModel).remaks;
                    });
                  },
                ),
              ],
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: hPadding * 1.5,
                  vertical: hPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PolisDetailCard(
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
                    const SizedBox(height: 20),
                    HelpContactCardWidget(
                      title: "Butuh bantuan?",
                      contactText:
                      "Hubungi 021-123456 atau support@email.com",
                      onPressed: () =>
                          debugPrint("☎️ Tombol Hubungi diklik!"),
                    ),
                  ],
                ),
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
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
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

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TimelineItem<dynamic>(
                item: item,
                isLast: isLast,
                getDateTime: (x) => _getDateTime!(x),
                getStatusText: (x) => _getStatusText!(x),
                lastTextColor: primaryLightColor,
                normalTextColor: hintGrey,
                lastDotColor: primaryColor,
                normalDotColor: hintGrey,
              ),
            );
          }).toList(),
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
