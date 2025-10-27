import 'package:flutter/material.dart';
import '../../../../../common/constants.dart';
import '../../../../../widgets/apptheme/help_contact_card_widget.dart';
import '../../../../base/base_background_sidepage.dart';

class DetailManagementPolisPage extends StatelessWidget {
  final dynamic data; // Bisa model apa pun: MV, Health, PAR

  const DetailManagementPolisPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final Map<String, dynamic> dataMap = _toMap(data);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: 'Detail Management Polis',
          child: Container(
            width: double.infinity,
            height: double.infinity, // ✅ penuh layar
            color: secondaryBlackColor, // ✅ background utama
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: hPadding * 1.5, // jarak kiri-kanan
                vertical: hPadding * 1.2,
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

                  // 🔹 HELP CONTACT CARD (reusable)
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

  /// 🔧 Convert object ke Map
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

  /// 🪄 Rapihin key biar enak dibaca
  String _beautifyKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}')
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((w) =>
    w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }
}
