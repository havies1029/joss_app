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

    _loading = true;

    _triggerByRule(sppa1Id: _sppa1Id);
  }

  void _triggerByRule({required String sppa1Id}) {
    switch (widget.statusId) {
      case "10001":
      // TODO: rule untuk status "aktif"
        break;

      case "10002":
        regendors1 = context.read<Regendors1FormBloc>();
        regendors2 = context.read<Regendors2CariBloc>();
        final regendors1FormState = context.read<Regendors1FormBloc>().state;
        final String selectedId =
            regendors1FormState.record?.regendors1Id ?? '';

        if (selectedId.isNotEmpty) {
          regendors2.add(RefreshRegendors2CariEvent(regendors1Id: selectedId),);
        }
        break;

      case "10003":
        regreaktif1formBloc = context.read<Regreaktif1Bloc>();
        regreaktif2formBloc = context.read<Regreaktif2CariBloc>();
        final regreaktif1FormState = context.read<Regreaktif1Bloc>().state;

        final String selectedId =
            regreaktif1FormState.record?.sppa1Id ?? '';

        if (selectedId.isNotEmpty) {
          regreaktif2formBloc.add(
            RefreshRegreaktif2CariEvent(regreaktif1Id: selectedId),
          );
        }
        break;

      case "10004":
        regrenew1formBloc = context.read<Regrenew1FormBloc>();
        regrenew2formBloc = context.read<Regrenewal2CariBloc>();
        final regrenew1FormState = context.read<Regrenew1FormBloc>().state;

        final String selectedId =
            regrenew1FormState.record?.sppa1Id ?? '';

        if (selectedId.isNotEmpty) {
          regrenew2formBloc.add(
            RefreshRegrenewal2CariEvent(regrenew1Id: selectedId),
          );
        }
        break;

      default:
      // TODO: default rule
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
                  prev.status != next.status ||
                      prev.items != next.items,
                  listener: (context, state) {
                    if (!mounted) return;

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
                  prev.status != next.status ||
                      prev.items != next.items,
                  listener: (context, state) {
                    if (!mounted) return;

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
                  prev.status != next.status ||
                      prev.items != next.items,
                  listener: (context, state) {
                    if (!mounted) return;

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
                      fontSize: (ctx, base) =>
                          getResponsiveFont(ctx, base),
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
        child: const Text(
          "Belum ada proses endorsement",
          style: TextStyle(color: primaryLightColor),
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
      obj.toString().replaceAll(RegExp(r'[{}]'), '').split(',').forEach((pair) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          result[parts[0].trim()] = parts[1].trim();
        }
      });
      return result;
    }
  }
}



/*

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import '../../../../../common/constants.dart';
import '../../../../../widgets/apptheme/help_contact_card_widget.dart';
import 'package:joss_app/blocs/gen_endors/endors2cari_bloc.dart';
import 'package:joss_app/models/gen_endors/endors2cari_model.dart';

import '../../../blocs/gen_aset_par/asetparcari_bloc.dart';
import '../../../blocs/gen_status_aset/statusasetcari_bloc.dart';
import '../../../blocs/regendors/regendors1form_bloc.dart';
import '../../../blocs/regendors/regendors2cari_bloc.dart';
import '../../../models/regendors/regendors2cari_model.dart';

class DetailManagementPolisPage extends StatefulWidget {
  final dynamic data;
  final String cobId;

  const DetailManagementPolisPage({
    super.key,
    required this.data,
    required this.cobId,
  });

  @override
  State<DetailManagementPolisPage> createState() =>
      _DetailManagementPolisPageState();
}
class _DetailManagementPolisPageState
    extends State<DetailManagementPolisPage> {
  late Regendors2CariBloc? regendors2;
  late Regendors1FormBloc? regendors1;
  late Map<String, dynamic> dataMap;
  late String sppa1Id;

  @override
  void initState() {
    super.initState();

    regendors2 = context.read<Regendors2CariBloc>();
    regendors1 = context.read<Regendors1FormBloc>();
    final regendors1FormState = context.read<Regendors1FormBloc>().state;

    final String selectedId =
        regendors1FormState.record?.regendors1Id ?? '';

    if (selectedId.isNotEmpty) {
      regendors2?.add(
        RefreshRegendors2CariEvent(regendors1Id: selectedId),
      );
    }

    debugPrint("selectedId (from saved data): $selectedId");
  }

  String extractAssetIdByCob(
      Map<String, dynamic> dataMap,
      String cobId,
      ) {
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
    final Map<String, dynamic> dataMap = _toMap(widget.data);
    final sppa1Id = extractAssetIdByCob(dataMap, widget.cobId);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: 'Detail Management Polis',
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: secondaryBlackColor,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: hPadding * 1.5,
                vertical: hPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 CARD DETAIL POLIS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: pGrey,
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                      border: Border.all(color: sGrey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nomor urut
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "No:",
                              style: TextStyle(
                                color: hintGrey,
                                fontSize: getResponsiveFont(context, 16),
                              ),
                            ),
                            Text(
                              dataMap["no"]?.toString() ?? "1",
                              style: TextStyle(
                                color: primaryLightColor,
                                fontSize: getResponsiveFont(context, 16),
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: sGrey, height: 20),

                        // Loop data dinamis
                        ...dataMap.entries.map((entry) {
                          final label = _beautifyKey(entry.key);
                          final value = entry.value?.toString() ?? "-";

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "$label:",
                                    style: TextStyle(
                                      color: hintGrey,
                                      fontSize: getResponsiveFont(context, 16),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: primaryLightColor,
                                        fontSize: getResponsiveFont(context, 16),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  BlocBuilder<Regendors2CariBloc, Regendors2CariState>(
                    builder: (context, state) {
                      if (state.status == ListStatus.initial) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (state.items.isEmpty) {
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
                          child: const Text(
                            "Belum ada proses endorsement",
                            style: TextStyle(color: primaryLightColor),
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
                            ...state.items.asMap().entries.map((entry) {
                              final index = entry.key;
                              final Regendors2CariModel item = entry.value;
                              final isLast = index == state.items.length - 1;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _buildTimelineItemRegendors(item, isLast),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 🔹 HELP CONTACT CARD (tetap)
                  HelpContactCardWidget(
                    title: "Butuh bantuan?",
                    contactText: "Hubungi 021-123456 atau support@email.com",
                    onPressed: () {
                      debugPrint("☎️ Tombol Hubungi diklik!");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItemRegendors(Regendors2CariModel item, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 82,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMM yyyy,').format(item.tglStatus),
                style: TextStyle(
                  color: isLast ? primaryLightColor : hintGrey,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat('HH:mm:ss').format(item.tglStatus),
                style: TextStyle(
                  color: isLast ? primaryLightColor : hintGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Column(
          children: [
            Icon(
              Icons.circle,
              size: 12,
              color: isLast ? primaryColor : hintGrey,
            ),
            if (!isLast)
              Container(
                width: 1.26,
                height: 30,
                color: hintGrey,
              ),
          ],
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            item.remarks,
            style: TextStyle(
              color: isLast ? primaryLightColor : hintGrey,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _toMap(dynamic obj) {
    if (obj == null) return {};
    if (obj is Map<String, dynamic>) return obj;
    try {
      return obj.toJson();
    } catch (_) {
      final result = <String, dynamic>{};
      obj.toString().replaceAll(RegExp(r'[{}]'), '').split(',').forEach((pair) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          result[parts[0].trim()] = parts[1].trim();
        }
      });
      return result;
    }
  }

  String _beautifyKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}')
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((w) => w.isEmpty
        ? ''
        : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }
}
 */