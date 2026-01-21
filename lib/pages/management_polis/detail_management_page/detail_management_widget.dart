import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import '../../../../../common/constants.dart';
import '../../../../../widgets/apptheme/help_contact_card_widget.dart';
import 'package:joss_app/blocs/gen_endors/endors2cari_bloc.dart';
import 'package:joss_app/models/gen_endors/endors2cari_model.dart';

class DetailManagementPolisPage extends StatelessWidget {
  final dynamic data;
  final String cobId;

  const DetailManagementPolisPage({
    super.key,
    required this.data,
    required this.cobId,
  });

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
    final Map<String, dynamic> dataMap = _toMap(data);
    final sppa1Id = extractAssetIdByCob(dataMap, cobId);

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

                  BlocProvider(
                    create: (_) => Endors2CariBloc()
                      ..add(RefreshEndors2CariEvent(sppa1Id: sppa1Id)),
                    child: BlocBuilder<Endors2CariBloc, Endors2CariState>(
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
                            decoration: BoxDecoration(
                              border: const Border(
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
                          decoration: BoxDecoration(
                            border: const Border(
                              top: BorderSide(color: sGrey),
                              bottom: BorderSide(color: sGrey),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...state.items.asMap().entries.map((entry) {
                                int index = entry.key;
                                Endors2CariModel item = entry.value;
                                bool isLast = index == state.items.length - 1;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _buildTimelineItem(item, isLast),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 HELP CONTACT CARD
                  HelpContactCardWidget(
                    title: "Butuh bantuan?",
                    contactText:
                    "Hubungi 021-123456 atau support@email.com",
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

  Widget _buildTimelineItem(Endors2CariModel item, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 82,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMM yyyy,').format(item.statusTgl),
                style: TextStyle(
                  color: isLast ? primaryLightColor : hintGrey,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat('HH:mm:ss').format(item.statusTgl),
                style: TextStyle(
                  color: isLast ? primaryLightColor : hintGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        // Timeline indicator
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
        // Right side - Status text
        Expanded(
          child: Text(
            item.statusEndors,
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
